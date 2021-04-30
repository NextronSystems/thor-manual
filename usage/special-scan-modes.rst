Special Scan Modes
==================

Lab Scanning (--lab)
--------------------

Lab scanning mode that is activated with **--lab** (formerly
**--fsonly**). It is used to scan mounted forensic images or a single
directory on a forensic workstation. All resource control functions are
disabled and intense mode is activated by default.

The **--lab** parameter automatically activates the following other
options:

* intense (scan every file intensively regardless of its extension or magic header)
* norescontrol (do not limit system resources or interrupt scan on low memory)
* nosoft (do not automatically activate soft mode on systems with single core CPUs or low memory)
* nodoublecheck (do not check for other THOR instances on the same system and do not interrupt scan if another instance has been found)
* multi-threading (it automatically sets the number of threads to use to the number of CPU cores found on the workstation)

IMPORTANT: Lab scanning mode requires a `forensic lab license <https://www.nextron-systems.com/thor/license-packs/>`__ type which is meant to be used in forensic labs. You can achieve a similar (but not equal) scan using **-a Filescan --intense -p path-to-scan**

Virtual Drive Mapping
^^^^^^^^^^^^^^^^^^^^^

Since THOR enriches messages with more details, it could be problematic
to scan a mounted drive “s:”, which has originally been a partition “c:”
on the source system of the image.

E.g. The analyst has mounted a partition “C:” from a source system to
drive “F:” on the forensic lab workstation. A SHIMCache entry points to
“C:\\temp\\mk.exe”. THOR would look at location “C:\\temp\\mk.exe” for
that file and couldn’t find anything, since that file doesn’t exist on
the forensic lab workstation.

Virtual drive mapping allows you to virtually map that drive to its
original name. The syntax is as follows:

.. code:: bash

  --virtual-map current-location:original-location

Some examples:

A original partition “C:” from the source system has been mounted to
drive “F:” on the forensic lab workstation:

.. code:: bash

  --virtual-map F:C

A original mount point “/” has been mounted to “/mnt/image1” on a Linux
forensic lab workstation:

.. code:: bash

  --virtual-map /mnt/image1:/

A Windows image of drive “C:” mounted to “/mnt/image1” on a Linux
forensic lab workstation:

.. code:: bash

  --virtual-map /mnt/image1:C

IMPORTANT: This feature requires a `forensic lab license <https://www.nextron-systems.com/thor/license-packs/>`__ type which is meant to be used in forensic labs. 

Hostname Replacement in Logs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The parameter **-j** can be used to set the hostname used in the log
files to a given identifier instead of using the current workstation's
name in all output files. If you don’t use this flag, all log files
generated on that forensic lab workstation would contain the name of the
forensic lab workstation as the source.

You should use the name of the host from which the image has been
retrieved as the value for that parameter.

.. code:: bash

  -j orig-hostname

Examples
^^^^^^^^

A full command line of a THOR scan started in a lab environment would
look like this:

.. code:: batch

  thor64.exe --lab -p S:\\ --virtual-map S:C –j WKS001 -e C:\\reports

It instructs THOR to scan the mounted partition S: in lab scanning mode,
maps the current partition “S:” to a virtual drive “C:”, replaces the
hostname with “WKS001” in the outputs and saves every output file (text
log, HTML, CSV) to a reports folder named “C:\\reports”.

IMPORTANT: This feature requires a `forensic lab license <https://www.nextron-systems.com/thor/license-packs/>`__ type which is meant to be used in forensic labs. 

Lookback Mode (--lookback --all-module-lookback)
------------------------------------------------

The **--lookback** option allows you to restrict the Eventlog and log
file scan to a given amount of days. E.g. by using **--lookback 3** you
instruct THOR to check only the log entries that have been created in
the last 3 days.

In THOR v10.5 we've extended this feature to include all applicable
modules, including "FileScan", "Registry", "Services", "Registry Hives"
and "EVTX Scan".

By setting the flags **--all-module-lookback --lookback 2** you instruct
THOR to scan only elements that have been created or modified during the
last 2 days. This reduces the scan duration significantly.

This scan mode is perfect for quick scans to verify SIEM related events
and is used by default in THOR Cloud’s settings for executions via
Microsoft Defender ATP.

Drop Zone Mode (--dropzone)
---------------------------

The drop zone mode allows you to define a folder on your local hard
drive that is monitored for changes. If a new file is created in that
folder, THOR scans this file and writes a log message if suspicious
indicators have been found. The optional parameter **--dropdelete** can
be used to remove the dropped file once it has been scanned. Example:

.. code:: batch

  thor.exe --dropzone –p C:\\dropzone

IMPORTANT: This feature requires a `forensic lab license <https://www.nextron-systems.com/thor/license-packs/>`__ type which is meant to be used in forensic labs. 

Image File Scan Mode (-m)
-------------------------

