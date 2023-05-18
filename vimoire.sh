#! /bin/bash

# Vimoir
# A bash wrapper for vim to save and restore sessions of coding projects

# version 20230518


#----------------------------------------------------------------------------------------
# TODO
#
# Move symbolic link to --install arguement
#
# Create --delete argument to remove symbolic link and settings file
#
# Create --help argument (will also show if no parameters passed)
#
# Check if passed argument is a directory, and handle invalid arguments

#----------------------------------------------------------------------------------------
# User defined variables
# Delete ~/.config/vimoire for any settings to take effect

# Quick save keybinding

QSKEY="<F11>"

#----------------------------------------------------------------------------------------
# Subroutines


#----------------------------------------------------------------------------------------
# Flags

# This is just a stub
# Should be a case block with --delete, --install, and --help
if [ $1 == "--delete" ]
then
       echo "delete"
       exit 0
fi


#----------------------------------------------------------------------------------------
# Path variables

PPATH=$(realpath $1)

PNAME=$(basename $PPATH)

#----------------------------------------------------------------------------------------
# Global setup

# Settings subdirectory
if [ ! -e ~/.config/vimoire ]
then
	mkdir ~/.config/vimoire
fi

# Supplemental settings file... really just a quicksave keybind
if [ ! -e ~/.config/vimoire/settings.vim ]
then
	echo "map $QSKEY :execute \"mksession! \" . vimoirepath <bar> echo \"Session Saved\"<cr>" > ~/.config/vimoire/settings.vim
	echo "inoremap $QSKEY <esc>:execute \"mksession! \" . vimoirepath <bar> echo \"Session Saved\" <cr>a" >> ~/.config/vimoire/settings.vim
fi

# Symbolic link in ~/bin

if [ ! -e ~/bin/vimoire ]
then
	SCRIPT="$(realpath $0)"
	ln -s $SCRIPT ~/bin/vimoire
fi

#----------------------------------------------------------------------------------------
# Session settup

# Session settings subdirectory
if [ ! -e $PPATH/.vimoire ]
then
	echo "Creating session folder"
	mkdir $PPATH/.vimoire
fi

# Session settings
if [ ! -e $PPATH/.vimoire/vars.vim ]
then
	echo "let vimoirepath = '$PPATH/.vimoire/quicksave.vim'" > $PPATH/.vimoire/vars.vim
fi

if [ -e $PPATH/.vimoire/quicksave.vim ]
then
	vim -S $PPATH/.vimoire/quicksave.vim -S $PPATH/.vimoire/vars.vim -S ~/.config/vimoire/settings.vim
else
	vim -S $PPATH/.vimoire/vars.vim -S ~/.config/vimoire/settings.vim $PPATH
fi

