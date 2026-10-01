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

echo "==> Fish"
fish -c 'fisher update' >/dev/null
if [ ! -f ~/.config/fish/secrets.fish ]; then
  install -m 600 "$REPO/dotfiles/fish/secrets.fish.example" ~/.config/fish/secrets.fish
  echo "    created ~/.config/fish/secrets.fish from template - fill it in"
fi
if [ "$(getent passwd "$USER" | cut -d: -f7)" != /usr/bin/fish ]; then
  chsh -s /usr/bin/fish
fi

echo "Done. Log out and back in for shell changes to take effect."
