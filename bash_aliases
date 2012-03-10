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

alias ping='ping -c 4'
alias openports='netstat -nape --inet'
alias valgrind='valgrind --leak-check=full'
alias install='sudo apt-get install'
alias add='sudo apt-add-repository'
alias sysprog='cd ~/SVN/el79irih/trunk/'
alias svnpng='for i in *; do rsvg-convert $i -o `echo $i | sed -e 's/svg$/png/'`; done'
alias irc='sh ~/irssi_notify.sh & ssh baron'
alias flatten='find . -type f -exec mv '{}' . \;'
alias edit=scribes
alias nano='nano -cmiF'
alias hc='herbstclient'
alias hlwm='herbstluftwm'
alias exec_on_tag='~/.config/herbstluftwm/exec_on_tag.sh'
alias difff='diff -urNp'
alias sshtunnel='ssh -D 8080 -f -C -N uni'
alias tint2rs='pkill tint2 && herbstclient spawn tint2'
alias tint2wiz='~/bin/tint2wiz/./tintwizard.py'
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"
alias ucrypt='encfs ~/Dropbox/BoxCryptor ~/Private'
alias bluetooth_off="sudo rfkill block bluetooth"
alias bluetooth_on="sudo rfkill unblock bluetooth"
alias sshfs_cip="sshfs el79irih@faui06e.cs.fau.de:/home/cip/2009/el79irih cip"