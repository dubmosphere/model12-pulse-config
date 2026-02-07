echo -n "pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 1"
pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 1

echo -n "pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-mono-input-2 1"
pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-mono-input-2 1

echo -n "pacmd suspend-source tascam_ch2_mono 1"
pacmd suspend-source tascam_ch2_mono 1