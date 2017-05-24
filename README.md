# Description:
  This bash script allows you to both compile and run using only one command.
  The errors are displayed in a different colour.

## How to use Compile:

  - Open the terminal and type:

        $ curl https://raw.githubusercontent.com/balamou/compiler/master/installer.sh | bash

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
| --clear | removes the 'class' folder |
| --reset | removed the 'class' folder and recompiles the java file |

## TODO

- [ ] Make a configuration file that stores all the info like the name of the folder
  with the .class files. Also one that changed the colour of the errors and
  the colour of the display tags (----RUN----)
- [ ] Add a --help command
