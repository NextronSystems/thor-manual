
Scan
====

First of all, THOR runs fine with the default settings. The recommended scan options are already active in the default scan. 

Parameters Possibly Relevant for Your User Case
-----------------------------------------------

- **-c percentage** : Reduce the average CPU load to the given percentage value (note: THOR already sets the process priority to the lowest possible value). This can be helpful to reduce the load e.g. on server systems with real-time services or reduce the noise produced by fans on user laptops. 
- **--allhds** : By default THOR scans only the C: partition on Windows machines and other files/folders only in cases in which some reference points to a different partition (e.g. configured web root of IIS is on D:\inetpub, registered service runs from D:\vendor\service)

Often Used Parameters
---------------------

* **--soft** : Reduce CPU usage, skip all checks that can consume a lot of memory (even if only for a few seconds)
* **--quick** : Perform a :ref:`quick scan<Scan Modes>` (skips Eventlog and checks only the most relevant folders)
* **-e target-folder** : Write all output files to the given folder

Parameters Better Avoided 
-------------------------

* **--intense** : high runtime, stability issues due to disabled resource control
* **--c2-in-memory** : many false positives on user workstations (especially browser memory)
* **--alldrives** : high runtime, stability issues due to scan on network drrives or other remote filesystems 
* **--mft** : stability issues due to high memory usage 

Help and Debugging
------------------

.. list-table:: 
   :header-rows: 1

   * - Parameter
     - Values
     - Function
   * - --debug
     - 
     - Get debug information if errors occur
   * - --help
     -
     - Get a help with the most important scan options
   * - --fullhelp
     -
     - Get a help with all scan options

Examples
--------

Logging to a Network Share
^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command creates a plaintext log file on a share called
"rep" on system "sys" if the user running the command has the respective
access rights on the share.

.. code:: batch

   thor64.exe --nohtml --nocsv -l \\\\sys\\rep\\%COMPUTERNAME%\_thor.txt

Logging to Syslog Server
^^^^^^^^^^^^^^^^^^^^^^^^

The following command instructs THOR to log to a remote syslog server
only.

.. code:: batch

   thor64.exe --nohtml --nocsv --nolog -s syslog.server.net

Scan Run on a Single Directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: batch

   thor64.exe --lab -p C:\\ProgramData
   thor64.exe --lab -p I:\\mounted\_image\\disk1

IMPORTANT: This feature requires a `forensic lab license <https://www.nextron-systems.com/thor/license-packs/>`__ type which is meant to be used in forensic labs. 

Deactivate all file output - Syslog only
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: batch

   thor64.exe -s 10.1.5.14 --nohtml --nolog --nocsv

Save the result files to a different directory 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: batch

   thor64.exe -s 10.1.5.14 -e Z:\\

Only scan the last 7 days of the Windows Eventlog and log files on disk 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: batch

   thor64.exe --lookback 7

Scan System with Defaults and Make a Surface Scan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, the surface scan (DeepDive) applies all YARA rules in
"./custom-signatures" folder. In this example all output files are
written to a network share.

.. code:: batch

   thor64.exe --deepdivecustom -e \\server\share\thor_output\

Intense Scan and DeepDive on a Mounted Image as Drive Z
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: batch

   thor64.exe --lab --deepdive -p Z:\\

IMPORTANT: Lab scanning mode requires a `forensic lab license <https://www.nextron-systems.com/thor/license-packs/>`__ type which is meant to be used in forensic labs. 

You can achieve a similar (but not equal) scan using:

.. code:: batch 

   thor64.exe -a Filescan --intense -p C:\path-to-scan

Throttled THOR Run (static throttling value)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Will restrict THOR’s CPU usage in the long running modules “FileScan”,
“Eventlog”, “LogScan” and “Registry” to 60%. Note that THOR
automatically applies certain restrictions in automatic soft mode.

.. code:: batch

   thor64.exe -c 60

Scan Multiple Paths
^^^^^^^^^^^^^^^^^^^

.. code:: batch

   thor64.exe --lab -p C:\\ D:\\webapps E:\\inetpub

(non-existent directories will be automatically skipped)

Scan All Hard Drives (Windows Only)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: batch

   thor64.exe --allhds

Don't Scan Recursively 
^^^^^^^^^^^^^^^^^^^^^^

To instruct THOR to scan a folder non-recursively use the **:NOWALK** suffix. 

