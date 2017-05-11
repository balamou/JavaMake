# Description:
  This bash script allows you to both compile and run using only one command.
  The errors are displayed in a different color.

## How to use Compile:

  - Download the bash file, open the terminal and type:

      $ sh compile.sh --install

  - Switch to your directory using 'cd' and type this to compile and run the Java
    program (**.java extension is optional**):

        $ compile <YourJavaClass>

  - You can also compile it with parameters:

        $ compile <YourJavaClass> Param1 Param2 Param3

  - If you type this:

        $ compile Test

    The output will be:

        [Java]
        -----COMPILING-----
        0 errors
        ------RUNNING------
        This is a test
        -------ENDED-------

        * Running this will generate .class files in the 'class' folder.
        * The script will generate an error.txt file and automatically delete
          it after its use.

## TODO

- [X] Add a --clear command to clear all the files generates by the bash script
- [ ] Remove the need for generating an error.txt file
- [ ] Allow users to install the bash file from command line
- [ ] Make a configuration file that stores all the info like the name of the folder
  with the .class files. Also one that changed the color of the errors and
  the color of the diplay tags (----RUN----)
- [ ] Add a --help command
