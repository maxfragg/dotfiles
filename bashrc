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
fi
# if [ -d /etc/bash_completion.d ]; then
#         source /etc/bash_completion.d/*
# fi
if [ -f /usr/share/bash-completion/bash_completion ]&& ! shopt -oq posix; then
    	source /usr/share/bash-completion/bash_completion
fi
if [ -d /usr/share/bash-completion/completions ]&& ! shopt -oq posix; then
     	source /usr/share/bash-completion/completions/*
fi


if [ -f /usr/local/lib/libcoloredstderr.so ]; then
    #echo "ld preload active"
    # export COLORED_STDERR_PRE=$'\033[91m' # bright red
    # export COLORED_STDERR_POST=$'\033[0m' # default

    export COLORED_STDERR_PRE="$(tput sgr0)$(tput setaf 1)"
    export COLORED_STDERR_POST="$(tput sgr0)"
    export LD_PRELOAD=/usr/local/lib/libcoloredstderr.so
    export COLORED_STDERR_FDS=2,
    export COLORED_STDERR_IGNORED_BINARIES=/usr/bin/yaourt
fi

#setxkbmap  -layout us -variant altgr-intl
export PATH=$HOME/bin:$PATH


#sp-tutor stuff
if [ -d $HOME/git/sp_svn/bin ]; then
    export PATH=$HOME/git/sp_svn/bin/:$PATH

    export _SP_SVN_PATH=$HOME/git/sp_svn
    export _SP_HOST=el79irih@cip


    sp-init-testsuite() {
        if [ -e "${_SP_SVN_PATH}/aufgaben/$1/testcase/" ]; then
            export TESTBASE="${_SP_SVN_PATH}/aufgaben/$1/testcase/"
            source "${TESTBASE}/setup.sh"
        else
            echo >&2 "sp-init-testsuite: no testcases found for exercie '$1'"
            return 1
        fi
    }
    complete -W "$(echo ${_SP_SVN_PATH}/aufgaben/*/testcase | xargs -n1 dirname | xargs -n1 basename)" sp-init-testsuite
fi

if [ -d $HOME/lib ]; then
    export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
fi

#export PATH=/usr/local/games:$PATH
#export LANGUAGE=$LANGUAGE:de_DE:de
export LANG=de_DE.UTF-8
export LC_TIME=en_DK.UTF-8
export LC_MESSAGES=POSIX
#export LC_COLLATE=C

us-int-gr

export NO_AT_BRIDGE=1
export EDITOR="nano"

#bare path cd and correct spelling in cd
shopt -s cdspell
shopt -s autocd
shopt -s cmdhist

if [ -f ~/.cipbash ]; then
	source ~/.cipbash
fi

if [ -e /usr/share/terminfo/x/xterm-256color ] && [ "$COLORTERM" == "xfce4-terminal" ]; then
    export TERM=xterm-256color
fi


#include prompt needed 
#source ~/.bash_powerline
source ~/.bashprompt
export GOROOT=$HOME/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