.. code:: batch

  thor64.exe -a FileScan -p C:\Windows\System32:NOWALK

Scan Output
-----------

THOR creates several files during and at the end of the scan.

**Real Time** - the text log file is written during the scan process.
Also the SYSLOG output is sent in real-time to one or more remote
systems.

**End of Scan** - the full HTML report and CSV file with all file scan
elements reported as suspicious are written at the end of the scan.

You can define different formatting options for each the FILE and the
SYSLOG output.

Placeholders
^^^^^^^^^^^^

Two placeholders can be used in command line parameters to facilitate
the use of parameter on different operating systems.

* \:hostname\:
* \:time\:

These can be used in command line parameters and scan templates across
all platforms.

.. code:: batch

   thor64.exe --lab -p S:\\ -o :hostname:\_:time:.csv

Log File Output (.txt)
^^^^^^^^^^^^^^^^^^^^^^

The standard log file is written by default.

* | **--nolog**
  | Don’t create a log file
* | **-l / --logfile** **filename**
  | Set a filename for the log file

The log file’s format aligns with the format of SYSLOG messages. This
way it can easily be imported to most SIEM or log analysis systems.

CSV Output (.csv)
^^^^^^^^^^^^^^^^^

The CSV output is an optional legacy output file without much details.
It contains only “Filescan” module findings and consist of 3 columns,
file hash, file path and score.

CSV File Output:

+-----------------------------------------------------------------------+
| ﻿c926bf384319e40506e3d6e409dc856e,C:\\PowerZure.ps1,140               |
|                                                                       |
| 62160f1a71507e35ebf104a660d92794,C:\\f.bat,180                        |
|                                                                       |
| c926bf384319e40506e3d6e409dc856e,C:\\ntds.dit,50                      |
|                                                                       |
| c926bf384319e40506e3d6e409dc856e,C:\\temp\\ntds.zip\|ntds.dit,140     |
|                                                                       |
| 36a93511fc0e2e967bc5ced6a5bc36a6,C:\\temp\\ntds.zip,50                |
|                                                                       |
| 44b34aac3135dcb03ababac5f7767a55,C:\\temp\\windows-hardening.bat,60   |
+-----------------------------------------------------------------------+


Be aware that archives with matches show up as
“archive.zip\|file-with-finding.js” (pipe separator) in the second
column.

If you need more columns in that CSV, consider processing the JSON
output instead.

Note: our Github repository contains scripts to convert THOR’s JSON
output into a CSV with any given field values, see:

`https://github.com/NextronSystems/nextron-helper-scripts/tree/master/thor-log-processors <https://github.com/NextronSystems/nextron-helper-scripts/tree/master/thor-log-processors>`__

CSV Stats
^^^^^^^^^

The CSV stats file is an optional output file that contains only the
scan statistics. It contains a single line with:

Hostname, scan start, scan end, THOR version, used command line flags,
number of alerts, number of warnings, number of notices and number of
errors

CSV Stats Output:

+-------------------------------------------------------------------------------------------------------------------------------+
| ﻿HYPERION,2021-02-17 17:01:25,2021-02-17 17:01:28,10.6.2,--lab -p C:\\temp -o HYPERION\_test\_:time:.csv --csvstats,5,2,3,0   |
+-------------------------------------------------------------------------------------------------------------------------------+

JSON Output (.json)
^^^^^^^^^^^^^^^^^^^

The JSON output file can be configured with these options:

* | **--json**
  | Create a JSON output file
* | **--jsonfile** **filename**
  | Set a filename for the JSON log file
* | **--cmdjson**
  | Print JSON format into the command line (e.g. used with Splunk
     scripted input)
* | **-s [syslogtarget]:[port]:** **SYSLOGJSON**
  | Send syslog messages with JSON formatting

Key Value Output
^^^^^^^^^^^^^^^^

THOR provides the option to create a "Key/Value" pair output that
simplifies the SIEM integration.

By using the "**--keyval**" option you get the text and syslog output
transformed as shown in the following example. The command line output
stays untouched by this setting.

There are three different Key Value Pair Formatting flags:

* | **--keyval**
  | Write key/value pairs to the log file
* | **--cmdkeyval**
  | Print key/value pairs in the command line (e.g. used with Splunk
     scripted input)
* | **-s [syslogtarget]:[port]:SYSLOGKV**
  | Send syslog messages with propper key/value formatting

