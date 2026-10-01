# omarchy-setup

Reproducible setup for my Omarchy machine.

On a fresh Omarchy install:

```sh
git clone <this repo> ~/Work/omarchy-setup
~/Work/omarchy-setup/install.sh
```

## Layout

- `packages/pacman.txt` — Arch packages (`omarchy pkg add`)
- `packages/aur.txt` — AUR packages (`omarchy pkg aur add`)
- `packages/omarchy.txt` — Omarchy installers (`omarchy install ...`)
- `dotfiles/<app>/...` — symlinked into `~/.config/<app>/...`

To add an app, put it in the right list and re-run `install.sh`.
To track a config file, move it into `dotfiles/` and re-run `install.sh`.

Secrets live in `~/.config/fish/secrets.fish`, which is never committed.
`install.sh` creates it from `dotfiles/fish/secrets.fish.example` if missing.
