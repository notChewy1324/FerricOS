#!/usr/bin/bash
# Creates the throwaway live-session user. Runs ONCE at live boot,
# against the in-RAM live filesystem only. Never reaches an installed disk.
set -e

id ferric &>/dev/null || useradd -m \
    -G wheel,video,audio,input,network,storage,lp \
    -s /usr/bin/bash \
    ferric

# Passwordless: this is a throwaway live env, autologin needs no password.
passwd -d ferric

# Passwordless sudo for the live user (so they can run the installer, etc.)
install -d -m 750 /etc/sudoers.d
echo 'ferric ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ferric
chmod 440 /etc/sudoers.d/ferric