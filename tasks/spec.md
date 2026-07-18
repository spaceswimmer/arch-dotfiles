# Spec: Arch Dotfiles Repository

## Objective

Create a safe, public Git repository that snapshots the user's Arch Linux and Hyprland configuration, records package intent, supports cautious restoration on another machine, and updates daily without ever committing credentials or private runtime state.

## Tech Stack

- POSIX-oriented Bash with standard Arch tools: Git, rsync, pacman, systemd, and optionally Gitleaks.
- A mirrored `home/` tree. Live files remain authoritative and are not replaced with symlinks.
- A user-level systemd timer for daily automation.

## Commands

- Test: `bash tests/run`
- Verify repository: `bin/verify`
- Preview snapshot: `bin/sync`
- Apply snapshot: `bin/sync --apply`
- Preview restore: `bin/restore`
- Apply restore: `bin/restore --apply`
- Refresh package manifests: `bin/update-packages`
- Install automation: `bin/install-timer`

## Project Structure

- `home/`: sanitized home-relative configuration snapshot.
- `manifests/`: source allowlist and enabled user units.
- `packages/`: official and foreign explicit package intent.
- `bin/`: snapshot, restore, verification, and automation commands.
- `systemd/user/`: daily synchronization unit and timer.
- `tests/`: isolated shell integration tests.
- `docs/`: restoration, secret handling, and machine notes.
- `tasks/`: specification and implementation records.

## Code Style

Shell scripts use `#!/usr/bin/env bash`, `set -euo pipefail`, quoted expansions, explicit error messages, and conservative defaults. Mutating operations require `--apply` where practical.

```bash
if [[ $path == /* || $path == *".."* ]]; then
  printf 'unsafe path: %s\n' "$path" >&2
  exit 1
fi
```

## Testing Strategy

Shell integration tests run against temporary HOME and repository fixtures. They prove allowlist validation, hard denials, dry-run behavior, backup-before-restore, secret detection, and verification of required files. Final checks include Bash syntax, systemd unit validation, Git diff checks, and a scan of both files and Git history.

## Boundaries

- Always: use an explicit allowlist, redact scan output, back up restore conflicts, and abort unattended Git work on unsafe state.
- Ask first: enroll a new config tree, add a third-party repository, enable system services, or store encrypted secrets.
- Never: commit keys, tokens, passwords, cookies, histories, databases, connection profiles, private host inventories, or secret scanner exceptions; force-push; delete unrelated home files; silently enable testing repositories.

## Success Criteria

- Safe Arch/Hyprland, shell, editor, and user-service configuration is present under `home/` and contains no known credentials.
- Explicit official and foreign package manifests are recorded without version pinning.
- Snapshot and restore are dry-run by default and pass isolated tests.
- Daily automation verifies, commits, and pushes only expected paths, while failing closed on scan or Git errors.
- README and AGENTS guidance warn humans and agents about secret handling and recovery limitations.
- The repository is pushed to `git@github.com:spaceswimmer/arch-dotfiles.git` and the user timer is enabled.

## Open Questions

None blocking. Full secret/data restoration intentionally remains a separate encrypted-backup concern.
