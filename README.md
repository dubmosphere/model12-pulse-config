# TASCAM Model 12 — PulseAudio Configuration

PulseAudio/ALSA setup for the [TASCAM Model 12](https://tascam.com/us/product/model_12/) USB audio interface on Linux. Provides a custom multi-channel profile, per-channel virtual sources, a virtual stereo sink, and QJackCtl integration for DAW use.

## What It Does

- Registers a custom PulseAudio profile via udev when the Model 12 is plugged in
- Opens the full device: **12 channels capture** + **10 channels playback**
- Creates individual virtual sources for each input channel (mono and stereo) using `module-remap-source`
- Creates a virtual stereo sink (`model12_stereo_out`) so apps and games that only detect standard stereo outputs work correctly
- Includes QJackCtl scripts to seamlessly hand off the device between PulseAudio and JACK (for Bitwig Studio or other DAWs)

## Channel Mapping

| Channel | Virtual Source | Type |
|---------|---------------|------|
| Ch1 | `model12_ch1_mono` | Mono |
| Ch2 | `model12_ch2_mono` | Mono (default source) |
| Ch3 | `model12_ch3_mono` | Mono |
| Ch4 | `model12_ch4_mono` | Mono |
| Ch5 | `model12_ch5_mono` | Mono |
| Ch6 | `model12_ch6_mono` | Mono |
| Ch7/8 | `model12_ch78_stereo` | Stereo |
| Ch9/10 | `model12_ch910_stereo` | Stereo |
| Main L/R | `model12_main_stereo` | Stereo |

## Installation

```bash
# Clone the repo
git clone <repo-url>
cd model12-pulse-config

# Install (copies profile, udev rule, scripts, and systemd unit)
sudo ./install.sh

# Enable the remap service (creates virtual sources on device connect)
./enable_service.sh

# Reboot to apply udev rules
reboot
```

## File Structure

```
├── install.sh                          # Installer (run with sudo)
├── enable_service.sh                   # Enable the systemd user service
├── check_service_status.sh             # Check service status
├── tascam-model12.conf                 # PulseAudio ALSA mixer profile
├── 91-tascam-model12-pulseaudio.rules  # udev rule for auto profile assignment
├── systemd/
│   └── tascam-remap.service            # Systemd user unit for the remap watcher
├── pulse/
│   └── scripts/
│       └── tascam-remap-watch.sh       # Creates virtual sources/sink, watches for device events
└── qjackctl/
    ├── Model12Production.xml           # QJackCtl patchbay preset (Bitwig + PulseAudio routing)
    └── scripts/
        ├── on_startup.sh               # Suspends PA sinks/sources before JACK starts
        ├── after_startup.sh            # Loads JACK↔PA bridges, sets JACK as default
        └── on_shutdown.sh              # Unloads JACK bridges, restores PA defaults
```

## QJackCtl / DAW Usage

The QJackCtl scripts handle switching between PulseAudio and JACK:

1. **JACK starts** — `on_startup.sh` suspends all PulseAudio sinks and sources so JACK can take exclusive access to the device
2. **JACK ready** — `after_startup.sh` loads `module-jack-sink` and `module-jack-source` to bridge PulseAudio audio through JACK
3. **JACK stops** — `on_shutdown.sh` unloads the JACK bridges and unsuspends the PulseAudio devices

The included patchbay preset (`Model12Production.xml`) routes:
- Bitwig Studio output → Bitwig loopback input (monitoring)
- PulseAudio JACK Sink → System out (hardware playback)
- PulseAudio JACK Sink → Bitwig PulseAudio input
- System capture (Ch2) → PulseAudio JACK Source

## Requirements

- PulseAudio
- ALSA
- QJackCtl (for JACK/DAW integration)
- systemd (user units)
