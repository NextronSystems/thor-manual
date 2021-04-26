.. role:: raw-html-m2r(raw)
   :format: html

Action on Match
===============

The action command allows you define a command that runs whenever THOR
encounters a file during "Filescan" that has a certain total score or
higher. The default score that triggers the action command (if set) is
40.

The most popular use case for the action command is sample collection.

Action Flags
------------

+----------------------------+--------------------------------------------------------------------------+
| Parameter                  | Description 								|
+============================+==========================================================================+
| --action\_command string   | | Run this command for each file that has a score greater than the score |
|			     | | from --action\_level                                                   |
+----------------------------+--------------------------------------------------------------------------+
| ---action\_args strings    | | Arguments to pass to the command specified via --action\_command. The 	|
|			     | | placeholders %filename%, %filepath%, %file%, %ext%, %md5%, %score%     |
|			     | | and %date% are replaced at execution time   				|
+----------------------------+--------------------------------------------------------------------------+
| --action\_level int        | | Only run the command from --action\_command for files with at least 	|
|			     | | this score (default 40)                           			|
+----------------------------+--------------------------------------------------------------------------+


Command Line Use
----------------

A typical use would be e.g. to copy a sample to a network share:

.. code:: bash
   
   copy %filepath% \\\\server\\share1

To instruct THOR to run this command, you need

.. code:: batch
   
   thor64.exe --action\_command copy --action\_args %filepath% --action\_args \\\\server\\share1

Use in a Config File
--------------------

The **./config** folder contains a template for a config file that uses
the action commands.

Content of 'tmpl-action.yml':

+--------------------------------------------------------------------------------------------------------+
| | # Action to perform if file has been detected with a score more than the defined 'action\_level'     |
| | # You may use all environment variables that are available on the system, i.e. %COMPUTERNAME%.       |
| | # Further available meta vars are:                                                                   |
| | # %score% = Score                                                                                    |
| | # %file% = Filename without extension                                                                |
| | # %filename% = Basename                                                                              |
| | # %filepath% = Full path                                                                             |
| | # %ext% = Extension without dot                                                                      |
| | # %md5% = MD5 value                                                                                  |
| | # %date% = Detection time stamp                                                                      |
| |                                                                                                      |
| | action\_level: 35                                                                                    |
| | action\_command: "copy"                                                                              |
| | action\_args:                                                                                        |
| | - "%filepath%"                                                                                       |
| | - "\\\\\\\\VBOXSVR\\\\Downloads\\\\restore\_files\\\\%COMPUTERNAME%\_%md5%\_%file%\_%ext%\_%date%"   |
+--------------------------------------------------------------------------------------------------------+