+---------------------------------------------------------------------------------------------------------------+
| Default - Without "--keyval" parameter									|
+===============================================================================================================+
| | Jul 10 09:08:47 PROMETHEUS/10.0.2.15 THOR: Alert: MODULE: SHIMCache MESSAGE: Malware 	                |
| | name found in Shim Cache Entry ENTRY: C:\\Users\\neo\\Desktop\\ncat.exe KEYWORD: \\\\ncat\\.exe           	|
| | DATE: 07/29/13 05:16:04 TYPE: system HIVEFILE: None EXTRAS: N/A N/A True					|
+---------------------------------------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------------------------------------+
| Key/Value Pairs - With "--keyval" parameter									|
+===============================================================================================================+
| | Jul 10 09:07:59 PROMETHEUS/10.0.2.15 THOR : Alert: MODULE="SHIMCache" MESSAGE="Malware  	                |
| | name found in Shim Cache Entry" ENTRY="C:\\Users\\neo\\Desktop\\ncat.exe" KEYWORD="\\\\ncat\\.exe" 	        |
| | DATE="07/29/13 05:16:04" TYPE="system" HIVEFILE="None" EXTRAS="N/A N/A True"				|
+---------------------------------------------------------------------------------------------------------------+


SYSLOG Output
^^^^^^^^^^^^^

One or more SYSLOG targets can be set with the **-s** parameter.

For details on the syslog output see chapter “16 Syslog”.

Timestamps
^^^^^^^^^^

Timestamp in all modules use the ANSIC standard, which looks like:

+----------------------------+
| | Mon Jan 2 15:04:05 2006  |
| | Mon Mar 19 09:04:05 2018 |
+----------------------------+

https://flaviocopes.com/go-date-time-format

UTC
~~~

The **--utc** parameter allows to use UTC in all timestamps.

RFC3339 Time Stamps
~~~~~~~~~~~~~~~~~~~

The parameter **--rfc3339** generates time stamps for UTC time in the
format described in RFC 3339. In contrast to the default time stamps RFC
3339 timestamps include a year and look like this:

+----------------------+
| 2017-02-31T23:59:60Z |
+----------------------+

SCAN ID
^^^^^^^

The former parameter “-i”, which has been used for so-called case IDs
(CID) has been repurposed to allow users to set a certain scan ID
(SCANID) that appears in every log line.

The scan ID helps SIEM and analysis systems to correlate the scan lines
from multiple scans on a single host. Otherwise it would be very
difficult to answer the following questions:

* How many scans completed successfully on a certain end system?
* Which scan on a certain end system terminated during the scan run?

If no parameter is set, THOR will automatically generate a random scan
ID, which starts with an “\ **S-**\ “ and contains the following
characters: **a-zA-Z0-9\_-**

Users can overwrite the scan ID with “-i myscanid” to assign the logs of
multiple scan runs to a single logical scan, e.g. if multiple partitions
of a system get scanned in the lab in different scan runs, but should be
shown as a single scan in Analysis Cockpit or your SIEM of choice.

Examples:

+------------------+
| S-Rooa61RfuuM    |
| S-0vRKu-1\_p7A   |
+------------------+

In a log line, it looks like:

+---------------------------------------------------------------------------------------------------------------+
| | Jul 10 09:08:47 PROMETHEUS/10.0.2.15 THOR: Alert: MODULE: SHIMCache					  	|
| | SCANID: S-r4GhEhEiIRg MESSAGE: Malware name found in Shim Cache Entry ENTRY: 				|
| | C:\\Users\\neo\\Desktop\\ncat.exe KEYWORD: \\\\ncat\\.exe DATE: 07/29/13 05:16:04 TYPE: system 		|
| | HIVEFILE: None EXTRAS: N/A N/A True 									|
+---------------------------------------------------------------------------------------------------------------+


Custom Scan ID Prefix
~~~~~~~~~~~~~~~~~~~~~

Since version 10.5 you are able to set you custom prefix by using
**--scanid-prefix**. The fixed character “S” can be replaced with any
custom string. This allows users to set an identifier for a group of
scans that can be grouped together in a SIEM or Analysis Cockpit.

Run a Scan with Specific Modules
--------------------------------

With the parameter **-a** you can run a single module or select a set of
modules that you’d like to run. ﻿

Valid modules are:

