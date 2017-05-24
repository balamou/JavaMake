#!/bin/bash
# compiles and runs the Java code
# @author Michel Balamou (michelbalamou@gmail.com)
# export PS1="\\[\e[91m\]\W \$ \\[\e[0m\]"; clear;

# Formating tags
RESET="$(tput sgr0)"
BLUE="$(tput setaf 32)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 35)"
YELLOW="$(tput setaf 11)"

# Output variables
source "$HOME/.config/compiler/config"

function run()
{
	classname=$1
	isWarning=false
	offset=2
	folder="class"
	warning="Note: Recompile with -Xlint:unchecked for details."

	classname="${1%.java}" # remove .java extension

	# Check if the file name exists
	# if it does, save it in a .tmp_data file
	# if it doesn't, then load the name form the previous .tmp_data file
	if [ -e "./${classname}.java" ]; then
		echo "${classname}" > .tmp_data
	else
		if [ ! -z "$1" ]; then
			echo "${YELLOW}The file ${classname}.java doesn't exist${RESET}"
		fi

		if [ ! -e "./.tmp_data" ]; then # no tmp data file
			until [ -f "$classname" ]; do
				read -p "${YELLOW}Please specify a class name to compile:${RESET} " classname
				classname="${classname%.java}" # remove .java extension
				classname+=".java"
			done
			classname="${classname%.java}"
			echo "${classname}" > .tmp_data
		else
			classname=$(<".tmp_data")
			echo "Running previous class ${classname}${RESET}"
		fi

		offset=1
	fi

	#++++++++++++++++++++
	createfolder $folder

	compile_text="$(javac $classname.java -d $folder 2>&1)" # compiles the file named $1.java into the directory class/$1.class

 	if [ -z "$compile_text" ]; then # there is no errors
 		# NO ERRORS
 		echo "${BLUE}0 errors${RESET}"
 	 	echo $RUN
		java -cp $folder $classname "${@:$offset}" # runs class $classname from the 'class' folder
 	else
 		# ERRORS
		if [[ $compile_text == *"$warning"* ]]; then # if the error file contains the string 'warning'
			isWarning=true
			echo -e "${GREEN}\c"
			echo "Warnings:"
		else
 			echo -e "${BLUE}\c"
		fi

		echo -e "${compile_text}\c"  # output the file otherwise
		echo "${RESET}"
	fi

	# XLINT / GENERICS CAUSE THIS PROBLEM +++++++++++++++
	if $isWarning; then
		# SOME ERRORS
		echo "${GREEN}You forgot to put the generic type of a variable (i.e you put Node next instead of Node<E> next)${RESET}"
 	 	echo "${RUN}"
		java -cp $folder $classname "${@:$offset}" # runs class $1 from the compiled directory
	fi
}

function removefile()
{
	if [ -f $1 ]; then
    rm $1
	fi
}

function createfolder()
{
	if [ ! -d $1 ]; then
  	mkdir -p $1
	fi
}

function install()
{
	file="/usr/local/bin/compile"
	rm $file

	sudo ln -s "$PWD/compile.sh" "/usr/local/bin/compile"
	chmod +x compile.sh # make the bash script into an executable
}

################
#  MAIN SCOPE  #
################

case $1 in

  # INSTALL ~~~~~~~~~~~~~~~~~~~~~
	"--install")
		install
		echo "Compile command successfully installed"
		createfolder "$HOME/.config/compiler"

		# Save Default configurations into a config file
		default='JAVA="${RED}[Java]${RESET}"\n'
		default+='START="${RED}-----COMPILING-----${RESET}"\n'
		default+='RUN="${RED}------RUNNING------${RESET}"\n'
		default+='END="${RED}-------ENDED-------${RESET}"'
		echo "$default" > "$HOME/.config/compiler/config"
		;;

	# CLEAR ~~~~~~~~~~~~~~~~~~~~~~~
  "--clear")
		[ -f "class" ] && rm -r "class"
		[ -e ".tmp_data" ] && rm ".tmp_data"
		echo "Folder 'class' and the file .tmp_data have been removed"
		;;

	# OTHERWISE ~~~~~~~~~~~~~~~~~~
	*)
		clear

		# removes the class folder and runs the code
		if [[ $2 == "--reset" ]]; then
			[ -f "class" ] && rm -r "class"
			[ -e ".tmp_data" ] && rm ".tmp_data"
		fi

		echo $JAVA
		echo "$START"
		# send all the arguments to the run function. Quotes are needed so
		# that parameters like these "hello world" are interpreted as one word.
		run "${@}"
		echo $END
		;;
esac
