# TASCAM Model 12 — Linux Audio Configuration

## Project Overview

Linux PipeWire/ALSA configuration for the TASCAM Model 12 USB audio interface. Sets up a custom ALSA profile, native PipeWire per-channel virtual nodes, a virtual stereo sink, and QJackCtl integration for DAW use (Bitwig Studio). Also includes legacy PulseAudio compat-layer scripts kept for reference.

## Architecture

### Core (PipeWire-native — current approach)

- **tascam-model12.conf** — ALSA card profile. Opens the full multichannel device (12ch capture, 10ch playback) as a single profile. Used by both PipeWire/WirePlumber and standalone PulseAudio.
- **pipewire/pipewire.conf.d/10-tascam-model12-loopbacks.conf** — Native PipeWire loopback nodes. Creates per-channel virtual sources and a virtual stereo sink using `libpipewire-module-loopback` with `stream.dont-remix=true` and `audio.position` channel mapping. Produces clean 1-to-1 port connections in qpwgraph (no PA compat layer fan-out).
- **wireplumber/main.lua.d/51-tascam-model12.lua** — WirePlumber rules: (1) assigns the custom ACP profile set and default profile to the TASCAM device; (2) sets `capture_2` and `playback_1_2` as default source/sink via `priority.session`.
- **wireplumber/main.lua.d/50-alsa-config.lua** — WirePlumber ALSA monitor config (format, rate, suspend timeout).
- **install-pipewire.sh** — PipeWire installer (requires `sudo`). Copies profile to `/usr/share/alsa-card-profile/mixer/profile-sets/`, installs PipeWire loopback config, WirePlumber Lua rules, qjackctl folder, pulse scripts, and systemd unit.

### JACK Integration

- **qjackctl/** — QJackCtl scripts and patchbay config for JACK integration:
  - `scripts/on_startup.sh` — Suspends PulseAudio sinks/sources before JACK takes over the device.
  - `scripts/after_startup.sh` — Loads `module-jack-sink`/`module-jack-source` bridges and sets JACK as default.
  - `scripts/on_shutdown.sh` — Unloads JACK bridges and unsuspends PulseAudio sinks/sources.
  - `Model12Production.xml` — Patchbay preset routing Bitwig, PulseAudio, and system ports.

### Legacy / PulseAudio compat reference (kept for documentation)

- **pulse/scripts/tascam-remap-watch.sh** — Bash script that creates virtual sources via `module-remap-source` through PipeWire's PA compat layer. Produces a working but messy qpwgraph (all channels fan out from the same node). Superseded by the native PipeWire loopback approach above.
- **systemd/tascam-remap.service** — Systemd user service that runs the remap watch script. Not needed when using the native PipeWire approach.
- **91-tascam-model12-pulseaudio.rules** — udev rule using `PULSE_PROFILE_SET`. Only needed for standalone PulseAudio (not PipeWire).
- **install.sh** — Legacy PulseAudio installer. Copies profile to `/usr/share/pulseaudio/alsa-mixer/profile-sets/`. Use only if running standalone PulseAudio (not PipeWire).
- **enable_service.sh** — Enables the `tascam-remap.service` systemd user unit.
- **check_service_status.sh** — Checks the status of the systemd service.

## Channel Mapping

ALSA 12-channel capture order:
| Channel | ALSA Name       | Virtual Source          |
|---------|-----------------|-------------------------|
| Ch1     | front-left      | capture_1               |
| Ch2     | front-right     | capture_2 (default)     |
| Ch3     | rear-left       | capture_3               |
| Ch4     | rear-right      | capture_4               |
| Ch5     | front-center    | capture_5               |
| Ch6     | lfe             | capture_6               |
| Ch7/8   | side-left/right | capture_7_8             |
| Ch9/10  | aux0/aux1       | capture_9_10            |
| Main L/R| aux2/aux3       | capture_11_12           |

Virtual output sink: `playback_1_2` (USB Return 1/2, stereo)

## Key Details

- The virtual stereo sink `playback_1_2` exists because some apps/games don't detect the multichannel output.
- Native PipeWire loopbacks use `stream.dont-remix = true` + `audio.position` to extract channels cleanly without mixing. The PA compat-layer approach (`module-remap-source`) works but draws a confusing fan-out in qpwgraph because PipeWire's PA bridge doesn't expose individual channel links.
- QJackCtl scripts handle the PulseAudio <-> JACK handoff: suspend PA devices when JACK starts, restore when JACK stops.
- The install scripts resolve `$SUDO_USER` to install user-level files to the correct home directory.
