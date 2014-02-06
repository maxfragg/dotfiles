#!/bin/bash

lock(){
	if [[ $1 == "-info" ]]; then
		echo "current wallset is: "$WALLSET
		echo "available sets are:"
		echo `ls ~/git/wallpaper/`
		return
	fi
	if [[ $1 != "" ]]; then
		WALLSET=$1
	else
		if [[ $WALLSET == "" ]]; then
			WALLSET=misc
		fi
		
	fi
	local files=(~/git/wallpaper/$WALLSET/*.png)
	#printf "%s\n" "${files[RANDOM % ${#files[@]}]}"

	i3lock -i `printf "%s\n" "${files[RANDOM % ${#files[@]}]}"`
		
}


lock misc