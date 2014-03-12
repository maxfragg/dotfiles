#my dotfiles

Dotfiles GIT including install-script, based on [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles), tweaked to accept a selected list of files/dirs, stored in files, to make adding easy by appending a path to the file.
Select which files to sync based on hostname, with white and blacklist and with optional files, with interactive dialog.

Currently syncing bash and herbstluftwm, ssh/config, xinit/xsessionrc, comptonconfig, muttrc, source-code-pro font, a lot of scripts and some binaries, x64 specific.

Feels free to use, some files, which are not written by me, contain special licence notices, please respect those, everything else if free to use as WTFPL

TODO:
* add sublime-config
* automate backup process
* create deployable package without git
