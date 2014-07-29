#!/bin/bash

#read content of files to decide, which files should be installed
#files contains files for all hosts
#if filename starts with a "#" it will not be treated as hidden,
#and no "." will be added
#$HOSTNAME contains host specific files
#$HOSTNAME-not contains files excluded for this host,
#overwrites everything else

source bash_config

DOTFILES="`cat files`"
OPTIONAL="`cat files-opt`"

if [ -f $HOSTNAME ]; then
  DOTFILES="$DOTFILES `cat $HOSTNAME`" 
fi

if [ -f "$HOSTNAME"-not ]; then
  if [ -f $HOSTNAME ]; then
    DOTFILES=$(comm -3 <(cat files $HOSTNAME|sort) <(sort "$HOSTNAME"-not))
  else
    DOTFILES=$(comm -3 <(sort "files") <(sort "$HOSTNAME"-not))
  fi
fi

for name in $OPTIONAL; do
  echo "Install "$name"? [y\n]"
  read answer
  if [[ $answer == "y" ]]; then
    echo "adding"$name
    DOTFILES="$DOTFILES `echo $name`"
  else
    echo "skipping "$name
  fi
done


for name in $DOTFILES; do
  if [ `expr index "$name" "#"` == 1 ]; then
  	name=${name/"#"/""}
  	target="$HOME/$name"
  else
  	target="$HOME/.$name"
  fi

  if [ -e "$target" ]; then
    if [ -L "$target" ]; then
      echo "OK: $target"
    else
      echo "WARNING: $target exists but is not a symlink."
    fi
  else
    if [ "$name" != 'install.sh' ]; then
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

