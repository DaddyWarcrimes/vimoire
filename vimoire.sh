#! /bin/bash

# Vimoir
# A bash wrapper for vim to save and restore sessions of coding projects

VER=1


#----------------------------------------------------------------------------------------
# TODO
#
# Remove quicksave keybind from quicksave.vim. Maybe search the file and delete the line on load, or perhaps find a way for ~/.config/vimoire/settings.vim to take priority

#----------------------------------------------------------------------------------------
# User defined variables

# Quick save keybinding

QSKEY="<F11>"

#----------------------------------------------------------------------------------------
# Subroutines

# Create symbolic link in ~/bin to this script
s_link(){
	SCRIPT="$(realpath $0)"
	if [ -f ~/bin/vimoire ]; then
		TARGET=$(readlink ~/bin/vimoire)

		if [ $TARGET == $SCRIPT ]; then
			echo "Existing symbolic link is already pointing to this script. Install aborted."
		else
			echo "An existing symbolic link is pointing to $TARGET instead of $SCRIPT"
			echo "This may be the result of an older version of the script, or moving the script file"
			echo "Would you like to replace the existing symbolic link? (Y/N)"
			read n
			case $n in
				"y")
					;&
				"Y")
					;&
				"Yes")
					;&
				"yes")
					;&
				"YES")
				ln -sf $SCRIPT ~/bin/vimoire
				;;

				*)
					echo "Aborting"

					;;
			esac
			
		fi

	else
		ln -s $SCRIPT ~/bin/vimoire
	fi
}

# Delete ~/.config/vimoire for any settings to take effect
s_delete(){
	rm ~/bin/vimoire
	rm -r ~/.config/vimoire
}

# Prints out instructions and options
s_help(){
	echo " "
	echo "vimoire, version $VER"
	echo ""
	echo "To use vimoire normally, use a directory as an arguement. e.g.: './vimoire.sh /path/to/subdirectory'"
	echo " "
	echo "or if you have run with the --install flag: 'vimoire /path/to/subdirectory'"
	echo ""
	echo "To save your Vim session, use the keybinding $QSKEY"
	echo "You can change this keybinding by editing ~/.config/vimoire/settings.vim or $(realpath $0)"
	echo " "
	echo "Options:"
	echo "--help 	Displays this information"
	echo "--install	Adds a symbolic link at ~/bin/vimoire"
	echo "--delete 	Removes ~/bin/vimoire symbolic link and ~/.config/vimoire/ subdirectory"
}

#----------------------------------------------------------------------------------------
# Flag handling

if [ ! -e $1 ]; then
	case $1 in
		"--help")
			s_help
			;;
		"--delete")
			s_delete
			;;
		"--install")
			s_link
			;;
		*)
			echo " "
			echo "Invalid argument: $1"
			s_help
			;;
	esac
	exit
fi

#----------------------------------------------------------------------------------------
# Path variable

PPATH=$(realpath $1)

#----------------------------------------------------------------------------------------
# Global settings

# Settings subdirectory
if [ ! -e ~/.config/vimoire ]
then
	mkdir ~/.config/vimoire
fi

# Settings file... really just a quicksave keybind
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

#----------------------------------------------------------------------------------------
# Open directory

if [ -d $PPATH ]; then
	if [ -e $PPATH/.vimoire/quicksave.vim ]
	then
		vim -S $PPATH/.vimoire/quicksave.vim -S $PPATH/.vimoire/vars.vim -S ~/.config/vimoire/settings.vim
	else
		vim -S $PPATH/.vimoire/vars.vim -S ~/.config/vimoire/settings.vim $PPATH
	fi
elif [ -f $PPATH ]; then
	echo "Target is not a directory"
	vim $PPATH
fi


