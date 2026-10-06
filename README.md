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
- `dotfiles/mise/config.toml` — global mise tools, for CLIs that are missing or stale in the Arch repos/AUR (e.g. Datadog `pup`)
- `claude/` — Claude Code work/personal account split (see below)

To add an app, put it in the right list and re-run `install.sh`.
To track a config file, move it into `dotfiles/` and re-run `install.sh`.

Secrets live in `~/.config/fish/secrets.fish`, which is never committed.
`install.sh` creates it from `dotfiles/fish/secrets.fish.example` if missing.

## Claude Code: work and personal accounts

Anything under the work directory uses the work subscription; everywhere else uses the personal one.
The work directory is `CLAUDE_WORK_DIR` in `~/.config/fish/secrets.fish` (`install.sh` asks for it).
`claude/work/mise.toml` is linked into that directory and sets `CLAUDE_CONFIG_DIR=~/.claude-work` there,
which both the CLI and Zed's Claude agent pick up.

The active account is labelled in the status line (🔴 WORK / 🟢 PERSONAL) and, for Zed,
at the top of each reply via the account's `CLAUDE.md`.

One-time login for the work account: `claude` from inside the work directory, then `/login`.

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
