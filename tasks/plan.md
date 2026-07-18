# Implementation Plan: Arch Dotfiles Repository

## Overview

Build a copy-based, allowlisted dotfiles snapshot with a defense-in-depth secret gate, package intent manifests, cautious restore tooling, and a weekly user systemd timer.

## Architecture Decisions

- Keep live configuration authoritative to avoid breaking the current desktop.
- Use exact allowlist entries plus hard-coded sensitive path/name denials.
- Use a built-in scanner so verification fails safely even when Gitleaks is unavailable; run Gitleaks additionally when installed.
- Use systemd user automation because it is already available and supports persistent missed runs and logs.
- Do not automate foreign package builds or repository configuration because AUR and testing repositories require review.

## Task List

### Phase 1: Safety Foundation

- [ ] Add isolated tests for sync, restore, and secret verification.
- [ ] Implement shared path validation and repository verification.
- [ ] Implement dry-run-first sync and restore.

### Checkpoint: Safety Foundation

- [ ] All isolated tests pass.
- [ ] Unsafe allowlist entries and synthetic secrets are rejected.

### Phase 2: Recoverable Snapshot

- [ ] Add package manifest generation and bootstrap guidance.
- [ ] Snapshot allowlisted configuration.
- [ ] Sanitize repository copies of host-specific paths and exclude private state.

### Checkpoint: Recoverable Snapshot

- [ ] Dry-run sync is clean after snapshot.
- [ ] Restore preview lists only intended destinations.

### Phase 3: Automation and Documentation

- [ ] Add fail-closed weekly Git synchronization.
- [ ] Add and install user systemd service/timer.
- [ ] Document usage, security boundaries, and fresh-system restoration.

### Checkpoint: Complete

- [ ] Tests, syntax checks, scans, and systemd verification pass.
- [ ] Independent code and security reviews have no blocking findings.
- [ ] Commit is pushed and timer is enabled.

## Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Credential enters an allowed directory | High | Hard denials, built-in content scan, optional Gitleaks, staged-diff scan |
| Restore overwrites useful local config | High | Dry-run default and timestamped backups |
| Weekly job conflicts with user edits | Medium | Abort on dirty/diverged state; fast-forward only |
| Hardware-specific config fails elsewhere | Medium | Document and isolate machine-specific overrides where supported |
| Package list is not byte-for-byte reproducible | Low | Record intent, separate foreign packages, document rolling-release limits |

## Open Questions

- None blocking.
