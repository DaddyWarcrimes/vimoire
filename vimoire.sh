#! /bin/bash

# Vimoir
# An attempt at a vim and tmux based IDE in convenient bash scripts

#----------------------------------------------------------------------------------------
# User defined variables

# Quick save keybinding

QSKEY="<F11>"

#----------------------------------------------------------------------------------------
# Subroutines

# Create vim variables file
s_vars(){
	echo "let vimoirepath = '$PPATH/.vimoire/quicksave.vim'" > $PPATH/.vimoire/vars.vim
	echo "map $QSKEY :execute \"mksession! \" . vimoirepath<cr>" >> $PPATH/.vimoire/vars.vim
	echo "inoremap $QSKEY <esc>:execute \"mksession! \" . vimoirepath<cr>" >> $PPATH/.vimoire/vars.vim
}

# 1st passed parameter is the path
PPATH=$(realpath $1)
#
PNAME=$(basename $PPATH)


if [ -e $PPATH/.vimoire ]
then
	if [ -e $PPATH/.vimoire/vars.vim ]
	then 
		if [ -e $PPATH/.vimoire/quicksave.vim ]
		then
			vim -S $PPATH/.vimoire/quicksave.vim -S $PPATH/.vimoire/vars.vim $PPATH
		else
			vim -S $PPATH/.vimoire/vars.vim $PPATH
		fi
	else
		if [ -e $PPATH/.vimoire/quicksave.vim ]
		then
			s_vars
			vim -S $PPATH/.vimoire/quicksave.vim -S $PPATH/.vimoire/vars.vim $PPATH
		else
			s_vars
			vim -S $PPATH/.vimoire/vars.vim $PPATH
		fi
	fi

else
	echo 'not found'
	mkdir $PPATH/.vimoire
	s_vars
	vim -S $PPATH/.vimoire/vars.vim $PPATH
fi
