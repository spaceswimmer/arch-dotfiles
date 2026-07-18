# Tasks

- [ ] Implement and test repository safety controls.
  - Acceptance: unsafe paths and synthetic secrets are rejected.
  - Verify: `bash tests/run`
- [ ] Capture and sanitize allowlisted configuration.
  - Acceptance: current desktop configuration is represented without private state.
  - Verify: `bin/sync && bin/verify`
- [ ] Add package and restore workflows.
  - Acceptance: explicit packages are listed and restore is backup-first.
  - Verify: `bin/update-packages --check && bin/restore`
- [ ] Add daily automation and documentation.
  - Acceptance: timer is enabled and README/AGENTS define safe operation.
  - Verify: `systemctl --user status arch-dotfiles-sync.timer`
- [ ] Review and publish.
  - Acceptance: security and quality reviews pass; remote `main` contains the commit.
  - Verify: `git status --short --branch && git ls-remote origin refs/heads/main`
