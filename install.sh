#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== TASCAM Model 12 PulseAudio Profile Installer ==="
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    echo "Usage: sudo ./install.sh"
    exit 1
fi

# Install profile set
PROFILE_DIR="/usr/share/pulseaudio/alsa-mixer/profile-sets"
if [[ ! -d "$PROFILE_DIR" ]]; then
    echo "Error: PulseAudio profile directory not found at $PROFILE_DIR"
    exit 1
fi

# echo "Installing profile set..."
# cp "$SCRIPT_DIR/tascam-model12.conf" "$PROFILE_DIR/tascam-model12.conf"
# chmod 644 "$PROFILE_DIR/tascam-model12.conf"
# echo "  -> $PROFILE_DIR/tascam-model12.conf"

echo "Installing simple profile set..."
cp "$SCRIPT_DIR/tascam-model12-simple.conf" "$PROFILE_DIR/tascam-model12-simple.conf"
chmod 644 "$PROFILE_DIR/tascam-model12-simple.conf"
echo "  -> $PROFILE_DIR/tascam-model12-simple.conf"

# Install udev rule
UDEV_DIR="/etc/udev/rules.d"
echo "Installing udev rule..."
cp "$SCRIPT_DIR/91-tascam-model12-pulseaudio.rules" "$UDEV_DIR/91-tascam-model12-pulseaudio.rules"
chmod 644 "$UDEV_DIR/91-tascam-model12-pulseaudio.rules"
echo "  -> $UDEV_DIR/91-tascam-model12-pulseaudio.rules"

# Resolve the real user's home directory (works even under sudo)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

if [[ -z "$REAL_HOME" ]]; then
    echo "Error: Could not determine home directory for user $REAL_USER"
    exit 1
fi

# Install qjackctl folder
echo "Installing qjackctl folder for user $REAL_USER..."
cp -a "$SCRIPT_DIR/qjackctl" "$REAL_HOME"
chmod +x "$REAL_HOME/qjackctl/scripts/"*.sh
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/qjackctl"
echo "  -> $REAL_HOME/qjackctl/"

echo "Installing pulse folder for user $REAL_USER..."
cp -a "$SCRIPT_DIR/pulse" "$REAL_HOME"
chmod +x "$REAL_HOME/pulse/scripts/"*.sh
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/pulse"
echo "  -> $REAL_HOME/pulse/"

# Install systemd user unit for remap source
SYSTEMD_USER_DIR="$REAL_HOME/.config/systemd/user"
echo "Installing systemd user unit for remap source..."
mkdir -p "$SYSTEMD_USER_DIR"
cp "$SCRIPT_DIR/systemd/tascam-remap.service" "$SYSTEMD_USER_DIR/tascam-remap.service"
chown "$REAL_USER":"$REAL_USER" "$SYSTEMD_USER_DIR/tascam-remap.service"
echo "  -> $SYSTEMD_USER_DIR/tascam-remap.service"

# Reload udev rules
echo "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

echo ""
echo "=== Installation complete ==="
echo ""
echo "To apply changes, either, just reboot."
echo ""
echo "Available profiles:"
echo "  - Stereo Out 1/2 + Stereo In 1/2     (default, priority 100)"
echo "  - Stereo Out 1/2 + Main Mix L/R      (record the main mix)"
echo "  - Stereo Out 1/2 + Stereo In 3/4"
echo "  - Stereo Out 1/2 + Stereo In 5/6"
echo "  - Stereo Out 1/2 + Stereo In 7/8"
echo "  - Stereo Out 1/2 + Stereo In 9/10"
echo "  - Stereo Out 1/2 + Mono In Ch1"
echo "  - Stereo Out 1/2 + Mono In Ch2"
echo "  - Multi-channel (10 out / 12 in)     (for DAW use)"
echo "  - Various Out pairs + Main Mix L/R"
echo "Simple profile:"
echo "  - Stereo Out 1/2 + Mono In Ch2"
