#!/bin/bash

function createfolder()
{
	if [ ! -d $1 ]; then
  	mkdir -p $1
	fi
}
CYANE="$(tput setaf 26)"
RESET="$(tput sgr0)"

createfolder "$HOME/compiler"
link="/usr/local/bin/compile"
rm $link 2> /dev/null

(curl -s https://raw.githubusercontent.com/balamou/compiler/master/compile.sh) > "$HOME/compiler/compile.sh"
echo "compile.sh successfully loaded"
(curl -s https://raw.githubusercontent.com/balamou/compiler/master/config) > "$HOME/compiler/config"
echo "config successfully loaded"
echo "Creating symlink..."

sudo ln -s "$HOME/compiler/compile.sh" "$link"
cd "$HOME/compiler/"
chmod +x compile.sh # make the bash script into an executable

echo "${CYANE}Compile command successfully installed!${RESET}"
