#!/bin/bash

current_layout=$(herbstclient getenv CURRENT_KB_LAYOUT)

if [[ "$current_layout" == "us" ]]; then
	setxkbmap -layout de
	current_layout="de"
	herbstclient setenv CURRENT_KB_LAYOUT de
else
	setxkbmap  -layout us -variant altgr-intl
	current_layout="us"
	herbstclient setenv CURRENT_KB_LAYOUT us
fi

notify-send -t 3000 -i keyboard "Set layout to $current_layout"
