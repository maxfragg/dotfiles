#!/bin/csh -f
#We do not want wmaker to fiddle with this file, hence this line.

setenv SHAREDENV ~/.ENV
setenv ENVCFG ~/.envcfg.csh


if ( -r $ENVCFG ) then
  source $ENVCFG
else
  xterm -ls -geometry 80x40+200+100 -font "-adobe-courier-medium-r-normal--14-*" -T ' ENVcfg ' -bg white -e /local/login/bin/envcfg || /bin/true
  source $ENVCFG
endif

#Fallback if everything else breaks...
if ( ! $?WMNAME ) then
  setenv WMNAME kde
  setenv WMPATH /local/kde/bin
  setenv WMBIN startkde
  setenv SHELL /local/bin/tcsh
endif

if ( -r $SHAREDENV/xinitrc ) then
    source $SHAREDENV/xinitrc
else
    echo "Can't access $SHAREDENV/xinitrc."
endif

#Setting path and probably kdedir
switch ($WMNAME)
    case kde*:
    	setenv KDEDIR /local/$WMNAME
	setenv KDEDIRS $KDEDIR/CIP:$KDEDIR/COMMON:$KDEDIR
        setenv PATH ${WMPATH}:${PATH}
	breaksw
    default:
        setenv PATH ${PATH}:${WMPATH}
endsw

setenv AGENTBIN ""
if ( -x /usr/bin/ssh-agent ) then
  setenv AGENTBIN /usr/bin/ssh-agent
endif

#
# You may enhance the following part to your likes:
#

xrandr --output default --mode 1920x1200

# start window manager in foreground

feh --bg-center ~/wallpaper1383912.jpg&
addpackage herbstluftwm-git

#xWM=`echo -e "hlwm\n xfce4\n opera" | dmenu`
exec ssh-agent `dmenu <~/.wmlist`
#we should never reach this!
exec ssh-agent herbstluftwm


switch ($ARCH)
    case irix:
        xbiff -geometry 50x50+5-125 &
        xclock -update 1 -geometry 100x100+5-5 &
        winterm -console -geometry 80x25+150+30 -name Console -iconic -e tcsh &
        winterm -geometry 80x40+250+150 -T ' local tcsh ' -e tcsh &
        sleep 1
        toolchest &
        4Dwm
        breaksw
    case sun4:
        $AGENTBIN $WMBIN
        breaksw
    case i686:
       # $AGENTBIN $WMBIN
	exec ssh-agent herbstluftwm
        breaksw
    default:
        # If we have an architecture not listed before,
	# try to load something usefull
        xbiff -geometry 50x50+5-125 &
        xclock -update 1 -geometry 100x100+5-5 &
        xterm -C +vb -geometry 80x5+200+30 -T ' Console ' -e tcsh &
        xterm -ls -geometry 80x40+200+200 -T ' local tcsh ' -e tcsh &
        sleep 1
        mwm
endsw

# when the window manager terminates, the X-session is terminated
