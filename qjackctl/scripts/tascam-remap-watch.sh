#!/bin/bash
set -euo pipefail

MASTER_SOURCE="alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-mono-input-2"
REMAP_SOURCE="tascam_ch2_mono"

wait_for_pulse() {
  for _ in {1..60}; do
    if pactl info >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  return 1
}

source_exists() {
  pactl list sources short | awk '{print $2}' | grep -Fxq "$1"
}

set_default_source() {
  if source_exists "$REMAP_SOURCE"; then
    pactl set-default-source "$REMAP_SOURCE" >/dev/null 2>&1 || true
  fi
}

ensure_remap() {
  if source_exists "$REMAP_SOURCE"; then
    return 0
  fi

  if ! source_exists "$MASTER_SOURCE"; then
    return 0
  fi

  pactl load-module module-remap-source \
    master="$MASTER_SOURCE" \
    source_name="$REMAP_SOURCE" \
    channels=1 \
    channel_map=mono \
    master_channel_map=mono \
    remix=no \
    >/dev/null 2>&1 || true
}

wait_for_pulse || exit 0
sleep 2
ensure_remap
set_default_source

pactl subscribe | while read -r line; do
  case "$line" in
    *"Event 'new' on source"*|*"Event 'change' on source"*|*"Event 'new' on card"*|*"Event 'change' on card"*)
      ensure_remap
      set_default_source
      ;;
  esac
done
