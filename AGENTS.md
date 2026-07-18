# Agent Rules

This is a public dotfiles repository. Security takes precedence over convenience.

## Always

- Run `bash tests/run` and `bin/verify` before committing.
- Preview `bin/sync` and `bin/restore` before using `--apply`.
- Inspect every file below a proposed allowlist entry for secrets and private metadata.
- Keep source entries home-relative, exact, and minimal.
- Preserve restore conflicts in timestamped backups.
- Keep machine-local or sensitive values outside this repository.
- Stage only intended repository paths and use normal fast-forward pushes.

## Ask First

- Adding or broadening any allowlist entry.
- Enabling a new service or third-party/testing package repository.
- Changing the secret scanner or automation schedule.
- Adding encrypted secret material. The recovery key must never share this repository.

## Never

- Add credentials, passwords, tokens, private/public key inventories, cookies, histories, databases, connection profiles, host inventories, or application sessions.
- Read or reproduce secret values in logs, commits, issues, or agent output.
- Treat `.gitignore` as a security control or bypass `bin/verify`.
- Add broad false-positive exceptions to make a scan pass.
- Force-push, rewrite shared history, automatically build foreign packages, remove packages, or silently enable Arch testing repositories.
- Replace live config with symlinks or delete unrelated files from `$HOME`.

If a credential is committed, stop all pushes, rotate it first, purge it from Git history, and verify the full history before resuming.
