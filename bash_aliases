#!/bin/bash


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l -h'
alias la='ls -A'
alias l='ls -CF'
alias .sh='ls | grep ".sh"'

#alias ack=ack-grep
#alias battery="acpitool --battery | grep Remaining | cut -d' ' -f10 | cut -d',' -f1" 
alias prompt_git='GIT=1'
alias prompt_fast='GIT=0'
alias rootpath='PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH'
#alias uberspace='mosh --server=/home/maxfragg/tmp/mosh-1.2.2/src/frontend/mosh-server --port=51988 uber'
alias uberspace='mosh --server=/usr/local/bin/mosh-server --port=62011 uber2'
alias ping='ping -c 4'
alias openports='netstat -nape --inet'
alias valgrind='valgrind --leak-check=full'
alias install='sudo apt-get install'
alias add='sudo apt-add-repository'
alias svnpng='for i in *; do rsvg-convert $i -o `echo $i | sed -e 's/svg$/png/'`; done'

alias flatten='find . -type f -exec mv '{}' . \;'
alias nano='nano -cmiF'
alias hc='herbstclient'
alias hlwm='herbstluftwm'
#alias a='aura'
#alias y='yaourt'
alias exec_on_tag='~/.config/herbstluftwm/exec_on_tag.sh'
alias difff='diff -urNp'
alias sshtunnel='ssh -D 8080 -f -C -N uni'
alias ucrypt='encfs ~/Seafile/private/enc ~/private'
alias bluetooth_off="sudo rfkill block bluetooth"
alias bluetooth_on="sudo rfkill unblock bluetooth"
alias tint2rs='pkill tint2 && herbstclient spawn tint2'
alias sshfs_cip="sshfs el79irih@faui06e.cs.fau.de:/home/cip/2009/el79irih cip"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias us-int-gr='setxkbmap  -layout us -variant altgr-intl' 
alias us-int="setxkbmap -option '' 'us international' ',phonetic'"
alias dropbox="cd ~/Dropbox"
alias current="cd ~/current"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
