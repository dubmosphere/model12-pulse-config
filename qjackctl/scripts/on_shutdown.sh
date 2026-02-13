#!/bin/bash

#echo -n "killall a2jmidid"
#killall a2jmidid

echo -n "pactl unload-module module-jack-source"
pactl unload-module module-jack-source

echo -n "pactl unload-module module-jack-sink"
pactl unload-module module-jack-sink

echo -n "pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 0"
pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 0

echo -n "pacmd suspend-sink model12_stereo_out 0"
pacmd suspend-sink model12_stereo_out 0

echo -n "pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 0"
pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 0

echo -n "pacmd suspend-source model12_ch1_mono 0"
pacmd suspend-source model12_ch1_mono 0

echo -n "pacmd suspend-source model12_ch2_mono 0"
pacmd suspend-source model12_ch2_mono 0

echo -n "pacmd suspend-source model12_ch3_mono 0"
pacmd suspend-source model12_ch3_mono 0

echo -n "pacmd suspend-source model12_ch4_mono 0"
pacmd suspend-source model12_ch4_mono 0

echo -n "pacmd suspend-source model12_ch5_mono 0"
pacmd suspend-source model12_ch5_mono 0

echo -n "pacmd suspend-source model12_ch6_mono 0"
pacmd suspend-source model12_ch6_mono 0

echo -n "pacmd suspend-source model12_ch78_stereo 0"
pacmd suspend-source model12_ch78_stereo 0

echo -n "pacmd suspend-source model12_ch910_stereo 0"
pacmd suspend-source model12_ch910_stereo 0

echo -n "pacmd suspend-source model12_main_stereo 0"
pacmd suspend-source model12_main_stereo 0

echo -n "pacmd set-default-sink model12_stereo_out"
pacmd set-default-sink model12_stereo_out

echo -n "pacmd set-default-source model12_ch2_mono"
pacmd set-default-source model12_ch2_mono
