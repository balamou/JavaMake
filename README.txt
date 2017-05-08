Description:
  This bash script allow you to both compile and run using only one command.
  The errors are displayed in a different colour.

How to use Compile:

  - Copy the compile.sh file into your java directory
  - To compile and run your java code type this in the terminal:

        $ sh compile.sh <YourJavaClass>

    Make sure you put the name of your class without the .java extension.

  - If you type this:

          $ sh compile.sh Test

        this will be the output:

          [Java]
          -----COMPILING-----
          0 errors
          -----RUNNING-----
          This is a test
          -----ENDED-----

          * Running this will generate .class files in the compiled folder.
          * The script will generate an error.txt file with all the errors and a
          log.txt file with the output of the java program (you can delete those
          files and the script will still be able to run)
