#!/bin/bash
# Reproduce this Omarchy setup. Safe to re-run: installed packages and existing links are skipped.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"

# Print a package list without comments or blank lines
list() { sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$REPO/packages/$1"; }

echo "==> Arch packages"
mapfile -t pkgs < <(list pacman.txt)
(( ${#pkgs[@]} )) && omarchy pkg add "${pkgs[@]}"

echo "==> AUR packages"
mapfile -t aur < <(list aur.txt)
(( ${#aur[@]} )) && omarchy pkg aur add "${aur[@]}"

echo "==> Omarchy installers"
while read -r line; do
  # shellcheck disable=SC2086
  omarchy install $line
done < <(list omarchy.txt)

echo "==> Removing unused Omarchy apps"
mapfile -t drop < <(list remove.txt)
(( ${#drop[@]} )) && omarchy pkg drop "${drop[@]}"
while IFS= read -r app; do
  [ -f "$HOME/.local/share/applications/$app.desktop" ] && omarchy webapp remove "$app"
done < <(list webapps-remove.txt)

echo "==> Dotfiles"
# Symlink every file under dotfiles/<app>/ into ~/.config/<app>/, backing up anything in the way
link() {
  local src="$1" dst="$2"
  [ "$(readlink "$dst" 2>/dev/null)" = "$src" ] && return
  mkdir -p "$(dirname "$dst")"
  [ -e "$dst" ] && mv "$dst" "$dst.bak.$(date +%s)" && echo "    backed up $dst"
  ln -s "$src" "$dst" && echo "    linked $dst"
}
while IFS= read -r -d '' src; do
  rel="${src#"$REPO/dotfiles/"}"
  [[ "$rel" == *.example ]] && continue
  link "$src" "$HOME/.config/$rel"
done < <(find "$REPO/dotfiles" -type f -print0)

echo "==> GTK theme"
# Omarchy renders dotfiles/omarchy/themed/gtk.css.tpl into the current theme on every theme change
link "$HOME/.local/state/omarchy/current/theme/gtk.css" "$HOME/.config/gtk-4.0/gtk.css"

echo "==> Firefox theme"
# Link the default profile's userChrome.css to Omarchy's rendered firefox.css (Firefox must have run once)
ff="$HOME/.config/mozilla/firefox"
profile=$(sed -n 's/^Default=//p' "$ff/installs.ini" 2>/dev/null | head -1)
if [ -n "$profile" ] && [ -d "$ff/$profile" ]; then
  link "$HOME/.local/state/omarchy/current/theme/firefox.css" "$ff/$profile/chrome/userChrome.css"
  pref='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
  grep -qxF "$pref" "$ff/$profile/user.js" 2>/dev/null || echo "$pref" >> "$ff/$profile/user.js"
else
  echo "    no Firefox profile yet - open Firefox once, then re-run"
fi

echo "==> Display"
# Text size in px across shell, GTK and terminals (Omarchy default 12; bumped for the 3440x1440 ultrawide)
omarchy display text size 13
omarchy theme bg set "$HOME/.config/omarchy/backgrounds/tokyo-night/minimal-sunset.jpg"

echo "==> Fish"
fish -c 'fisher update' >/dev/null
secrets="$HOME/.config/fish/secrets.fish"
if [ ! -f "$secrets" ]; then
  install -m 600 "$REPO/dotfiles/fish/secrets.fish.example" "$secrets"
  echo "    created $secrets from template"
fi
# Prompt for every template variable that is empty in secrets.fish; the template's trailing comment describes it
while IFS= read -r -u 3 line; do
  [[ "$line" =~ ^set\ -gx\ ([A-Za-z0-9_]+)\ .*#\ (.*)$ ]] || continue
  var="${BASH_REMATCH[1]}" desc="${BASH_REMATCH[2]}"
  # Check secrets.fish alone: no fish config (it sources secrets.fish too), no inherited value, no stdin
  env -u "$var" fish --no-config -c "source '$secrets'; test -n \"\$$var\"" </dev/null && continue
  if [ ! -t 0 ]; then
    echo "    $var is empty - re-run install.sh in a terminal to set it"
    continue
  fi
  # Hide input for credentials, show it for plain settings like hosts and ports
  hide=; [[ "$var" =~ TOKEN|PASSWORD|SECRET|KEY ]] && hide=-s
  read -r $hide -p "    $var - $desc (Enter to skip): " value
  [ -n "$hide" ] && echo
  [ -n "$value" ] || continue
  value="${value//\\/\\\\}"; value="${value//\'/\\\'}" # escape for a fish single-quoted string
  tmp="$(mktemp "$secrets.XXXXXX")" # mktemp creates it 600, so the secret is never world-readable
  NEW="set -gx $var '$value'" VAR="$var" awk '
    $0 ~ "^set -gx " ENVIRON["VAR"] "( |$)" { print ENVIRON["NEW"]; done = 1; next } { print }
    END { if (!done) print ENVIRON["NEW"] }' "$secrets" > "$tmp"
  mv "$tmp" "$secrets"
done 3< "$REPO/dotfiles/fish/secrets.fish.example"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != /usr/bin/fish ]; then
  chsh -s /usr/bin/fish
fi

echo "==> Claude Code accounts"
# Personal subscription lives in ~/.claude. Under CLAUDE_WORK_DIR (set in secrets.fish), mise sets
# CLAUDE_CONFIG_DIR=~/.claude-work so the CLI and Zed use the work subscription.
# Each account's CLAUDE.md and status line label which one is active.
WORK_DIR="$(fish --no-config -c "source '$secrets'; echo \$CLAUDE_WORK_DIR" </dev/null)"
WORK_DIR="${WORK_DIR/#\~/$HOME}"
link "$REPO/claude/statusline.sh" "$HOME/.claude/statusline.sh"
for account in personal:.claude work:.claude-work; do
  dir="$HOME/${account#*:}"
  link "$REPO/claude/${account%%:*}/CLAUDE.md" "$dir/CLAUDE.md"
  # Claude Code rewrites settings.json, so merge the status line in rather than linking the file
  settings="$dir/settings.json"
  [ -f "$settings" ] || echo '{}' > "$settings"
  jq '.statusLine = {type: "command", command: "~/.claude/statusline.sh"}' "$settings" > "$settings.tmp"
  mv "$settings.tmp" "$settings"
done
if [ -n "$WORK_DIR" ]; then
  link "$REPO/claude/work/mise.toml" "$WORK_DIR/mise.toml"
  mise trust --quiet "$WORK_DIR/mise.toml"
  [ -f ~/.claude-work/.credentials.json ] || echo "    work account not logged in - run claude in $WORK_DIR, then /login"
else
  echo "    CLAUDE_WORK_DIR not set - everything uses the personal account"
fi

echo "Done. Log out and back in for shell changes to take effect."
