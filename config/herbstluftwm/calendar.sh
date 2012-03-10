#!/bin/bash
#
# pop-up calendar for dzen
#
# (c) 2007, by Robert Manea
#

width=180
padding=255
monitor=( $(herbstclient list_monitors |
    grep '\[FOCUS\]$'|cut -d' ' -f2|
    tr x ' '|sed 's/\([-+]\)/ \1/g') )
x=$((${monitor[2]} + ${monitor[0]} - width - padding))


 
TODAY=$(expr `date +'%d'` + 0)
MONTH=`date +'%m'`
YEAR=`date +'%Y'`
 
(
echo '^bg(#6A4100)^fg(#141414)'
#date +'%A, %d.%m.%Y %H:%M'
 
# current month, highlight header and today
cal | sed -e "1 s/^\s*//; 3,$ s/\(.*\)/\1                    /; 3,$ s/\(.\{20\}\).*/\1/" \
	| sed -r -e "1,2 s/.*/^fg(#141414)&^fg()/" \
		  -e "s/(^| )($TODAY)($| )/\1^bg(#6A4100)^fg(#141414)\2^fg()^bg()\3/"
 
#echo "---------------------"
# next month, hilight header
#[ $MONTH -eq 12 ] && YEAR=`expr $YEAR + 1`
#cal `expr \( $MONTH + 1 \) % 12` $YEAR \
#    | sed -e "1 s/^\s*//; 1,2 s/.*/^fg(#9CA668)&^fg()/; 3,$ s/\(.*\)/\1                    /; 3,$ s/\(.\{20\}\).*/\1/"
) \
    |  dzen2 -p 60  -x $x -y 20 -w $width -l 8 -sa c -e 'onstart=uncollapse;button1=exit' -bg '#6A4100' -fn 'Monospace-9'
