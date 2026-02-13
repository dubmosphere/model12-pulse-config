#!/bin/bash

echo -n "pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 1"
pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 1

echo -n "pacmd suspend-sink model12_stereo_out 1"
pacmd suspend-sink model12_stereo_out 1

echo -n "pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 1"
pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-multichannel-input 1

echo -n "pacmd suspend-source model12_ch1_mono 1"
pacmd suspend-source model12_ch1_mono 1

echo -n "pacmd suspend-source model12_ch2_mono 1"
pacmd suspend-source model12_ch2_mono 1

echo -n "pacmd suspend-source model12_ch3_mono 1"
pacmd suspend-source model12_ch3_mono 1

echo -n "pacmd suspend-source model12_ch4_mono 1"
pacmd suspend-source model12_ch4_mono 1

echo -n "pacmd suspend-source model12_ch5_mono 1"
pacmd suspend-source model12_ch5_mono 1

echo -n "pacmd suspend-source model12_ch6_mono 1"
pacmd suspend-source model12_ch6_mono 1

echo -n "pacmd suspend-source model12_ch78_stereo 1"
pacmd suspend-source model12_ch78_stereo 1

echo -n "pacmd suspend-source model12_ch910_stereo 1"
pacmd suspend-source model12_ch910_stereo 1

echo -n "pacmd suspend-source model12_main_stereo 1"
pacmd suspend-source model12_main_stereo 1
