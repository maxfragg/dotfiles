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

#programmable autocompletion
if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
fi

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

source ~/GIT/herbstluftwm/share/herbstclient-completion

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


#default editor
export EDITOR=nano

#path
export PATH=$PATH:$HOME/bin:$HOME/.bin:/opt/intel/bin
#export PATH=/usr/local/share/perl/5.12.4/auto/share/dist/Cope:
export PATH=/usr/local/games:$PATH
export LANGUAGE=$LANGUAGE:de_DE:de

netinfo ()
{
echo "Internal IPv4 address of eth0: "; ifconfig | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
echo "External IPv4 address: "; wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//' 
echo "MAC of eth0: "; ifconfig | awk '/HWaddr/ { print $NF }';
}

##################################
##	BASH PROMPT	##
##################################

#source ~/.bash_it/themes/base.theme.bash

## Fancy PWD display function
## The home directory (HOME) is replaced with a ~
## The last pwdmaxlen characters of the PWD are displayed
## Leading partial directory names are striped off
## /home/me/stuff          -> ~/stuff               if USER=me
## /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
 function bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=12
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
 }
 function bash_prompt() {
    case $TERM in
     xterm*|rxvt*)
         local TITLEBAR='\[\033]0;\u:${NEW_PWD}\007\]'
          ;;
     *)
         local TITLEBAR=""
          ;;
    esac
    local NONE="\[\033[0m\]"    # unsets color to term's fg color
    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white
    # emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"
    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"
    local UC=$R                 # user's color
    [ $UID -eq "0" ] && UC=$C   # root's color
    PS1="$TITLEBAR${EMK}${UC}\u${EMK} ${EMB}\${NEW_PWD}${EMK}${UC}\\$ ${NONE}"
    # without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt
 }
 PROMPT_COMMAND=bash_prompt_command
 bash_prompt
 unset bash_prompt
 
 
##################################################
##	added scripts and comfort-functions          #
##################################################
 


##################################################
############# Fun stuff        ###################
##################################################

alias matrix='echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; done'
alias matrix2='echo -e "\e[31m"; while $t; do for i in `seq 1 30`;do r="$[($RANDOM % 2)]";h="$[($RANDOM % 4)]";if [ $h -eq 1 ]; then v="\e[1m $r";else v="\e[2m $r";fi;v2="$v2 $v";done;echo -e $v2;v2="";done;'
alias matrix3='COL=$(( $(tput cols) / 2 )); clear; tput setaf 2; while :; do tput cup $((RANDOM%COL)) $((RANDOM%COL)); printf "%$((RANDOM%COL))s" $((RANDOM%2)); done'
alias matrix4='echo -ne "\e[32m" ; while true ; do echo -ne "\e[$(($RANDOM % 2 + 1))m" ; tr -c "[:print:]" " " < /dev/urandom | dd count=1 bs=50 2> /dev/null ; done'
alias matrix5='tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=lcase,unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias roulette='[ $[ $RANDOM % 6 ] == 0 ] && echo Die || echo Live'				# command line Russian roulette
alias starwars='telnet towel.blinkenlights.nl'							# the famous starwars ASCII version from telnet

alias futurama='curl -Is slashdot.org | sed -n '5p' | sed 's/^X-//''				# get Futurama quotations from slashdot.org servers

##################################################
# Swap 2 filenames around			 #
##################################################

###### from Uzi's bashrc
function swap()
{
    local TMPFILE=tmp.$$
    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}



##################################################
# Network/Internet -oriented stuff		 #
##################################################

