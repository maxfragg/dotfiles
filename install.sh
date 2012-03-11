#!/bin/bash

#read content of files to decide, which files should be installed
#files contains files for all hosts
#$HOSTNAME contains host specific files
#$HOSTNAME-not contains files excluded for this host, 
#overwrites everything else

DOTFILES="`cat files`"
if [$HOSTNAME == faui0* ]; then
  HOSTNAME_=faui00
else
  HOSTNAME_=$HOSTNAME
fi  
NOTHOST=""$HOSTNAME"-not"

if [ -f $HOSTNAME_ ]; then
  DOTFILES="$DOTFILES `cat $HOSTNAME_`"
else
  touch $HOSTNAME_
fi

if [ -f "$HOSTNAME_"-not ]; then
  if [ -f $HOSTNAME_ ]; then
    DOTFILES=$(comm -3 <(sort <(cat $HOSTNAME_ files)) <(sort $NOTHOST))
  else
    DOTFILES=$(comm -3 <(sort "files") <(sort $NOTHOST))
  fi
else
  touch $NOTHOST
fi



cutstring="DO NOT EDIT BELOW THIS LINE"

for name in $DOTFILES; do
  target="$HOME/.$name"
  #echo "trying to install $HOME/.$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      cutline=`grep -n -m1 "$cutstring" "$target" | sed "s/:.*//"`
      if [ -n "$cutline" ]; then
	cutline=$((cutline-1))
        echo "Updating $target"
        head -n $cutline "$target" > update_tmp
        startline=`sed '1!G;h;$!d' "$name" | grep -n -m1 "$cutstring" | sed "s/:.*//"`
        if [ -n "$startline" ]; then
          tail -n $startline "$name" >> update_tmp
        else
          cat "$name" >> update_tmp
        fi
        mv update_tmp "$target"
      else
        echo "WARNING: $target exists but is not a symlink."
      fi
    fi
  else
    if [ "$name" != 'install.sh' ]; then
      echo "Creating $target"
      if [ -n "$(grep "$cutstring" "$name")" ]; then
        cp "$PWD/$name" "$target"
      else
        ln -s "$PWD/$name" "$target"
      fi
    fi
  fi
done

