#! /bin/bash

# Vimoir
# A bash wrapper for vim to save and restore sessions of coding projects

#----------------------------------------------------------------------------------------
# User defined variables
# Delete ~/.config/vimoire for any settings to take effect

# Quick save keybinding

QSKEY="<F11>"

#----------------------------------------------------------------------------------------
# Subroutines


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
	echo "map $QSKEY :execute \"mksession! \" . vimoirepath<cr>" > ~/.config/vimoire/settings.vim
	echo "inoremap $QSKEY <esc>:execute \"mksession! \" . vimoirepath<cr>" >> ~/.config/vimoire/settings.vim
fi


#----------------------------------------------------------------------------------------
# Session settup

# Session settings subdirectory
if [ ! -e $PPATH/.vimoire ]
then
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

