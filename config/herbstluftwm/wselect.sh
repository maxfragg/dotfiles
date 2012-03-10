#!/bin/bash
source ~/.bash_settings
source ~/.config/herbstluftwm/colors.sh

id=$(wmctrl -l | dmenu -l 5 -nf $COLOR_P_FG1 -sb $COLOR_P_HI -nb $COLOR_P_BG  ) && xdotool windowactivate ${id%% *}
