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

## Secure Boot (dual boot with Windows)

One-time setup, not done by `install.sh` because it needs the firmware menu:

1. `sudo sbctl create-keys`
2. Add `ENABLE_ENROLL_LIMINE_CONFIG=yes` to `/etc/default/limine`, then `sudo limine-update`.
   This embeds the `limine.conf` checksum in Limine and signs it with sbctl.
   It happens again on every kernel update and snapshot, so nothing else needs signing.
   Limine checks the UKIs against the hashes in `limine.conf`.
3. Firmware: clear the Secure Boot keys (Setup Mode). Leave Secure Boot off.
4. `sudo sbctl enroll-keys -m`. The `-m` keeps Microsoft's keys so Windows still boots.
5. Firmware: turn Secure Boot on. Keep Limine first in the boot order.

Don't edit `/boot/limine.conf` by hand. Limine won't boot it unless `limine-update` re-enrolls the new checksum.
