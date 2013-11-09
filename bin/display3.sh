#!/bin/bash

###########################
# display setup script v3.1 #
###########################
#
# Author: 	Max Krueger
# Date: 	2013-11-05 
# License:  MIT
#
# # TODO:
# # Half width resolutions for 2in1 mode as suggestion
# # Spliting functionality up for easyer maintainance
#
# this is a script for setting up different multimonitor
# configurations with hlwm and xrandr
# this version uses dmenu, commandline interactive or arguents for the graphical setup
# New feature: automode, dedects connected monitors and sets them to their maximum 
# resolution, at the moment only for up to 2 monitors, support for arbitrary monitor numbers
# is in the works. Be prepared, dual will be renamend to multi, once we are there!
#
# needs hlwm with monitorname support, cut, grep, dmenu and xrandr
# dryrun function does not changes you might also use the output of this for a static script 
#
# ./display3.sh [-d/--dmenu] [dryrun] [mode [output X1xY1] [output X2xY2] ]
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

#using my colortheme for dmenu
source ~/.config/herbstluftwm/colors.sh

PADUP=0
PADDOWN=25
DRYRUN=0


MODES="single
extern
dual
2in1
beamer
auto"

ex(){
	if [[ $DRYRUN == "1" ]]; then
		echo "$@"
	else
		`$@`
	fi
}

getnum(){
	MONS=0
	MONSU=0
	[[ $MODE == auto ]] && MONS=`xrandr | grep " connected" | cut -d' ' -f1| wc -l` && MONSU=$MONS
	[[ $MODE == "2in1" ]] 	&& TWOINONE=1 && MODE="dual"
	[[ $MODE == "single" ]] && MONS=1 && MONSU=1
	[[ $MODE == "extern" ]] && MONS=1 && MONSU=1
	[[ $MODE == "beamer" ]] && MONS=3 && MONSU=2
	[[ $MODE == "dual" ]] 	&& MONS=2 && MONSU=2
}

#based on https://github.com/jpic/bashworks/blob/master/os/xrandr/source.sh

os_xrandr_displays=()

os_xrandr_parse() {
    local current_modes=""
    
    # extract
    local results="$(xrandr | grep -o -e '\([A-Z]\+[0-9]\+ connected\)\|\([0-9]\+x[0-9]\+  \)')"

    # parse
    for result in $results; do
        if [[ $result =~ connected ]]; then
            continue
        fi

        if [[ $result =~ [A-Z] ]]; then
            current_modes="os_xrandr_modes_${result}"
            eval "$current_modes=()"
            os_xrandr_displays+="$result\n"
        else
            eval "$current_modes+=(\"$result\n\")"
        fi
    done
}

os_xrandr_reset() {
    # reset
    for display in ${os_xrandr_displays[@]}; do
        unset "os_xrandr_modes_${display}"
    done

    os_xrandr_displays=()
}


# based on cycle.sh from herbstluftwm to find unused tags
tags=( $(herbstclient tag_status) )

# Find the currently active tag
for ((i=0; i<="${#tags[@]}"; i++)); do
	[[ "${tags[i]}" == "#"* ]] && activetag="$i"
done


##############
# Parsing    #
##############

os_xrandr_reset
os_xrandr_parse

if [[ $1 == "--dmenu" || $1 == "-d" ]]; then
	##############
	# dmenu part #
	##############
	if [[ $2 == "dryrun" ]]; then
		DRYRUN=1
		echo "Dryrun mode, no changes!"
	fi

	MODE=`dmenu -nf $COLOR_P_FG1 -sb $COLOR_P_HI -nb $COLOR_P_BG -p "Select mode" <<< "$MODES"`

	getnum

    # auto mode is special, uses more xrandr magic and takes only
    # dryrun as aditional argument 
    if [[ $MODE == "auto" ]]; then
    	i=1
    	for outputs in `echo -e "${os_xrandr_displays[@]}"` ; do
    		output[$i]=$outputs
    		XY=$(eval "echo \${os_xrandr_modes_$outputs[@]}")
    		XY=`echo $XY | cut -d'\' -f1`
    		echo $XY
    		X[$i]=`echo $XY | cut -d'x' -f1`
    		Y[$i]=`echo $XY | cut -d'x' -f2`
    		i=`expr $i + 1` 
    	done
    	if [[ $i == 2 ]]; then
    		MODE="single"
    	else
    		MODE="dual"
    	fi
    else
    # Conventional dmenu mode, we need to ask for more settings
    	for i in `seq $MONSU` ; do
    		output[$i]=`echo -e "${os_xrandr_displays[@]}" | dmenu -nf $COLOR_P_FG1 -sb $COLOR_P_HI -nb $COLOR_P_BG -p "Select monitor $i"`
    		CUR_MODES=$(eval "echo \${os_xrandr_modes_${output[$i]}[@]}")
    		XY=`echo -e $CUR_MODES | dmenu -i -nf $COLOR_P_FG1 -sb $COLOR_P_HI -nb $COLOR_P_BG -p "Resolution for monitor $i"`

    		X[$i]=`echo $XY | cut -d'x' -f1`
    		Y[$i]=`echo $XY | cut -d'x' -f2`
    	done
    fi
