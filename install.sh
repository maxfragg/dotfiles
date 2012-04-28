#!/bin/bash

#read content of files to decide, which files should be installed
#files contains files for all hosts
#if filename starts with a "#" it will not be treated as hidden, 
#and no "." will be added
#$HOSTNAME contains host specific files
#$HOSTNAME-not contains files excluded for this host, 
#overwrites everything else

DOTFILES="`cat files`"


if [ -f $HOSTNAME ]; then
  DOTFILES="$DOTFILES `cat $HOSTNAME`"
else
  touch $HOSTNAME
fi

if [ -f "$HOSTNAME"-not ]; then
  if [ -f $HOSTNAME ]; then
    DOTFILES=$(comm -3 <(cat files $HOSTNAME|sort) <(sort "$HOSTNAME"-not))
  else
    DOTFILES=$(comm -3 <(sort "files") <(sort "$HOSTNAME"-not))
  fi
else
  touch "$HOSTNAME"-not
fi



cutstring="DO NOT EDIT BELOW THIS LINE"

for name in $DOTFILES; do
  if [ `expr index "$name" "#"` == 1 ]; then
  	name=${name/"#"/""}
  	target="$HOME/$name"
  else
  	target="$HOME/.$name"
  fi
  #echo "trying to install $target"
  #continue
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

