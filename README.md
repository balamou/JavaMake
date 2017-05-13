# Description:
  This bash script allows you to both compile and run using only one command.
  The errors are displayed in a different color.

## How to use Compile:

  - Open the terminal and type:

        $ curl https://raw.githubusercontent.com/balamou/compiler/master/compile.sh | bash -s -- --install

  - Switch to your directory using 'cd' and type this to compile and run the Java
    program (**.java extension is optional**):

        $ compile <YourJavaClass>

  - You can also compile it with parameters:

        $ compile <YourJavaClass> Param1 Param2 Param3

  - Once you typed your class name once, the script will remember it:

        $ compile Param1 Param2 Param3

    will run your last compiled class with those arguments.

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

## Commands

| Command | Function |
|---------|----------|
| --install | installs a global compile command |
| --clear | removes the 'class' folder |
| --reset | removed the 'class' folder and recompiles the java file |

## TODO

- [X] Add a --clear command to clear all the files generates by the bash script
- [X] Remove the need for generating an error.txt file
- [X] Allow users to install the bash file from command line
- [ ] Make a configuration file that stores all the info like the name of the folder
  with the .class files. Also one that changed the color of the errors and
  the color of the diplay tags (----RUN----)
- [ ] Add a --help command
- [X] Allow the bash to save the name of the last compiled class
