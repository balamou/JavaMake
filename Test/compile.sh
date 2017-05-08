#!/bin/bash
# compiles and runs the Java code
# @author Michel Balamou (michelbalamou@gmail.com)

BLUE="$(tput setaf 32)"
RED="$(tput setaf 1)"
RESET="$(tput sgr0)"


JAVA="${RED}[Java]${RESET}"
START="${RED}-----COMPILING-----${RESET}"
RUN="${RED}-----RUNNING-----${RESET}"
END="${RED}-----ENDED-----${RESET}"

function run
{
	folder="class"
	createfolder $folder

	javac $1.java -d $folder 2> error.txt # compiled the file named $1.java into the directory compiled/$1.class
 	size=$(wc -c <"error.txt") # size of the error file
	value=$(<"error.txt")
	str="Note: Recompile with -Xlint:unchecked for details."

 	if [ $size -eq 0 ] # if the file is empty
 	then
 		# NO ERRORS
 		echo "${BLUE}0 errors${RESET}"
 	 	echo $RUN
		java -cp $folder $1 # runs class $1 from the compiled directory, and saved output into log.txt at the same time
 	else
 		# ERRORS
		if [[ $value == *"$str"* ]] # if the error file contains the string str
		then
			GREEN="$(tput setaf 35)"
			echo "$GREEN\c"
			echo Warnings:
			cat error.txt  # output the file +warnings
	 		echo "$RESET\c"
		else
 			echo "$BLUE\c"
			cat error.txt  # output the file otherwise
 			echo "$RESET\c"
		fi
	fi

	# XLINT / GENERICS CAUSE THIS PROBLEM +++++++++++++++
	if [[ $value == *"$str"* ]]
	then
		# SOME ERRORS
		echo "You forgot to put the generic type of a variable (i.e Stack<String> T, instead of Stack T)"
 	 	echo $RUN
		java -cp $folder $1 # runs class $1 from the compiled directory, and saved output into log.txt at the same time
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

clear
echo $JAVA
echo $START
run $1
echo $END
