# Vimoir
# An attempt at a vim and tmux based IDE in convenien bash scripts

# Environment, things may happen if this is changed.
#! /bin/bash

PATH=$(realpath $1)
echo $PATH
if [ -e $PATH/.vimoire ]
then
	echo 'found'
else
	echo 'not found'
fi
