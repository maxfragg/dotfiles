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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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



# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#herbstclient autocompletion
if [ -f /etc/bash_completion.d/herbstclient-completion ]; then
    source /etc/bash_completion.d/herbstclient-completion
fi


#default editor
export EDITOR=nano

#path


export PATH=$PATH:$HOME/bin:$HOME/.bin:/opt/intel/bin
export PATH=/usr/local/games:$PATH
export LANGUAGE=$LANGUAGE:de_DE:de 
#export LC_ALL=en_US.utf8

if [ -f ~/.cipbash ]; then
	source ~/.cipbash
fi

case "$HOSTNAME" in
    max-x61-ub)
        export PATH=/usr/local/share/perl/5.14.2/auto/share/dist/Cope:$PATH
        ;;
    max-x61-f15)
		
		;;
    taurus.uberspace.de)
        export LC_ALL=en_US.utf8
        ;;
    faui49man*)
        
        ;;
    faui0*)
        
        ;;
    faui3*)
       
        ;;
    irene-ThinkPad)
	
	;;
    debian-vm)
    	
    	;;
    *)
        ;;
    esac


#include prompt needed 
source ~/.bashprompt
