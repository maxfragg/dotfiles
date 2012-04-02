## Openbox autostart.sh
## ====================
## When you login to your CrunchBang Openbox session, this autostart script 
## will be executed to set-up your environment and launch any applications
## you want to run at startup.
##
## More information about this can be found at:
## http://openbox.org/wiki/Help:Autostart
##
## If you do something cool with your autostart script and you think others
## could benefit from your hack, please consider sharing it at:
## http://crunchbanglinux.org/forums/
##
## Have fun! :)

## Start session manager
lxsession &

## Enable power management
xfce4-power-manager &

## Start Thunar Daemon
thunar --daemon &

## Set desktop wallpaper
nitrogen --restore &

## Launch panel
tint2 &

# elementary
#plank &
#wingpanel &

## Enable Eyecandy - off by default, uncomment one of the commands below.
## Note: cairo-compmgr prefers a sleep delay, else it tends to produce
## odd shadows/quirks around tint2 & Conky.
#(sleep 10s && cb-compmgr --cairo-compmgr) &
#cb-compmgr --xcompmgr & 
xcompmgr &


## Launch network manager applet
(sleep 8s && nm-applet) &

## Detect and configure touchpad. See 'man synclient' for more info.
if egrep -iq 'touchpad' /proc/bus/input/devices; then
    synclient VertEdgeScroll=1 &
    synclient TapButton1=1 &
fi

## Start xscreensaver
xscreensaver -no-splash &

## Start Conky after a slight delay
#(sleep 3s && conky -q) &

## Start volumeicon after a slight delay
(sleep 3s && gnome-volume-control-applet) &

## Start Clipboard manager
(sleep 3s && parcellite) &

## Bad Nautilus, minimises the impact of running Nautilus under
## an Openbox session by applying some gconf settings. Safe to delete.
#cb-bad-nautilus &

## The following command will set-up a keyboard map selection tool when
## running in a live session.
#cb-setxkbmap-live &

## cb-welcome - post-installation script, will not run in a live session and
## only runs once. Safe to remove.
#(sleep 10s && cb-welcome --firstrun) &

## cb-fortune - have Statler say a little adage
#(sleep 120s && cb-fortune) &

##synapse launcher
(sleep 10s && synapse) &

##dropbox
(sleep 10s && dropbox start)

##keyring
#(sleep 1 && gnome-keyring-deamon) &

#(sleep 1 && /usr/bin/gnome-keyring-daemon --start --components=ssh) &

#if [ -z $GNOME_KEYRING_PID ]; then
#	eval "'gnome-keyring-daemon'"
#	export GNOME_KEYRING_PID
#	export GNOME_KEYRING_SOCKET
#fi

eval `ssh-agent`

##conky
#(sleep 2s && conky -c ~/.conkycolors/conkyrc ) &                                       

##scrolling
xinput set-prop 10 "Evdev Wheel Emulation" 1
xinput set-prop 10 "Evdev Wheel Emulation Button" 2
xinput set-prop 10 "Evdev Wheel Emulation Timeout" 200