Autoruns, DeepDive, Dropzone, EnvCheck, Filescan, Firewall, Hosts,
LoggedIn, OpenFiles, ProcessCheck, UserDir, ServiceCheck, Users, AtJobs,
DNSCache, Eventlog, HotfixCheck, LSASessions, MFT, Mutex,
NetworkSessions, NetworkShares, RegistryChecks, Rootkit, SHIMCache,
ScheduledTasks, WMIStartup

Examples
^^^^^^^^

Run a Rootkit check only:

.. code:: batch
   
   thor64.exe -a Rootkit

Run the Eventlog and file system scan:

.. code:: batch
	
   thor64.exe –a Eventlog -a Filescan

PE-Sieve Integration
--------------------

THOR integrates PE-Sieve, an open-source tool by @hasherezade to check
for malware masquerading as benevolent processes.

PE-Sieve can be activated to run on Windows as part of the ProcessCheck
module and is capable of detecting advanced techniques such as Process
Doppelganging. When investigating likely infections, you can also raise
the sensitivity of the integrated PE-Sieve's sensitivity beyond the
default (at the cost of likely false positives).

Activate a higher sensitivity with “\ **--full-proc-integrity**\ ”.

Multi-Threading
---------------

THOR supports scanning a system with multiple threads in parallel,
allowing for a significant increase in speed in exchange for a higher
CPU usage.

To use this feature, use the **--threads** flag which allows you to
specify THORs number of parallel threads.

When using the **--lab** (Lab Scanning), **--dropzone** (sample drop
zone) or **--thunderstorm** (Thunderstorm) command line flags, THOR will
default to using as many threads as the system has CPU cores; otherwise,
THOR will still default to running with a single thread.

Enabled Modules
^^^^^^^^^^^^^^^

Not all modules support multi-threading. It is currently enabled in:
File, Registry, Eventlog scanning and Thunderstorm and Dropzone service
mode.

Debugging
---------

Most unexpected behavior can be debugged by using the parameters
**--debug** and the even more verbose **--trace**.

If you ever encounter a situation in which:

* THOR doesn’t produce an alert on a known malicious element
* THOR exits with an error
* THOR takes a long time or unexpected short time on elements

Then try scanning that specific element with the **--debug** and **--trace** parameters set.

Find Bottlenecks 
^^^^^^^^^^^^^^^^

You may get the error message "**MODULE: RuntimeWatcher MESSAGE: Maximum runtime has exceeded, killing THOR**" or encounter very slow
or never-ending scans.

You can check the statistics table in "**thor.db**" on that end
system after a scan to determine the last element or elements that took
a long time to process.

We recommend using: https://sqlitebrowser.org/

The THOR DB is located at: **C:\\ProgramData\\thor\\thor.db**

.. figure:: ../images/image13.png
   :target: ../_images/image13.png
   :alt: Find Bottlenecks

Most Frequent Causes of Missing Alerts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

THOR didn’t scan file due to file size restrictions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Solution: Use **--max\_file\_size** parameter or set permanently in
config file  "**./config/thor.yml**". Also note that in lab scanning
mode the default value is much bigger (**--max\_file\_size\_intense**)

THOR didn’t scan the file due to a skipped deeper inspection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This can be caused by two reasons:

the magic header of that file is not in the list of interesting magic
headers (see **./signatures/misc/file-type-signatures.cfg**) AND file
doesn’t have a relevant file extension (.asp, .vbs, .ps, .ps1, .rar,
.tmp, .bas, .bat, .chm, .cmd, .com, .cpl, .crt, .dll, .exe, .hta, .js,
.lnk, .msc, .ocx, .pcd, .pif, .pot, .pdf, .reg, .scr, .sct, .sys, .url,
.vb, .vbe, .vbs, .wsc, .wsf, .wsh, .ct, .t, .input, .war, .jsp, .php,
.asp, .aspx, .doc, .docx, .pdf, .xls, .xlsx, .ppt, .pptx, .tmp, .log,
.dump, .pwd, .w, .txt, .conf, .cfg, .conf, .config, .psd1, .psm1,
.ps1xml, .clixml, .psc1, .pssc, .pl, .www, .rdp, .jar, .docm, .ace,
.job, .temp, .plg, .asm)

Solution: Use lab scanning mode (**--lab**) or add the magic header to
**file-type-signatures.cfg** (Warning: this file gets overwritten with
an update)
