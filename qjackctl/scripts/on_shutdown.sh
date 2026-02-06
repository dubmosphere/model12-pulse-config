#echo -n "killall a2jmidid"
#killall a2jmidid

echo -n "pactl unload-module module-jack-source"
pactl unload-module module-jack-source

echo -n "pactl unload-module module-jack-sink"
pactl unload-module module-jack-sink

echo -n "pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 0"
pacmd suspend-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12 0

echo -n "pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-mono-input-2 0"
pacmd suspend-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-mono-input-2 0

#echo -n "pacmd set-default-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo"
#pacmd set-default-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo

#echo -n "pacmd set-default-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo"
#pacmd set-default-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo

echo -n "pacmd set-default-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12"
pacmd set-default-sink alsa_output.usb-TASCAM_Model_12_no_serial_number-00.analog-stereo-output-12

echo -n "pacmd set-default-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-mono-input-2"
pacmd set-default-source alsa_input.usb-TASCAM_Model_12_no_serial_number-00.analog-mono-input-2
