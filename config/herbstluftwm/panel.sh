#!/bin/bash

source ~/.config/herbstluftwm/colors.sh

monitor=${1:-0}
#geometry="$(herbstclient list_monitors |grep "^$monitor:"|cut -d' ' -f2)"
# geometry has the format: WxH+X+Y
#x="$(echo $geometry |cut -d'+' -f2)"
#y="${geometry##*+}"
#width="${geometry%%x*}"
#height=14

font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format: WxH+X+Y
x=${geometry[0]}
y=${geometry[1]}
width=$((${geometry[2]} * 4/5))
height=16

bgcolor=$COLOR_P_BG
icondir=~/.config/herbstluftwm/icons/

function uniq_linebuffered() {
    exec awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}
textwidth() {
	dzen2-textwidth "$@"
}

herbstclient pad $monitor $height
{
    # events:
    #mpc idleloop player &
    while true ; do
        date +'date ^fg($COLOR_P_FG)%H:%M^fg($COLOR_P_FG1), %Y-%m-^fg($COLOR_P_FG)%d'
        sleep 10 || break
    done > >(uniq_linebuffered)&
    child="$!"
    herbstclient --idle
    kill "$child"
}|{
    TAGS=( $(herbstclient tag_status $monitor) )
    date=""
    while true ; do
        bordercolor=$COLOR_P_BO
        hintcolor=$COLOR_P_HI
        separator="^bg()^fg($COLOR_P_FG)|^fg()"
        echo -n "^pa(0;0)"
        # draw tags
        for i in "${TAGS[@]}" ; do
            case ${i:0:1} in
                '#')
                    echo -n "^bg($COLOR_P_CUR)^fg($COLOR_P_FG)"
                    ;;
                '+')
                    echo -n "^bg($COLOR_P_CU2)^fg($COLOR_P_FG)"
                    ;;
                ':')
                    echo -n "^bg($COLOR_P_USD)^fg($COLOR_P_FG)"
                    ;;
                '!')
                    echo -n "^bg($COLOR_P_ATT)^fg($COLOR_P_FG)"
                    ;;
                *)
                    echo -n "^bg()^fg()"
                    ;;
            esac
            icon="$icondir/${i:1}"
            echo -n "^ca(1,herbstclient focus_monitor $monitor && herbstclient use ${i:1})"
            [ -f "$icon" ] && echo -n " ^pa(;2)^i($icon)^pa(;0) " || echo -n " ${i:1} "
            echo -n "^ca()$separator"
        done
        echo -n "^bg()^p(_CENTER)"
        # small adjustments
        calclick="^ca(1,$HOME/.config/herbstluftwm/calendar.sh)"
        calclick+="^ca(2,killall calendar.sh)"
        right="$separator^bg($hintcolor)$calclick $date ^ca()^ca()$separator"
        right_text_only=$(echo -n "$right"|sed 's.\^[^(]*([^)]*)..g')
        # get width of right aligned text.. and add some space..
        rightwidth=$(textwidth "$font" "$right_text_only  ")
        echo -n "^p(_RIGHT)^p(-$rightwidth)$right"
        # some nice bars
        echo -n "^ib(1)^fg($COLOR_P_FG)^pa(0;$((height-1)))^ro(${width}x1)"
        echo
        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                #echo "reseting tags" >&2
                TAGS=( $(herbstclient tag_status $monitor) )
                ;;
            date)
                #echo "reseting date" >&2
                date="${cmd[@]:1}"
                ;;
            togglehidepanel)
                echo "^togglehide()"
                ;;
            quit_panel)
                exit
                ;;
            #player)
            #    ;;
        esac
        done
} |dzen2 -e '' -w $width -x $x -y $y -fn "$font" -h $height \
    -ta l -bg "$bgcolor" -fg $COLOR_P_FG1




