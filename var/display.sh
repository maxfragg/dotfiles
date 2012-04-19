#!/bin/bash

# this is a script for setting up different multimonitor
# configurations with hlwm and xrandr
# for args mode enter $mode x1 y1 y2 y2

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

getnum(){
	[[ $MODE == "2in1" ]] 	&& TWOINONE=1 && MODE="dual"
	[[ $MODE == "single" ]] && MONS=1 && MONSU=1
	[[ $MODE == "beamer" ]] && MONS=3 && MONSU=2
	[[ $MODE == "dual" ]] 	&& MONS=2 && MONSU=2
}

if [[ $@ == "" ]]; then
	#interactive mode
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

if [[ $MODE == "single" ]]; then
	XOFF[1]=0
	YOFF[1]=0
fi

if [[ $MODE == "beamer" ]]; then
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
	xrandr --output VGA1 --auto
fi

if [[ $MODE == "dual" ]]; then
	XOFF[1]=0
	YOFF[1]=0
	XOFF[2]=${X[1]}
	YOFF[2]=0
	if [[ $TWOINONE != "1" ]]; then
		 xrandr --output VGA1 --auto
		 xrandr --output VGA1 --pos "${XOFF[2]}+${YOFF[2]}"
	fi
fi

for i in `seq $MONS` ; do
	if [[ $i == "1" ]]; then
		 herbstclient move_monitor 0 "${X[$i]}x${Y[$i]}+${XOFF[$i]}+${YOFF[$i]}"
	else
		 herbstclient add_monitor "${X[$i]}x${Y[$i]}+${XOFF[$i]}+${YOFF[$i]}"
	fi
done

if [[ $MODE == "single" ]]; then
	 herbstclient pad 0 $PADUP 0 $PADDOWN 0
	 herbstclient remove_monitor 2
	 herbstclient remove_monitor 1
	 xrandr --output VGA1 --off
fi

if [[ $MODE == "beamer" ]]; then
	 herbstclient pad 0 $PADUP 0 0 0
	 herbstclient pad 1 $PADUP 0 $PADDOWN 0
	 herbstclient pad 2 0 0 $PADDOWN 0
fi

if [[ $MODE == "dual" ]]; then
	 herbstclient pad 0 $PADUP 0 $PADDOWN 0
	 herbstclient pad 1 $PADUP 0 $PADDOWN 0
fi
