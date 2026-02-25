-- TASCAM Model 12 — WirePlumber device rule
--
-- Assigns the custom ACP profile set to the TASCAM Model 12 so PipeWire
-- opens it as 12ch capture / 10ch playback instead of falling back to
-- the generic stereo profile.
--
-- Replaces the old udev PULSE_PROFILE_SET env var approach used with
-- standalone PulseAudio.
--
-- Install to: ~/.config/wireplumber/main.lua.d/51-tascam-model12.lua

rule = {
  matches = {
    {
      { "device.bus-id", "equals", "usb-TASCAM_Model_12_no_serial_number-00" },
    },
  },
  apply_properties = {
    ["device.profile-set"] = "tascam-model12.conf",
    ["device.profile"]     = "output:analog-stereo-output-12+input:analog-multichannel-input",
  },
}

table.insert(alsa_monitor.rules, rule)
