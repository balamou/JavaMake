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

function simple_run
{
	javac $1.java -d compiled
	java -cp compiled $1
}

function run
{
	if [ ! -d compiled ]; then
  	mkdir -p compiled;
	fi

	javac $1.java -d compiled 2> error.txt # compiled the file named $1.java into the directory compiled/$1.class
 	size=$(wc -c <"error.txt") # size of the error file
	value=$(<"error.txt")
	str="Note: Recompile with -Xlint:unchecked for details."

 	if [ $size -eq 0 ] # if the file is empty
 	then
 		# NO ERRORS
 		echo "${BLUE}0 errors${RESET}"
 	 	echo $RUN
		java -cp compiled $1 | tee log.txt # runs class $1 from the compiled directory, and saved output into log.txt at the same time
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
 	 	echo $RUN
		java -cp compiled $1 | tee log.txt # runs class $1 from the compiled directory, and saved output into log.txt at the same time
	fi
}

clear
echo $JAVA
echo $START
run $1
echo $END
