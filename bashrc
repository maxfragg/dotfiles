# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" 2>/dev/null

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes


#bash alias file
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bashscripts ]; then
    source ~/.bashscripts
fi

if [ -f ~/.z.sh ]; then
    source ~/.z.sh
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
	if [ -f /usr/share/bash-completion/bash_completion ] && ! shopt -oq posix; then
    	source /usr/share/bash-completion/bash_completion
	fi

	if [ -d /usr/share/bash-completion/completions ] && ! shopt -oq posix; then
    	source /usr/share/bash-completion/completions/*
	fi

	#herbstclient autocompletion
	if [ -d /etc/bash_completion.d ]; then
    	source /etc/bash_completion.d/*
	fi
fi

if [ -f /usr/local/lib/libcoloredstderr.so ]; then
    #echo "ld preload active"
    export COLORED_STDERR_PRE=$'\033[91m' # bright red
    export COLORED_STDERR_POST=$'\033[0m' # default
    export LD_PRELOAD=/usr/local/lib/libcoloredstderr.so
    export COLORED_STDERR_FDS=2,
    export COLORED_STDERR_IGNORED_BINARIES=/usr/bin/yaourt
fi

#setxkbmap  -layout us -variant altgr-intl

export PATH=$HOME/bin:$PATH
#export PATH=/usr/local/games:$PATH
export LANGUAGE=$LANGUAGE:de_DE:de 
export LC_ALL=en_US.utf8
export NO_AT_BRIDGE=1
export EDITOR="nano"

if [ -f ~/.cipbash ]; then
	source ~/.cipbash
fi

if [ -e /usr/share/terminfo/x/xterm-256color ] && [ "$COLORTERM" == "xfce4-terminal" ]; then
    export TERM=xterm-256color
fi


#include prompt needed 
#source ~/.bash_powerline
source ~/.bashprompt
