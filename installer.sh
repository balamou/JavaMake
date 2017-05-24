#!/bin/bash

function createfolder()
{
	if [ ! -d $1 ]; then
  	mkdir -p $1
	fi
}

createfolder "$HOME/compiler"
(curl https://raw.githubusercontent.com/balamou/compiler/master/compile.sh) > "$HOME/compiler/compile.sh"
file="/usr/local/bin/compile"
rm $file 2> /dev/null

sudo ln -s "$HOME/compiler/compile.sh" "/usr/local/bin/compile"
cd "$HOME/compiler/"
chmod +x compile.sh # make the bash script into an executable

# Save Default configurations into a config file
createfolder "$HOME/.config/compiler"
(curl https://raw.githubusercontent.com/balamou/compiler/master/config) > "$HOME/.config/compiler/config"

echo "Compile command successfully installed"
