#!/bin/bash

# Copyright (C) 2012 Florian Bruhin <me@the-compiler.org>
# 
# dzenvolume is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# dzenvolume is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with dzenvolume.  If not, see <http://www.gnu.org/licenses/>.


fifo=~/.dzenvolume # Path to the fifo
volstep=5 # How much to increase/decrease the volume on a keypress
vol=$(pamixer --get-volume) # A command which outputs the volume
# A command which outputs "1" when the output is muted
mute=$(grep -q 'mute:[[:blank:]]*on' /proc/acpi/ibm/volume && echo 1)
dzen_w=200 # Width of the dzen-window
bar_w=120 # Width of the bar
dzen_h=33 # Height of the dzen-window
dzen_font='-*-profont-*-*-*-*-11-*-*-*-*-*-*-*' # Font used in dzen (xfontsel)
dzen_bg='#1c1c1c' # Background color of dzen
fg_normal='#afdf87' # Normal color for the bar
fg_mute='#df8787' # Muted color for the bar
text='volume' # Text displayed in the window
vol_decrease() { pamixer --decrease "$1" ;} # Command to decrease the volume
vol_increase() { pamixer --increase "$1" ;} # Command to increase the volume
timeout=3 # Time to display the volume window

# Get the coordinates so dzen is in the middle of the screen
read  mon_w mon_h < <(xrandr | sed -n '/^[^ ]* connected/ {
    s/.*connected \([0-9]*\)x\([0-9]*\).*/\1 \2/p
    q
}')
dzen_x=$(( (mon_w - dzen_w) / 2 ))
dzen_y=$(( (mon_h - dzen_h) / 2 ))

if [[ $1 == decrease ]]; then
        # Assure volume can't drop under 0
	(( (vol - volstep) >= 0 )) && val="$volstep" || val="$vol"
        vol_decrease "$val"
	val="-$val"
elif [[ $1 == increase ]]; then
        # Assure volume can't go over 100
	(( (vol + volstep) <= 100 )) && val=$volstep || val=$(( 100 - vol ))
        vol_increase "$val"
fi

# Get the new volume to display
[[ $val ]] && newvol=$((vol + val)) || newvol=$vol

# Open the fifo and start dzen
if ! lsof "$fifo" >/dev/null 2>&1; then # nobody is listening to the fifo
	mkfifo "$fifo" 2>/dev/null
	{
            tail -f "$fifo" &
            # When the timeout is over, kill dzen / volume window
            {
                sleep "$timeout"
                kill $! 2>/dev/null
                rm -f "$fifo" 2>/dev/null
            }
        } | dzen2 -h $dzen_h -w $dzen_w -x $dzen_x -y $dzen_y \
                  -fn "$dzen_font" -ta l -sa l -bg "$dzen_bg" \
                  -e 'button3=' & # Start dzen (which listens to the FIFO)
fi

# Set the color of the bar
if [[ "$mute" == 1 ]]; then
	fg="$fg_mute"
else
	fg="$fg_normal"
fi

# Display the volume
bar=$(gdbar -w "$bar_w" -fg "$fg" <<< "$newvol")
echo "  ^fg($fg)$text^fg()  $bar" > "$fifo"
