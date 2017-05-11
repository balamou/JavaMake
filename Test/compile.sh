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
	isWarning=false

	if [[ $1 == *".java"* ]] # if the first parameter has java in it
	then
		len=$((${#1} - 5)) # length without the .java extension
		classname=${1:0:$len} # substring without the .java extension
	fi

	#++++++++++++++++++++
	folder="class"
	warning="Note: Recompile with -Xlint:unchecked for details."

	createfolder $folder

	compile_text="$(javac $classname.java -d $folder 2>&1)" # compiles the file named $1.java into the directory class/$1.class
	length=${#compile_text}

 	if [ "$length" -eq "0" ] # there is no errors
 	then
 		# NO ERRORS
 		echo "${BLUE}0 errors${RESET}"
 	 	echo $RUN
		java -cp $folder $classname "${@:2}" # runs class $classname from the 'class' folder
 	else
 		# ERRORS
		if [[ $compile_text == *"$warning"* ]] # if the error file contains the string 'warning'
		then
			isWarning=true
			echo "${GREEN}\c"
			echo "Warnings:"
		else
 			echo "${BLUE}\c"
		fi

		echo "$compile_text"  # output the file otherwise
		echo "${RESET}"
	fi

	# XLINT / GENERICS CAUSE THIS PROBLEM +++++++++++++++
	if $isWarning
	then
		# SOME ERRORS
		echo "You forgot to put the generic type of a variable\n(i.e you put Node next instead of Node<E> next)"
 	 	echo "${RUN}"
		java -cp $folder $classname "${@:2}" # runs class $1 from the compiled directory
	fi
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
