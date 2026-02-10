#!/bin/bash

echo -n "pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 1"
pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 1

echo -n "pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 1"
pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 1

echo -n "pacmd suspend-source tascam_ch1_mono 1"
pacmd suspend-source tascam_ch1_mono 1

echo -n "pacmd suspend-source tascam_ch2_mono 1"
pacmd suspend-source tascam_ch2_mono 1

echo -n "pacmd suspend-source tascam_ch3_mono 1"
pacmd suspend-source tascam_ch3_mono 1

echo -n "pacmd suspend-source tascam_ch4_mono 1"
pacmd suspend-source tascam_ch4_mono 1

echo -n "pacmd suspend-source tascam_ch5_mono 1"
pacmd suspend-source tascam_ch5_mono 1

echo -n "pacmd suspend-source tascam_ch6_mono 1"
pacmd suspend-source tascam_ch6_mono 1

echo -n "pacmd suspend-source tascam_ch78_stereo 1"
pacmd suspend-source tascam_ch78_stereo 1

echo -n "pacmd suspend-source tascam_ch910_stereo 1"
pacmd suspend-source tascam_ch910_stereo 1

echo -n "pacmd suspend-source tascam_main_stereo 1"
pacmd suspend-source tascam_main_stereo 1
