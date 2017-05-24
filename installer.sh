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
rm $file

sudo ln -s "$HOME/compiler/compile.sh" "/usr/local/bin/compile"
chmod +x compile.sh # make the bash script into an executable

createfolder "$HOME/.config/compiler"

# Save Default configurations into a config file
default='JAVA="${RED}[Java]${RESET}"\n'
default+='COMPILING="${RED}-----COMPILING-----${RESET}"\n'
default+='RUN="${RED}------RUNNING------${RESET}"\n'
default+='END="${RED}-------ENDED-------${RESET}"'
echo "$default" > "$HOME/.config/compiler/config"

echo "Compile command successfully installed"
