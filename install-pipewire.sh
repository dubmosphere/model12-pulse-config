#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== TASCAM Model 12 PipeWire Profile Installer ==="
echo ""

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo."
    echo "Usage: sudo ./install-pipewire.sh"
    exit 1
fi

# Resolve the real user's home directory (works even under sudo)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

if [[ -z "$REAL_HOME" ]]; then
    echo "Error: Could not determine home directory for user $REAL_USER"
    exit 1
fi

# Install ACP profile set
# PipeWire reads profile sets from alsa-card-profile, NOT the old pulseaudio path.
ACP_PROFILE_DIR="/usr/share/alsa-card-profile/mixer/profile-sets"
if [[ ! -d "$ACP_PROFILE_DIR" ]]; then
    echo "Error: ACP profile directory not found at $ACP_PROFILE_DIR"
    echo "  Is pipewire-audio (or alsa-card-profile) installed?"
    exit 1
fi

echo "Installing ACP profile set..."
cp "$SCRIPT_DIR/tascam-model12.conf" "$ACP_PROFILE_DIR/tascam-model12.conf"
chmod 644 "$ACP_PROFILE_DIR/tascam-model12.conf"
echo "  -> $ACP_PROFILE_DIR/tascam-model12.conf"

# Install WirePlumber rule
# This replaces the old udev PULSE_PROFILE_SET approach.
WP_LUA_DIR="$REAL_HOME/.config/wireplumber/main.lua.d"
echo "Installing WirePlumber device rule for user $REAL_USER..."
mkdir -p "$WP_LUA_DIR"
cp "$SCRIPT_DIR/wireplumber/main.lua.d/50-alsa-config.lua" "$WP_LUA_DIR/50-alsa-config.lua"
cp "$SCRIPT_DIR/wireplumber/main.lua.d/51-tascam-model12.lua" "$WP_LUA_DIR/51-tascam-model12.lua"
chmod 644 "$WP_LUA_DIR/50-alsa-config.lua"
chmod 644 "$WP_LUA_DIR/51-tascam-model12.lua"
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/.config/wireplumber"
echo "  -> $WP_LUA_DIR/50-alsa-config.lua"
echo "  -> $WP_LUA_DIR/51-tascam-model12.lua"

# Install qjackctl folder
echo "Installing qjackctl folder for user $REAL_USER..."
cp -a "$SCRIPT_DIR/qjackctl" "$REAL_HOME"
chmod +x "$REAL_HOME/qjackctl/scripts/"*.sh
chown -R "$REAL_USER":"$REAL_USER" "$REAL_HOME/qjackctl"
echo "  -> $REAL_HOME/qjackctl/"

# Install pulse scripts folder (remap watch script — still works via PipeWire's PA compat layer)
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

echo ""
echo "=== Installation complete ==="
echo ""
echo "Next steps:"
echo "  1. Restart WirePlumber (or reboot):"
echo "       systemctl --user restart wireplumber"
echo "  2. Enable the remap service (first time only):"
echo "       systemctl --user enable --now tascam-remap.service"
echo "  3. Verify the profile loaded:"
echo "       pactl list cards | grep -A5 'TASCAM\\|Active Profile'"
echo ""
