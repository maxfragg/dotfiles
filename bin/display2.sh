#!/bin/bash

###########################
# display setup script v2 #
###########################

# this is a script for setting up different multimonitor
# configurations with hlwm and xrandr
# for args mode enter $mode [dryrun] x1 y1 [x2 y2]
#
# needs hlwm with monitorname support and xrandr
# dryrun function does not changes you might also use the output of this for a static script 
#
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
DRYRUN=0

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


# based on cycle.sh to find unused tags
tags=( $(herbstclient tag_status) )

# Find the currently active tag
for ((i=0; i<="${#tags[@]}"; i++)); do
	[[ "${tags[i]}" == "#"* ]] && activetag="$i"
done



##############
# Real stuff #
##############

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
	if [[ $2 == "dryrun" ]]; then
		DRYRUN=1
		echo "Dryrun mode, no changes!"
	fi

	for i in `seq $MONSU` ; do
		indx=$(( ($i * 2) + $DRYRUN ))
		indy=$((1+ ($i * 2) + $DRYRUN ))
		eval X[$i]=\$$indx
		eval Y[$i]=\$$indy
	done
fi;

ex herbstclient lock

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
#just to make sure, we don't want errors here!!

ex herbstclient rename_monitor 0 "${MNAME[1]}" 2>/dev/null

for i in `seq $MONS` ; do
	if [[ $i == "1" ]]; then
		ex herbstclient move_monitor "${MNAME[$i]}" "${X[$i]}x${Y[$i]}+${XOFF[$i]}+${YOFF[$i]}"
	else
		ex herbstclient add_monitor "${X[$i]}x${Y[$i]}+${XOFF[$i]}+${YOFF[$i]}" "${tags[$(( ( $activetag+$i ) % ${#tags[@]} ))]:1}"  "${MNAME[$i]}"
	fi
done

#fixing up things

case $MODE in
	"single" )
		ex herbstclient pad "${MNAME[1]}" $PADUP 0 $PADDOWN 0
		ex herbstclient remove_monitor "intern2" 2>/dev/null
		ex herbstclient remove_monitor "extern" 2>/dev/null
		ex herbstclient remove_monitor "sidebar" 2>/dev/null
		ex herbstclient remove_monitor "bottom" 2>/dev/null
		ex xrandr --output VGA1 --off
		;;
	"extern" )
		ex herbstclient pad "${MNAME[1]}" $PADUP 0 $PADDOWN 0
		ex xrandr --output LVDS1 --off
		ex herbstclient remove_monitor "intern" 2>/dev/null
		ex herbstclient remove_monitor "intern2" 2>/dev/null
		ex herbstclient remove_monitor "sidebar" 2>/dev/null
		ex herbstclient remove_monitor "bottom" 2>/dev/null
		;;
	"beamer" )
		ex herbstclient pad "${MNAME[1]}" $PADUP 0 0 0
		ex herbstclient pad "${MNAME[2]}" $PADUP 0 $PADDOWN 0
		ex herbstclient pad "${MNAME[3]}" 0 0 $PADDOWN 0
		ex herbstclient remove_monitor "intern2" 2>/dev/null
		ex herbstclient remove_monitor "extern" 2>/dev/null
		;;
	"dual" )
		ex herbstclient pad "${MNAME[1]}" $PADUP 0 $PADDOWN 0
		ex herbstclient pad "${MNAME[2]}" $PADUP 0 $PADDOWN 0
		ex herbstclient remove_monitor "intern2" 2>/dev/null
		ex herbstclient remove_monitor "sidebar" 2>/dev/null
		ex herbstclient remove_monitor "bottom" 2>/dev/null
		;;
esac

ex herbstclient unlock