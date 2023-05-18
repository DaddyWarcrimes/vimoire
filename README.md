# vimoire

vimoire is a bash wrapper for vim. It allows you to easily save and load project-specific vim sessions.

The first time you run vimoire, it will create a settings file and a symbolic link.

The settings file at ~/.config/vimoire/settings.vim sets a vim keybinding (F11 by default) to save your current session in the project folder. This will override whatever you had bound in vimrc, but only if you run vim using vimoire. 

A symbolic link to the vimoire.sh script will be added at ~/bin/vimoire. After the first run, you can now use the following command to open your project session

	vimoire /path/to/project

To save the current session, simply hit F11 (or your custom keybind) at any time. The next time you run vimoire on that project subdirectory, vimoire will automatically restore your tabs and splits.

Currently vimoire only supports one session saved per project subdirectory.


