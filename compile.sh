#!/bin/bash
# compiles and runs the Java code
# @author Michel Balamou (michelbalamou@gmail.com)
# export PS1="\\[\e[91m\]\W \$ \\[\e[0m\]"; clear;

# Formating tags
RESET="$(tput sgr0)"
BLUE="$(tput setaf 32)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 178)"
GREY="$(tput setaf 234)"
CYANE="$(tput setaf 26)"
BRED="$(tput setaf 160)"

# Output variables
source "$HOME/compiler/config"

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
			echo "${GREY}The file ${RESET}${BRED}${classname}.java${RESET}${GREY} doesn't exist${RESET}"
		fi

		if [ ! -e "./.tmp_data" ]; then # no tmp data file
			until [ -f "$classname" ]; do
				read -p "${GREY}Please specify a class name to compile:${RESET} " classname
				classname="${classname%.java}" # remove .java extension
				classname+=".java"
			done
			classname="${classname%.java}"
			echo "${classname}" > .tmp_data
			echo ""
		else
			classname=$(<".tmp_data")
			echo "${GREY}Running previous class${RESET} ${CYANE}${classname}${RESET}"
			echo ""
		fi

		offset=1
	fi

	#++++++++++++++++++++
	createfolder $folder

	echo "$JAVA"
	echo "$COMPILING"
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

################
#  MAIN SCOPE  #
################

case $1 in

	"--uninstall")
		rm "/usr/local/bin/compile"
 		rm -r "$HOME/compiler/"
	;;

	# CLEAR ~~~~~~~~~~~~~~~~~~~~~~~
  "--clear")
		rm -r "class" 2> /dev/null
		[ -e ".tmp_data" ] && rm ".tmp_data"
		echo "Folder 'class' and the file .tmp_data have been removed"
		;;

	# OTHERWISE ~~~~~~~~~~~~~~~~~~
	*)
		# send all the arguments to the run function. Quotes are needed so
		# that parameters like these "hello world" are interpreted as one word.
		clear
		run "${@}"
		echo $END
		;;
esac
