echo -n "pactl load-module module-jack-sink connect=no channels=2"
pactl load-module module-jack-sink connect=no channels=2

echo -n "pactl load-module module-jack-source connect=no channels=1"
pactl load-module module-jack-source connect=no channels=1

echo -n "pacmd set-default-sink jack_out"
pacmd set-default-sink jack_out

echo -n "pacmd set-default-source jack_in"
pacmd set-default-source jack_in

#echo -n "a2jmidid -e &"
#a2jmidid -e &
