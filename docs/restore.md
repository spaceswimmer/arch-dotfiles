# Restoration Notes

Package manifests express current intent, not an exact Arch snapshot. `official.txt` contains explicitly installed packages available from configured repositories. `foreign.txt` contains explicit packages absent from current sync databases; this does not prove AUR provenance.

Before package installation, inspect `/etc/pacman.conf`. This source machine uses testing repositories, but bootstrap deliberately does not enable or modify repositories. AUR and other foreign package recipes must be reviewed at restore time.

After `bin/restore --apply`:

1. Review hardware-specific monitor (`eDP-1`), backlight (`intel_backlight`), Wayland display, proxy, and local application settings.
2. Install Oh My Zsh and Powerlevel10k, which are referenced by `.zshrc` but are not vendored.
3. Run `bin/enable-user-units`; WayVNC remains disabled until manually secured.
4. Restore private credentials and user data from a separate encrypted backup.
5. Review system services such as NetworkManager, Bluetooth, firewall, Tailscale, printing, and display/session setup. This repository does not modify system units.

The tracked wallpaper is a desktop asset. Hyprlock also references `~/.config/hypr/pfp.webp`, which is not present on the source machine and is not included.
