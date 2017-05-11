# Description:
  This bash script allows you to both compile and run using only one command.
  The errors are displayed in a different color.

How to use Compile:

  - Download the bash file, open the terminal and type:

  ```
      $ sh compile.sh --install
  ```

  - Switch to your directory using 'cd' and type this to compile and run the Java
    program:

        $ compile <YourJavaClass>
        $ compile <YourJavaClass> Param1 Param2 Param3

        * The .java extension is optional

  - If you type this:

          $ compile Test

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
