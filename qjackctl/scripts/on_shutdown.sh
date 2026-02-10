#!/bin/bash

#echo -n "killall a2jmidid"
#killall a2jmidid

echo -n "pactl unload-module module-jack-source"
pactl unload-module module-jack-source

echo -n "pactl unload-module module-jack-sink"
pactl unload-module module-jack-sink

echo -n "pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 0"
pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 0

echo -n "pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 0"
pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 0

echo -n "pacmd suspend-source tascam_ch1_mono 0"
pacmd suspend-source tascam_ch1_mono 0

echo -n "pacmd suspend-source tascam_ch2_mono 0"
pacmd suspend-source tascam_ch2_mono 0

echo -n "pacmd suspend-source tascam_ch3_mono 0"
pacmd suspend-source tascam_ch3_mono 0

echo -n "pacmd suspend-source tascam_ch4_mono 0"
pacmd suspend-source tascam_ch4_mono 0

echo -n "pacmd suspend-source tascam_ch5_mono 0"
pacmd suspend-source tascam_ch5_mono 0

echo -n "pacmd suspend-source tascam_ch6_mono 0"
pacmd suspend-source tascam_ch6_mono 0

echo -n "pacmd suspend-source tascam_ch78_stereo 0"
pacmd suspend-source tascam_ch78_stereo 0

echo -n "pacmd suspend-source tascam_ch910_stereo 0"
pacmd suspend-source tascam_ch910_stereo 0

echo -n "pacmd suspend-source tascam_main_stereo 0"
pacmd suspend-source tascam_main_stereo 0

echo -n "pacmd set-default-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12"
pacmd set-default-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12

echo -n "pacmd set-default-source tascam_ch2_mono"
pacmd set-default-source tascam_ch2_mono