The image file scan mode has a misleading name. It isn't meant to be
used for forensic image scanning but for the scan of un-mountable images
or memory dumps only. If you have a forensic image of a remote system,
it is always recommended to mount the image as a Windows drive and scan
it using the Lab Scanning (--lab) mode.

The Image File Scan mode performs a deep dive on a given data file.
Therefore, the file type, structure or size of that file is not
relevant. The DeepDive module processes the file in overlapping 3
Megabyte chunks and checks these chunks using the given YARA rule base
only (including custom YARA signatures).

The only suitable use case is the scan of a memory dump using your own
YARA signatures placed in the "./custom-signatures/yara" sub folder.

.. code:: batch

  thor.exe –m systemX123.mem –j systemX123 –e C:\\reports

IMPORTANT: This feature requires a `forensic lab license <https://www.nextron-systems.com/thor/license-packs/>`__ type which is meant to be used in forensic labs. 

DeepDive (--deepdive)
---------------------

The DeepDive module allows a surface scan of a given drive.

This check processes every byte of the whole hard drive including the
free space. This enables THOR to detect deleted files that have not been
wiped by the attackers.

DeepDive is not recommended for triage sweeps in a whole network as it
generates more false positives than a normal file system scan. This is
mainly caused by the fact that chunks of data read from the disk are
processed regardless of their corresponding file’s type, name or
extension. It processes Antivirus signatures, pagefile contents and
other data that may trigger an alert.

In the current stage of development, the DeepDive check parses out every
executable file and applies all included Yara signatures. A positive
match is reported according to the score as "Notice", "Warning" or
"Alert".

There are some disadvantages linked with the DeepDive detection engine:

* The file name cannot be extracted from the raw executable code
* The file path of the reported sample is unknown

THOR uses other attributes to report these findings:

* | Offsets
  | THOR reports the location on the disk, so that forensic
     investigators are able to check and extract the file from an image
     of the hard drive.

* | Restore
  | THOR is able to restore the whole file to a given directory. It
     uses the system’s NetBIOS name, rule name, the score and the offset
     to create a file name for the extracted file.

As a side effect of this dissection all the embedded executables in
other file formats like RTF or PDF are detected regardless of their way
of concealment.

To perform a surface scan, use the "**- a deepdive**" option. To restore
all detected files to a restore directory additionally use the "**-r
directory**" option.

+----------------+---------------------------------------------------------------------------------------------------------+
| Option         | Description                                                                                             |
+================+=========================================================================================================+
| -a deepdive    | | Activate DeepDive for the File System Scan. Only applicable if scan target is a drive		   |
|                | | – default or with selected drive root, i.e. "-p D:\\"   					   	   |
+----------------+---------------------------------------------------------------------------------------------------------+
| -r directory   | Recovery directory for files found by DeepDive                                                          |
+----------------+---------------------------------------------------------------------------------------------------------+

While the DeepDive detects suspicious files regardless of their master
file table reference the default file system scan that is executed
afterwards may detect the same file twice.

The following example for the use of the DeepDive shows how to scan a
mounted file system image as drive "X:".

.. code:: bash

  thor --lab --deepdive -rd D:\\restore -p X:\\

Eventlog Analysis (-n)
----------------------

The Eventlog scan mode allows scanning certain Windows Eventlogs.

The parameter **-n** works like the **-p** parameter in the Filesystem
module. It takes the target Eventlog as parameter, which is the Windows
Eventlog’s full name.

.. code:: batch

  thor.exe -a Eventlog –n "Microsoft-Windows-Sysmon/Operational"

You can get the full name of a Windows Eventlog by right clicking the
Eventlog in Windows Event Viewer and selecting "Properties".

.. figure:: ../images/image19.png
   :target: ../_images/image19.png
   :alt: Windows Eventlog Properties

   Windows Eventlog Properties

The -n parameter can also be used to restrict the Eventlog scanning to
certain Eventlogs. The following command will start a default THOR scan
and instructs the Eventlog module to scan only the “Security” and
“System” Eventlog.

.. code:: batch

 thor.exe -n Security -n System

MFT Analysis (--mft)
--------------------

The MFT analysis module reads the "Master File Table" (MFT) of a
partition and parses its contents. The MFT analysis takes a significant
amount of time and is only active in “intense” scan mode by default.

You can activate MFT analysis in any mode by using **--mft**.

The way THOR handles the MFT Analysis can be influenced by the following
parameters:

+-------------------+------------------------------------------------------------------------------------------+
| Option            | Description                                                                              |
+===================+==========================================================================================+
| --mft             | Activate MFT analysis                                                                    |
+-------------------+------------------------------------------------------------------------------------------+
| --nomft           | | Do not perform any MFT analysis whatsoever (only useful in combination with   	       |
|		    | | --intense) 									       |
+-------------------+------------------------------------------------------------------------------------------+
| --maxmftsize MB   | The maximum MFT size in Megabytes to process (default: 200 MB)                           |
+-------------------+------------------------------------------------------------------------------------------+

