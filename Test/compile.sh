#!/bin/bash
# compiles and runs the Java code
# @author Michel Balamou (michelbalamou@gmail.com)
# export PS1="\\[\e[91m\]\W \$ \\[\e[0m\]"; clear;

# Formating tags
BLUE="$(tput setaf 32)"
RED="$(tput setaf 1)"
RESET="$(tput sgr0)"
GREEN="$(tput setaf 35)"

# Output variables
JAVA="${RED}[Java]${RESET}"
START="${RED}-----COMPILING-----${RESET}"
RUN="${RED}------RUNNING------${RESET}"
END="${RED}-------ENDED-------${RESET}"

function run
{
	# Removes the .java extension from the first argument
	classname=$1

	if [[ $1 == *".java"* ]] # if the first parameter has java in it
	then
		len=$((${#1} - 5)) # length without the .java extension
		classname=${1:0:$len} # substring without the .java extension
	fi

	#++++++++++++++++++++
	folder="class"
	warning="Note: Recompile with -Xlint:unchecked for details."

	createfolder $folder

	javac $classname.java -d $folder 2> error.txt # compiled the file named $1.java into the directory compiled/$1.class
 	size=$(wc -c <"error.txt") # size of the error file
	value=$(<"error.txt") # load the error into the value variable

 	if [ $size -eq 0 ] # if the file is empty
 	then
 		# NO ERRORS
 		echo "${BLUE}0 errors${RESET}"
 	 	echo $RUN
		java -cp $folder $classname "${@:2}" # runs class $classname from the compiled directory, and saved output into log.txt at the same time
 	else
 		# ERRORS
		if [[ $value == *"$warning"* ]] # if the error file contains the string 'warning'
		then
			echo "${GREEN}"
			echo "Warnings:"
		else
 			echo "${BLUE}"
		fi

		echo "$value"  # output the file otherwise
		echo "${RESET}"
	fi

	# XLINT / GENERICS CAUSE THIS PROBLEM +++++++++++++++
	if [[ $value == *"$warning"* ]]
	then
		# SOME ERRORS
		echo "You forgot to put the generic type of a variable (i.e you put Stack T instead of Stack<String> T)"
 	 	echo "${RUN}"
		java -cp $folder $classname "${@:2}" # runs class $1 from the compiled directory, and saved output into log.txt at the same time
	fi

	removefile "error.txt"
}

function removefile
{
	if [ -f $1 ] ; then
    rm $1
	fi
}

function createfolder
{
	if [ ! -d $1 ]; then
  	mkdir -p $1
	fi
}

function install
{
	file="/usr/local/bin/compile"
	rm $file

	sudo ln -s $PWD/compile.sh /usr/local/bin/compile
	chmod +x compile.sh
}

#################
#  MAIN SCOPE  #
################

clear
if [[ $1 == "--install" ]]
then
	install
	echo "Compile command successfully installed"
elif [[ $1 == "--clear" ]]
then
	rm -r "class"
else
	# removed the class folder and runs the code
	if [[ $2 == "--reset" ]]
	then
		rm -r "class"
	fi

	echo $JAVA
	echo $START
	#send all the arguments to the run function. Quotes are needed so
	# that parameters like these "hello world" are interpreted as one word.
	run "${@}"
	echo $END
fi