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