else
	if [[ $@ == "" || $@ == "dryrun" ]]; then
		####################
		# interactive mode #
		####################

		if [[ $@ == "dryrun" ]]; then
			DRYRUN=1
			echo "Dryrun mode, no changes!"
		fi

		echo -n "Enter mode (single, beamer, dual, 2in1): "
		read MODE 
		
		getnum

		for i in `seq $MONSU` ; do
			echo "Choose output for monitor $i:"
			echo -e -n "${os_xrandr_displays[@]}"
			read output[$i]
			echo -n "Enter resolution X Y for monitor $i:"
			read X[$i] Y[$i]
		done

	else
		###################
		# arguments based #
		###################

		MODE=$1
		getnum
		if [[ $2 == "dryrun" ]]; then
			DRYRUN=1
			echo "Dryrun mode, no changes!"
		fi

		# auto mode is special, uses more xrandr magic and takes only
		# dryrun as aditional argument 
		if [[ $MODE == "auto" ]]; then
			i=1
			for outputs in `echo -e "${os_xrandr_displays[@]}"` ; do
				output[$i]=$outputs
				XY=$(eval "echo \${os_xrandr_modes_$outputs[@]}")
				XY=`echo $XY | cut -d'\' -f1`
				echo $XY
				X[$i]=`echo $XY | cut -d'x' -f1`
				Y[$i]=`echo $XY | cut -d'x' -f2`
				i=`expr $i + 1` 
			done
			if [[ $i == 2 ]]; then
				MODE="single"
			else
				MODE="dual"
			fi
		else

			for i in `seq $MONSU` ; do
				indoutput=$(( ($i * 2) + $DRYRUN ))
				indres=$((1+ ($i * 2) + $DRYRUN ))
				eval output[$i]=\$$indoutput
				eval XY=\$$indres
				X[$i]=`echo $XY | cut -d'x' -f1`
				Y[$i]=`echo $XY | cut -d'x' -f2`
			done
		fi
	fi
fi

if [[ $MONSU == 0 || $MONS == 0 ]]; then
	exit 255
fi


###################
# Breaking things #
###################

ex herbstclient lock

#pre setup of variables
case $MODE in
	"single" )
		XOFF[1]=0
		YOFF[1]=0

		MNAME[1]="intern"
		ex xrandr --output ${output[1]} --mode ${X[1]}x${Y[1]}
		;;
	"extern" )
		XOFF[1]=0
		YOFF[1]=0
		ex xrandr --output ${output[1]} --mode ${X[1]}x${Y[1]}

		MNAME[1]="extern"
		;;
	"beamer" )
		ex xrandr --output ${output[1]} ${X[1]}x${Y[1]}
		ex xrandr --output ${output[2]} ${X[2]}x${Y[2]}
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
			ex xrandr --output ${output[1]} --auto
			ex xrandr --output ${output[1]} ${X[1]}x${Y[1]}
			ex xrandr --output ${output[1]} --pos "${XOFF[1]}x${YOFF[1]}"
			ex xrandr --output ${output[2]} --auto
			ex xrandr --output ${output[2]} ${X[2]}x${Y[2]}
			ex xrandr --output ${output[2]} --pos "${XOFF[2]}x${YOFF[2]}"
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
