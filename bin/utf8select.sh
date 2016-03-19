#!/bin/bash

source ~/.bash_settings

utf8db="$HOME/.config/utf8db"
if line=$(grep -v '^#' "$utf8db"|grep -v '^$'| /usr/bin/dmenu -b  -fn 'xft:Ubuntu:pixelsize=12' -sb '#FF7600' -p 'Zeichen:' -l 8) ; then
    #echo you selected "$line"
    # char is everything after the last space
    char=${line##* }
    #echo "you selected $char"
    #xdotool key "$char"
    echo -n "$char" |xclip -selection clipboard -i
    echo -n "$char" |xclip -selection primary -i
    # it is written to clipboard, now type it
    xdotool key shift+Insert
fi



