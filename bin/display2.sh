#!/bin/bash

# this is a script for setting up different multimonitor
# configurations with hlwm and xrandr
# for args mode enter $mode x1 y1 x2 y2

# Beamer:
# ---------
# |1111|22|
# |1111|22|
# |-------|
# |3333333|
# ---------
# 2in1:
# ---------
# |111|222|
# |111|222|
# |111|222|
# ---------
# dual:
# -----  -----
# |111|  |222|
# |111|  |222|
# |111|  |222|
# -----  -----

PADUP=0
PADDOWN=30

ex(){
	if [[ $DRYRUN == "1" ]]; then
		echo "$@"
	else
		`$@`
	fi
}

getnum(){
	[[ $MODE == "2in1" ]] 	&& TWOINONE=1 && MODE="dual"
	[[ $MODE == "single" ]] && MONS=1 && MONSU=1
	[[ $MODE == "extern" ]] && MONS=1 && MONSU=1
	[[ $MODE == "beamer" ]] && MONS=3 && MONSU=2
	[[ $MODE == "dual" ]] 	&& MONS=2 && MONSU=2
}

if [[ $@ == "" || $@ == "dryrun" ]]; then
	#interactive mode
	if [[ $@ == "dryrun" ]]; then
		DRYRUN=1
		echo "Dryrun mode, no changes!"
	fi

	echo -n "Enter mode (single, beamer, dual, 2in1): "
	read MODE
	
	getnum

	for i in `seq $MONSU` ; do
		echo -n "Enter Resolution X Y for Monitor $i:"
		read X[$i] Y[$i]


	done

else
	MODE=$1
	getnum

	for i in `seq $MONSU` ; do
		indx=$(( ($i * 2)))
		indy=$((1+ ($i * 2)))
		eval X[$i]=\$$indx
		eval Y[$i]=\$$indy
	done
fi;

#pre setup of variables
case $MODE in
	"single" )
		XOFF[1]=0
		YOFF[1]=0

		MNAME[1]="intern"
		;;
	"extern" )
		XOFF[1]=0
		YOFF[1]=0
		ex xrandr --output VGA1 --auto

		MNAME[1]="extern"
		;;
	"beamer" )
		XTMP=${X[1]}
		YTMP=${Y[1]}
		X[1]=${X[2]}
		Y[1]=${Y[2]}
		X[2]=$((XTMP - ${X[1]}))
		Y[2]=$YTMP
		X[3]=${X[1]}
		Y[3]=$((YTMP - ${Y[1]}))
		XOFF[1]=0
		YOFF[1]=0
		XOFF[2]=${X[1]}
		YOFF[2]=0
		XOFF[3]=0
		YOFF[3]=${Y[1]}
		ex xrandr --output VGA1 --auto
		MNAME[1]="intern"
		MNAME[2]="sidebar"
		MNAME[3]="bottom"
		;;
	"dual" )
		XOFF[1]=0
		YOFF[1]=0
		XOFF[2]=${X[1]}
		YOFF[2]=0
		if [[ $TWOINONE != "1" ]]; then
			ex xrandr --output VGA1 --auto
			ex xrandr --output VGA1 --pos "${XOFF[2]}x${YOFF[2]}"
			MNAME[1]="intern"
			MNAME[2]="extern"
		else
			MNAME[1]="intern"
			MNAME[2]="intern2"
		fi
		;;
esac

#establish monitors

ex herbstclient rename_monitor 0 "${MNAME[1]}"

for i in `seq $MONS` ; do
	if [[ $i == "1" ]]; then
		ex herbstclient move_monitor "${MNAME[$i]}" "${X[$i]}x${Y[$i]}+${XOFF[$i]}+${YOFF[$i]}"
	else
		ex herbstclient add_monitor "${X[$i]}x${Y[$i]}+${XOFF[$i]}+${YOFF[$i]}" "${MNAME[$i]}"
	fi
done

#fixing up things

case $MODE in
	"single" )
		ex herbstclient pad "${MNAME[$1]}" $PADUP 0 $PADDOWN 0
		ex herbstclient remove_monitor "intern2"
		ex herbstclient remove_monitor "extern"
		ex herbstclient remove_monitor "sidebar"
		ex herbstclient remove_monitor "bottom"
		ex xrandr --output VGA1 --off
		;;
	"extern" )
		ex herbstclient pad "${MNAME[$1]}" $PADUP 0 $PADDOWN 0
		ex herbstclient remove_monitor 2
		ex herbstclient remove_monitor 1
		ex xrandr --output LVDS1 --off
		ex herbstclient remove_monitor "intern"
		ex herbstclient remove_monitor "intern2"
		ex herbstclient remove_monitor "sidebar"
		ex herbstclient remove_monitor "bottom"
		;;
	"beamer" )
		ex herbstclient pad "${MNAME[$1]}" $PADUP 0 0 0
		ex herbstclient pad "${MNAME[$2]}" $PADUP 0 $PADDOWN 0
		ex herbstclient pad "${MNAME[$3]}" 0 0 $PADDOWN 0
		ex herbstclient remove_monitor "intern2"
		ex herbstclient remove_monitor "extern"
		;;
	"dual" )
		ex herbstclient pad "${MNAME[$1]}" $PADUP 0 $PADDOWN 0
		ex herbstclient pad "${MNAME[$2]}" $PADUP 0 $PADDOWN 0
		ex herbstclient remove_monitor "extern"
		;;
esac

