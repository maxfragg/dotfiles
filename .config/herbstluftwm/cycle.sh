#!/bin/bash

# Changes herbstluftwm tags

checkuse() {
	echo "Checking $i / tags: ${tags[@]} / tags[i]: ${tags[$1]}"
	if [[ "${tags[$1]}" != .* ]]; then # tag is not unused
		echo "Using $1 / ${tags[$1]}"
		herbstclient use "${tags[$1]:1}" # cutting off first char (.#:!)
		exit 0
	fi
}


tags=( $(herbstclient tag_status) )

# Find the currently active tag
for ((i=0; i<="${#tags[@]}"; i++)); do
	[[ "${tags[i]}" == "#"* ]] && activetag="$i"
done

if [[ "$1" == +* || "$1" == -* ]]; then # +/- n
	new_i=$(( (activetag $1) % ${#tags[@]} )) # + or - is already in $1
	herbstclient use "${tags[$new_i]:1}" # cutting off first char (.#:!)
	exit 0
elif [[ "$1" == next ]]; then # next active tag
	for ((i="$((activetag+1))"; i<"${#tags[@]}"; i++)); do
		checkuse "$i"
	done
	# at the end of the taglist, wrap around
	for ((i=0; i<"$activetag"; i++)); do
		checkuse "$i"
	done
elif [[ "$1" == prev ]]; then # previous active tag
	for ((i="$((activetag-1))"; i>=0; i--)) do
		checkuse "$i"
	done
	# at the beginning of the taglist, wrap around
	for ((i=${#tags[@]}-1; i>$((activetag-1)); i--)) do
		checkuse "$i"
	done
else
	echo "Usage: $0 [+<n>|-<n>|next|prev]"
	exit 1
fi
