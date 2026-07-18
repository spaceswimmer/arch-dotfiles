# Arch + Hyprland Dotfiles

A safe, copy-based snapshot of one Arch Linux and Hyprland setup. Live files in `$HOME` remain authoritative; this repository stores an allowlisted snapshot and package intent for recovery.

## Safety First

This repository is public. Treat every source config as potentially sensitive.

- Never commit passwords, tokens, API keys, private keys, cookies, histories, databases, VPN profiles, connection profiles, or browser/session state.
- Never add a broad home directory to `manifests/allowlist.txt`. Inspect every new path first.
- Never print a detected secret. Scanner output must remain path-only and redacted.
- Never bypass `bin/verify`, weaken hard denials, or add broad scanner exceptions.
- `.gitignore` is convenience, not a security boundary. The allowlist and scanner are the boundaries.
- If a secret reaches Git, stop automation, rotate/revoke it, remove it from history, then resume.

See `AGENTS.md` and `docs/secrets.md` before changing enrollment or automation.

## Daily Use

```bash
# Preview changes from live config into the repository.
bin/sync

# Apply the snapshot and verify it before replacing repository files.
bin/sync --apply
bin/update-packages
bin/verify

git diff -- home packages
```

The sync command is dry-run by default. It validates exact home-relative paths, rejects sensitive names/trees, rejects special files and escaping symlinks, builds a temporary snapshot, normalizes known home paths, and scans before updating `home/`.

## Restore On A Fresh Arch System

```bash
git clone git@github.com:spaceswimmer/arch-dotfiles.git \
  "$HOME/Projects/personal/arch-dotfiles"
cd "$HOME/Projects/personal/arch-dotfiles"

bin/bootstrap --check
bin/bootstrap --packages       # interactive; official packages only
bin/restore                    # preview
bin/restore --apply            # backs up conflicts first
bin/enable-user-units
```

Conflicts are backed up under `$XDG_STATE_HOME/arch-dotfiles/backups/` or `~/.local/state/arch-dotfiles/backups/`. Restore never deletes unrelated home files.

Review `packages/foreign.txt` manually. It mixes AUR and locally sourced packages; no foreign package is built automatically. Review `docs/restore.md` for the remaining system-level steps.

## Weekly Updates

Install the user timer:

```bash
bin/install-timer
systemctl --user status arch-dotfiles-sync.timer
journalctl --user -u arch-dotfiles-sync.service
```

The timer runs Sunday around 18:00 with a randomized delay. `Persistent=true` catches a missed run after the next login. It does not run while fully logged out unless user lingering is enabled.

Automation aborts on a dirty repository, non-`main` branch, diverged/ahead history, failed scan, missing SSH authentication, or push failure. It never stashes, rebases, force-pushes, or resolves conflicts.

## Scope

Included: Hyprland, Hypridle, Hyprlock, Hyprpaper, Waybar, SwayNC, Rofi, Kitty, shell, selected editors/XDG preferences, safe user units, a wallpaper, and explicit package manifests.

Excluded: credentials and private state, exact package binaries/versions, system files under `/etc`, user data, caches, downloaded applications, and most application profiles. Full-machine recovery therefore also needs a separate encrypted backup whose key is stored outside this repository.