alias appson="netstat -lantp | grep -i stab | awk -F/ '{print $2}' | sort | uniq"	# view only the process name using an internet connection
alias bandwidth='dd if=/dev/zero of=/dev/null bs=1M count=32768'			# processor / memory bandwidthd? in GB/s
alias browse_bonjour='dns-sd -B'							# browse services advertised via Bonjour
alias dbdumpcp='scp -P 1234 username@12.34.56.78:$HOME/Backup/www/data/someSite/db.sql $HOME/Backup/data/db.sql'	# copy remote db to local
alias dns='cat /etc/resolv.conf'							# view DNS numbers
alias domain2ban='~/.scripts/Domain2Ban.sh'
alias estab='ss -p | grep STA' 								# view only established sockets (fails if "ss" is screensaver alias)
alias finchsync='java -jar ~/finchsync/finchsync.jar'					# start FinchSync Admin
alias hdinfo='hdparm -i[I] /dev/sda'							# hard disk information - model/serial no.
alias hostip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'
alias hostname_lookup='lookupd -d'							# interactive debugging mode for lookupd (use tab-completion)
alias http_trace='pkt_trace port 80'							# to show all HTTP packets
alias iftop='sudo iftop -i eth0' 							# start "iftop" program (sudo apt-get install iftop)
alias ip4grep="grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}'"					# look for IPv4 address in files
alias ip='curl www.whatismyip.org'
alias ip_info='ipconfig getpacket en1'							# info on DHCP server, router, DNS server, etc (for en0 or en1)
alias ipt80='sudo iptstate -D 80'							# check out only iptables state of http port 80 (requires iptstate)
alias ip_trace='pkt_trace ip'								# to show all IP packets
alias ipttrans='sudo iptstate -D 51413'							# iptables state of Transmission-Daemon port (requires iptstate)
alias listen='sudo netstat -pnutl' 							# lists all listening ports together with PID of associated process
alias lsock='sudo /usr/sbin/lsof -i -P'							# to display open sockets ( -P option to lsof disables port names)
alias netapps="lsof -P -i -n | cut -f 1 -d ' '| uniq | tail -n +2"
alias nethogs='sudo nethogs eth0' 							# start "nethogs" program (sudo apt-get install nethogs)
alias netl='sudo nmap -sT -O localhost'
alias netscan='sudo iwlist wlan0 scan'							# to scan your environment for available networks, do the following
alias netstats='sudo iwspy wlan0'							# if card supports it, you can collect wireless statistics by using
alias network='sudo lshw -C network' 							# view network device info
alias networkdump='sudo tcpdump not port 22' 						# dump all the network activity except ssh stuff
alias nsl='netstat -f inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'		# show all programs connected or listening on a network port
alias ns='netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail +2'
alias openports='sudo netstat -nape --inet' 						# view open ports
alias pkt_trace='sudo tcpflow -i `active_net_iface` -c'
alias ports='lsof -i -n -P' 								# view programs using an internet connection
alias portstats='sudo netstat -s' 							# show statistics for all ports
alias ramvalue='sudo dd if=/dev/mem | cat | strings'					# will show you all the string (plain text) values in ram
alias randommac='python -c "from itertools import imap; from random import randint; print ':'.join(['%02x'%x for x in imap(lambda x:randint(0,255), range(6))])"'										# generate random valid mac addresses
alias remote='ssh -p 1234 12.34.56.78'							# access some remote host
alias restartnet='sudo /etc/rc.d/network restart;sudo /etc/rc.d/wicd restart'
alias rssup='php /srv/http/rssupdate.php'
alias setessid='sudo iwconfig wlan0 essid network-essid'				# set the essid, which identifies the network access point you want
alias smtp_trace='pkt_trace port smtp'							# to show all SMTP packets
alias tcpstats='sudo netstat -st' 							# show statistics for tcp ports
alias tcp_='sudo netstat -atp' 								# list all TCP ports
alias tcp_trace='pkt_trace tcp'								# to show all TCP packets
alias topsites='curl -s -O http://s3.amazonaws.com/alexa-static/top-1m.csv.zip ; unzip -q -o top-1m.csv.zip top-1m.csv ; head -1000 top-1m.csv | cut -d, -f2 | cut -d/ -f1 > topsites.txt'							# get a list of top 1000 sites from alexa
alias tproxy='ssh -ND 8118 user@server&; export LD_PRELOAD="/usr/lib/libtsocks.so"'	# creates a proxy based on tsocks
alias udpstats='sudo netstat -su' 							# show statistics for udp ports
alias udp='sudo netstat -aup' 								# list all UDP ports
alias udp_trace='pkt_trace udp'								# to show all UDP packets
alias website_dl='wget --random-wait -r -p -e robots=off -U mozilla "$1"'		# download an entire website
alias website_images='wget -r -l1 --no-parent -nH -nd -P/tmp -A".gif,.jpg" "$1"'	# download all images from a site
alias whois='whois -H'
alias wscan='iwlist scan'								# terminal network scan for wireless signals
alias wwwmirror2='wget -k -r -l ${2} ${1}'						# wwwmirror2 usage: wwwmirror2 [level] [site_url]
alias wwwmirror='wget -ErkK -np ${1}'

