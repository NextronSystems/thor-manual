
THOR DB
=======

This simple SQLite database is created by default in the
"**%ProgramData%\\thor**" directory as "**thor.db**". You can deactivate
THOR DB and all its features by using the "**--nothordb**" option.

It stores persistent information over several scan runs:

* | Scan State Information
  | This information is used to resume scan runs where they were stopped
* | Delta Comparison
  | This detection feature allows to compare the result of a former module check with the current results and indicate suspicious changes between scan runs

The THOR DB related command line options are:

+-----------------------+-------------------------------------------------------------------------------+
| Parameter		| Description									|
+=======================+===============================================================================+
| --nothordb		| Disables THOR DB completely. All related features will be disabled as well.	|
+-----------------------+-------------------------------------------------------------------------------+
| --dbfile [string] 	| | Allows to define a location of the THOR database file. File names or path 	|
|			| | names are allowed. If a path is given, the database file ‘thor.db’ will be 	|
|			| | created in the directory. Environment variables are expanded.		|
+-----------------------+-------------------------------------------------------------------------------+
| --resume 		| | Resumes a previous scan (if scan state information is still available and 	|
|			| | the exact same command line arguments are used)				|
+-----------------------+-------------------------------------------------------------------------------+
| --resumeonly		| | Only resume a scan if a scan state is available. Do not run a full scan if	|
|			| | no scan state can be found.							|
+-----------------------+-------------------------------------------------------------------------------+


Scan Resume
-----------

THOR tries to resume a scan when you set the **--resume** parameter.
Since THOR version 10.5 the resume state doesn’t get tracked by default
due to its significant performance implications. If you want to be able
to resume a scan, you have to start scans with the **--resume** flag. If
you start a scan and a previous resume state is present, then THOR is
going to resume the interrupted scan.

It will only resume the previous scan if

1. you have started the scan with **--resume**

2. the argument list is exactly the same as in the first scan attempt

3. you haven’t used the flag **--nothordb**

4. | scan state information is still available
   | (could have been cleared by running THOR a second time without the
     **--resume** parameter)

You can always clear the resume state and discard an old state by
running thor.exe once without using the **--resume** parameter.

Delta Comparison
----------------

The delta comparison feature allows comparing former scan results on a
system with the current results, indicating changes in system
configurations and system components.

Currently, the following scan modules feature the delta comparison
check:

* | Autoruns
  | THOR compares the output of the Autoruns module with the output of the last scan run. The Autoruns does not only check "Autorun" locations but also elements like browser plugins, drivers, LSA providers, WMI objects and scheduled tasks.
* | Services
  | The comparison detects new service entries and reports them.
* | Hosts
  | New or changed entries in the "hosts" file could indicate system manipulations by attackers to block certain security functions or intercept connections.
