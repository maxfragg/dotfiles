#!/bin/bash

#exec herbstclient move before moving mouse
#$MON=`tagtomon $2`
#herbstclient $@
#herbstclient focus_monitor $MON
#herbstclient raise_monitor $MON
herbstclient $@

#classic stuff by thorsten

id=$( xdotool getactivewindow) || exit
geom=( $(xwininfo -id $id -stats | grep -E '(Width|Height):' | cut -d: -f2) )
w=${geom[0]}
h=${geom[1]}
xdotool mousemove -w $id $((w/2)) $((h/2))



