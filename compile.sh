#!/bin/bash
# compiles and runs the Java code
# @author Michel Balamou (michelbalamou@gmail.com)
# export PS1="\\[\e[91m\]\W \$ \\[\e[0m\]"; clear;

# Formating tags
RESET="$(tput sgr0)"
BLUE="$(tput setaf 32)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 35)"
YELLOW="$(tput setaf 5)"

# Output variables
JAVA="${RED}[Java]${RESET}"
START="${RED}-----COMPILING-----${RESET}"
RUN="${RED}------RUNNING------${RESET}"
END="${RED}-------ENDED-------${RESET}"

function run()
{
	classname=$1
	isWarning=false
	offset=2

	# Removes the .java extension from the first argument
	if [[ $1 == *".java"* ]]; then # if the first parameter has java in it
		len=$((${#1} - 5)) # length without the .java extension
		classname=${1:0:$len} # substring without the .java extension
	fi

	# Check if the file name exists
	# if it does, save it in a .tmp_data file
	# if it doesn't, then load the name form the previous .tmp_data file
	if [ -e "./${classname}.java" ]; then
		echo "${classname}" > .tmp_data
	else
		echo -e "${YELLOW}\c"
		if [ ! -z $1 ]; then
			echo "The file ${classname}.java doesn't exist"
		fi

		offset=1

		classname=$(<".tmp_data")
		echo "Running previous class ${classname}${RESET}"
	fi

	#++++++++++++++++++++
	folder="class"
	warning="Note: Recompile with -Xlint:unchecked for details."

	createfolder $folder

	compile_text="$(javac $classname.java -d $folder 2>&1)" # compiles the file named $1.java into the directory class/$1.class
	length=${#compile_text}

 	if [ "$length" -eq "0" ]; then # there is no errors
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

	sudo ln -s $PWD/compile.sh /usr/local/bin/compile
	chmod +x compile.sh # make the bash script into an executable
}

#################
#  MAIN SCOPE  #
################

clear
case $1 in

  # INSTALL ~~~~~~~~~~~~~~~~~~~~~
	"--install")
		install
		echo "Compile command successfully installed"
		;;

	# CLEAR ~~~~~~~~~~~~~~~~~~~~~~~
  "--clear")
		rm -r "class"
		;;

	# OTHERWISE ~~~~~~~~~~~~~~~~~~
	*)
		# removes the class folder and runs the code
		if [[ $2 == "--reset" ]]; then
			rm -r "class"
			rm -r ".tmp_data"
		fi

		echo $JAVA
		echo "$START"
		# send all the arguments to the run function. Quotes are needed so
		# that parameters like these "hello world" are interpreted as one word.
		run "${@}"
		echo $END
		;;
esac
