# TASCAM Model 12 PulseAudio Configuration

## Project Overview

Linux PulseAudio/ALSA configuration for the TASCAM Model 12 USB audio interface. Sets up a custom PulseAudio profile, udev rules, virtual per-channel sources, a virtual stereo sink, and QJackCtl integration for DAW use (Bitwig Studio).

## Architecture

- **tascam-model12.conf** — PulseAudio ALSA mixer profile. Opens the full multichannel device (12ch capture, 10ch playback) as a single profile.
- **91-tascam-model12-pulseaudio.rules** — udev rule that assigns the profile when the TASCAM (vendor `0644`, product `805f`) is detected.
- **pulse/scripts/tascam-remap-watch.sh** — Long-running script that watches PulseAudio events and creates virtual sources (per-channel mono/stereo via `module-remap-source`) and a virtual stereo sink (`module-remap-sink` for `model12_stereo_out`). Sets Ch2 as default source and the virtual sink as default sink.
- **systemd/tascam-remap.service** — Systemd user service that runs the remap watch script.
- **qjackctl/** — QJackCtl scripts and patchbay config for JACK integration:
  - `scripts/on_startup.sh` — Suspends PulseAudio sinks/sources before JACK takes over the device.
  - `scripts/after_startup.sh` — Loads `module-jack-sink`/`module-jack-source` bridges and sets JACK as default.
  - `scripts/on_shutdown.sh` — Unloads JACK bridges and unsuspends PulseAudio sinks/sources.
  - `Model12Production.xml` — Patchbay preset routing Bitwig, PulseAudio, and system ports.
- **install.sh** — Installer (requires `sudo`). Copies profile, udev rule, qjackctl folder, pulse folder, and systemd unit to their destinations.
- **enable_service.sh** — Enables the `tascam-remap.service` systemd user unit.
- **check_service_status.sh** — Checks the status of the systemd service.

## Channel Mapping

ALSA 12-channel capture order:
| Channel | ALSA Name     | Virtual Source          |
|---------|---------------|-------------------------|
| Ch1     | front-left    | model12_ch1_mono        |
| Ch2     | front-right   | model12_ch2_mono (default) |
| Ch3     | rear-left     | model12_ch3_mono        |
| Ch4     | rear-right    | model12_ch4_mono        |
| Ch5     | front-center  | model12_ch5_mono        |
| Ch6     | lfe           | model12_ch6_mono        |
| Ch7/8   | side-left/right | model12_ch78_stereo   |
| Ch9/10  | aux0/aux1     | model12_ch910_stereo    |
| Main L/R| aux2/aux3     | model12_main_stereo     |

## Key Details

- The virtual stereo sink `model12_stereo_out` exists because some apps/games don't detect the multichannel output.
- The remap watch script uses `remix=no` to avoid PulseAudio mixing channels together.
- QJackCtl scripts handle the PulseAudio <-> JACK handoff: suspend PA devices when JACK starts, restore when JACK stops.
- The install script resolves `$SUDO_USER` to install user-level files to the correct home directory.
