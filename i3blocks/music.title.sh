export MPD_HOST="$(grep -Po '(?<=^password ")[^@]*' "$HOME/.mpdconf")@localhost"

# Don't wait the first time we're started
if [ "$(pgrep i3blocks)" == "$(cat '/tmp/polymehr/audio_control/I3BLOCKS_PID')" ]; then
    mpc -qf "[[[%artist% • ][%album% • ][%title%]]|[%file%]]" current --wait
else
    mpc -qf "[[[%artist% • ][%album% • ][%title%]]|[%file%]]" current
    pgrep i3blocks > '/tmp/polymehr/audio_control/I3BLOCKS_PID' 
fi
mpc -qf "[[%title%]|[%file%]]" current
