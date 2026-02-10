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
  "Ch1:front-left:model12_ch1_mono:Model12-Ch1-Mono"
  "Ch2:front-right:model12_ch2_mono:Model12-Ch2-Mono"
  "Ch3:rear-left:model12_ch3_mono:Model12-Ch3-Mono"
  "Ch4:rear-right:model12_ch4_mono:Model12-Ch4-Mono"
  "Ch5:front-center:model12_ch5_mono:Model12-Ch5-Mono"
  "Ch6:lfe:model12_ch6_mono:Model12-Ch6-Mono"
)

STEREO_CHANNELS=(
  "Ch7/8:side-left,side-right:model12_ch78_stereo:Model12-Ch7/8-Stereo"
  "Ch9/10:aux0,aux1:model12_ch910_stereo:Model12-Ch9/10-Stereo"
  "MainLR:aux2,aux3:model12_main_stereo:Model12-Main-L/R"
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
  if source_exists "model12_ch2_mono"; then
    pactl set-default-source "model12_ch2_mono" >/dev/null 2>&1 || true
  fi
}

ensure_remaps() {
  if ! source_exists "$MASTER"; then
    return 0
  fi

  local created=0

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
      created=1
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
      created=1
    fi
  done

  if [[ "$created" -eq 1 ]]; then
    set_default_source
  fi
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
