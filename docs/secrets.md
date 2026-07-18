# Secrets And Private State

The public snapshot intentionally excludes all authentication and private runtime state, including:

- `~/.ssh`, `~/.gnupg`, `~/.wg`, and WireGuard/system VPN profiles.
- `~/.config/rclone`, `~/.config/wayvnc`, Remmina, FreeRDP, and NetworkManager connections.
- `~/.local/share/keyrings`, KWallet, OpenCode authentication/account state, and password stores.
- Browser, mail, chat, Nextcloud, cookies, histories, logs, databases, and sessions.

These need a separate encrypted backup. Keep its recovery key in a password manager or offline medium, never in this repository or beside the encrypted archive.

WayVNC is not enabled by `manifests/enabled-user-units.txt`. Its local config contains authentication material and should remain owner-readable only. Prefer binding to loopback and reaching it through SSH or a trusted VPN; otherwise configure TLS and a firewall before enabling it.

If a secret is committed:

1. Stop the automatic timer and all pushes.
2. Revoke or rotate the credential immediately.
3. Remove it from the complete Git history.
4. Run a path-redacted scan over files and history.
5. Resume automation only after verification.
