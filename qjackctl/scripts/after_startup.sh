echo -n "pactl load-module module-jack-sink connect=no"
pactl load-module module-jack-sink connect=no

echo -n "pactl load-module module-jack-source connect=no"
pactl load-module module-jack-source connect=no

echo -n "pacmd set-default-sink jack_out"
pacmd set-default-sink jack_out

#echo -n "a2jmidid -e &"
#a2jmidid -e &
