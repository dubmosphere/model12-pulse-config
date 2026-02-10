#!/bin/bash
set -euo pipefail

# TASCAM Model 12 — virtual source creator
#
# Watches for the multichannel ALSA source to appear, then creates
# per-channel virtual sources using module-remap-source (remix=no).
#
# ALSA channel order (12ch capture):
#   Ch1=front-left  Ch2=front-right  Ch3=rear-left     Ch4=rear-right
#   Ch5=front-center Ch6=lfe         Ch7=side-left     Ch8=side-right
#   Ch9=aux0        Ch10=aux1        Ch11(MainL)=aux2  Ch12(MainR)=aux3

MASTER="alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input"

# label:pa_channel_in_master:source_name:description
MONO_CHANNELS=(
  "Ch1:front-left:tascam_ch1_mono:TASCAM-Ch1-Mono"
  "Ch2:front-right:tascam_ch2_mono:TASCAM-Ch2-Mono"
  "Ch3:rear-left:tascam_ch3_mono:TASCAM-Ch3-Mono"
  "Ch4:rear-right:tascam_ch4_mono:TASCAM-Ch4-Mono"
  "Ch5:front-center:tascam_ch5_mono:TASCAM-Ch5-Mono"
  "Ch6:lfe:tascam_ch6_mono:TASCAM-Ch6-Mono"
)

STEREO_CHANNELS=(
  "Ch7/8:side-left,side-right:tascam_ch78_stereo:TASCAM-Ch7/8-Stereo"
  "Ch9/10:aux0,aux1:tascam_ch910_stereo:TASCAM-Ch9/10-Stereo"
  "MainLR:aux2,aux3:tascam_main_stereo:TASCAM-Main-L/R"
)

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
  if source_exists "tascam_ch2_mono"; then
    pactl set-default-source "tascam_ch2_mono" >/dev/null 2>&1 || true
  fi
}

ensure_remaps() {
  if ! source_exists "$MASTER"; then
    return 0
  fi

  for entry in "${MONO_CHANNELS[@]}"; do
    IFS=: read -r label master_ch source_name desc <<< "$entry"
    if ! source_exists "$source_name"; then
      pactl load-module module-remap-source \
        master="$MASTER" \
        source_name="$source_name" \
        source_properties=device.description="$desc" \
        channels=1 \
        channel_map=mono \
        master_channel_map="$master_ch" \
        remix=no \
        >/dev/null 2>&1 || true
    fi
  done

  for entry in "${STEREO_CHANNELS[@]}"; do
    IFS=: read -r label master_ch source_name desc <<< "$entry"
    if ! source_exists "$source_name"; then
      pactl load-module module-remap-source \
        master="$MASTER" \
        source_name="$source_name" \
        source_properties=device.description="$desc" \
        channels=2 \
        channel_map=left,right \
        master_channel_map="$master_ch" \
        remix=no \
        >/dev/null 2>&1 || true
    fi
  done

  set_default_source
}

wait_for_pulse || exit 0
sleep 2
ensure_remaps

pactl subscribe | while read -r line; do
  case "$line" in
    *"Event 'new' on source"*|*"Event 'new' on card"*)
      ensure_remaps
      ;;
  esac
done
