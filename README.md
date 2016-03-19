#my dotfiles

Dotfiles git including install-script, based on [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles), tweaked to accept a selected list of files/dirs, stored in files, to make adding easy by appending a path to the file.
Select optional files with interactive dialog.

Currently syncing bash and herbstluftwm, ssh/config, xinit/xsessionrc, comptonconfig, muttrc, Xdefaults, several fonts, a lot of scripts and some binaries and tools found in bin/. 

The configs are all designed to be either universal or be customicable for single hosts. All configuration is placed in bash_config

Feels free to use, some files, which are not written by me, contain special licence notices, please respect those, everything else if free to use as WTFPL

##current shell-prompt:
![bashprompt](https://cdn.rawgit.com/maxfragg/dotfiles/master/prompt.svg)

TODO:
* add dependencies
* add sublime-config (maybe?)
