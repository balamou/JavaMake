Description:
  This bash script allow you to both compile and run using only one command.
  The errors are displayed in a different colour.

How to use Compile:

  - Copy the compile.sh file into your java directory
  - To compile and run your java code type this in the terminal:

        $ sh compile.sh <YourJavaClass>

    The .java extension is optional

  - If you type this:

          $ sh compile.sh Test

        this will be the output:

          [Java]
          -----COMPILING-----
          0 errors
          -----RUNNING-----
          This is a test
          -----ENDED-----

          * Running this will generate .class files in the 'class' folder.
          * The script will generate an error.txt file and automatically delete
          it after its use.
