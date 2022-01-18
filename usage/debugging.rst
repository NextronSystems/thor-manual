
Debugging
=========

Most unexpected behavior can be debugged by using the parameter **--debug**.

If you ever encounter a situation in which:

* THOR doesn’t produce an alert on a known malicious element
* THOR exits with an error
* THOR takes a long time or unexpected short time on elements

Debugging Examples 
------------------

Then try scanning that specific element with the **--debug** parameter set.

To run only a certain module use: 

.. code:: batch 
   
   thor64.exe -a Mutex
   thor64.exe -a FileScan 
   thor64.exe -a Eventlog

You can try to reduce the scope of a module even further by using lookbacks

.. code:: batch

   thor64.exe -a Eventlog --lookback 3
   thor64.exe -a FileScan -p C:\Windows\System32 --globallookback --lookback 1

To find out why a certain file couldn't be detected, use 
**--debug** with **--printall** and try to switch into **intense mode**.  

.. code:: batch

   thor64.exe -a Filescan -p C:\testfolder --debug --printall 
   thor64.exe -a Filescan -p C:\testfolder --debug --printall --intense

If it has been detected in **intense mode** but not in default mode, 
the file extension or the magic header is most likely the problem. 
You can adjust **max_file_size** in **./config/thor.yml** or add a 
magic header in **./signatures/misc/file-type-signatures.cfg**.

Finding Bottlenecks 
-------------------

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
--------------------------------------

THOR didn’t scan file due to file size restrictions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Solution: Use **--max\_file\_size** parameter or set permanently in
config file  "**./config/thor.yml**". Also note that in lab scanning
mode the default value is much bigger (**--max\_file\_size\_intense**)

THOR didn’t scan the file due to a skipped deeper inspection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Solution: Use an intense scanning mode for that folder (**--intense**) 
or add the magic header to **file-type-signatures.cfg** 
(Warning: this file gets overwritten with an update; Warning: intense 
scanning mode threatens the scan's and system's stability).

THOR fails to initialize custom rules with the correct type
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
It happens very often that users that prepare custom IOCs or YARA rules 
forget to include the correct keyword in the filename of the IOC or YARA
rule file.

The currect use of keywords is described in :ref:`this chapter <usage/custom-signatures:Simple IOCs>` for IOCs and 
:ref:`this chapter <usage/custom-signatures:Specific YARA Rules>` for YARA rules. 

A wrong or missing keyword leads to situations in which a file that contains 
YARA rules that are meant to be applied to log files, doesn't contain a "log" 
keyword in it's name. 

You can review a correct initialization in the command line output or log file. 

.. code:: batch 

   Info Adding rule set from my-log-rules.yar as 'log' type

Using the keyword **c2** for C2 IOCs in a filename should result in a line like 
the following:

.. code:: batch 

   Info Reading iocs from /tmp/thor10/custom-signatures/iocs/my-c2-iocs.txt as 'domains' type

Most Frequent Causes of Frozen Scans
------------------------------------

Whenever THOR stops / pauses without any traceback or panic message and no error 

Usually the following sources are responsible (descending order, by frequency):

1. Antivirus or EDR suspends the THOR process (>90%)
2. A frozen command line window due to Windows "Quick Edit Mode" (<10%)
3. A constant high system load that causes THOR to stay back and wait for an idling CPU (<3%)
4. The sensation of a stalled scan that is actually running (<3%)

Antivirus or EDR suspends THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In more than 95% and more of the cases, an Antivirus or EDR is responsible for a stalled process. Especially McAfee AV/EDR is a well-known source of issues. This is caused by the different dialogues in which exceptions have to be defined and the fact the certain kinds of blocks cannot be found in any logs.

If a THOR scans stalls in one of these modules, a Antivirus or EDR interaction is highly likely: 

- Mutex
- Events
- NamedPipes
- ShimCache
- ProcessCheck

Solution: Review all possible exclusions in your AV / EDR and add the THOR folder to the exclusion list

Windows Quick Edit Mode 
^^^^^^^^^^^^^^^^^^^^^^^

Since Windows 10, the Windows command line window has the so-called "Quick Edit Mode" enabled by default. This mode causes a behaviour that can lead to a paused THOR scan process. Whenever a user switches the active windows from the cmd.exe to a different application, e.g. Windows Explorer, and clicks back into the command line window, the running process automatically gets suspended. A user has to press "Enter" to resume the suspended process. As the progress indicator of THOR isn't always changing, this could lead to the impression that the scan paused by itself. 

See `this <https://stackoverflow.com/questions/30418886/how-and-why-does-quickedit-mode-in-command-prompt-freeze-applications`_ StackOverflow post for more details.

Solution: Press "Enter" in the command line window

Constant High System Load 
^^^^^^^^^^^^^^^^^^^^^^^^^

Since THOR automatically sets a low process priority a scan can slow down to a level that appears to be paused or suspended on systems that are under a contant high load. 

Solution: You can avoid this behaviour by using the ``--nolowprio`` flag. Be aware that scans on a system with a contant high CPU load take longer than on other systems and could slow down the processes that would otherwise take all the CPU capacity.

The Sensation of a Stalled Scan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Under certain circumstances the scan may appear stalled but is still running. You can always interrupt a scan using CTRL+C that brings THOR into the interrupt menu in which you can see the currently scanned element. In case of the "FileScan" module, this is a file or folder. In case of the "EventLog" module, this is an event with an ID. If you resume the scan by pressing "C" and interrupt it again a few minutes later, you should see another element in the interrupt menu. 

If THOR still processes the same element for several hours, we recommend checking that element (size, format, access rights, location).

Solution: Check progress using the interrupt menu (CTRL+C)

Most Frequent Causes of Failed Scans
------------------------------------

External Processes Terminating THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Whenever THOR dies without any traceback or panic message and no error 
message in the log file, an external process terminated the THOR process.

Usually the four following sources are responsible (descending order, by frequency):

1. Antivirus or EDR killed the THOR process
2. A user killed the THOR process
3. A management solution that noticed a high CPU load caused by the THOR process killed it
4. Attackers killed the THOR process

Note: A process termination that always happens at the same element is a sign for an Antivirus or EDR detection.

Insufficient Free Memory
^^^^^^^^^^^^^^^^^^^^^^^^

.. code::

   fatal error: out of memory

Probable causes: 

1. Other processes consume a lot of memory
2. THOR's scanning of certain elements requires a lot of memory
3. You've set ulimit values that are too restrictive
4. You are using the wrong THOR version for your architecture
5. You've activated a feature that consumes a lot of memory (e.g. --mft or --intense)

Whenever THOR recognizes a low amount of free memory, THOR checks the 
top 3 memory consumers on the system and includes them in the log message
that it writes before exiting. 

You could try running THOR in Soft Mode (--soft) in which modules and 
features that require a lot of memory are deactivated. 

Using the 32bit binary of thor named **thor.exe** on a 64bit system 
can lead to interrupted scans with this error message. The 32bit binary
isn't able to address as much memory as the 64bit version. Always make 
sure to use the correct THOR version for the respective architecture.

Several ulimits might cause THOR to terminate if they are too restrictive, including:

 - locked-in-memory size
 - address space
 - number of open file descriptors
 - maximum data size

 If you are certain your machine has sufficient RAM, check your ulimits with ``ulimit -a``
 and try to rerun the scan with increased limits, if necessary.
 The `man page <https://www.man7.org/linux/man-pages/man5/limits.conf.5.html>`_ for the ulimits
 configuration size gives a full overview over the limits and how to persistently modify them.

Help Us With The Debugging
--------------------------

If you cannot find the source of a problem, please contact us using the 
support@nextron-systems.com email address. 

You can help us find and debug the problem as quickly as possible by 
providing the following information. 

Which THOR version do you use?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Tell us which THOR version you are using: 

1. for which operating system (Windows, Linux, macOS, AIX) 
2. for which architecure (32bit, 64bit)

Run **thor --version** and copy the resulting text into the email. 

On Windows: 

.. code:: batch 

   thor64.exe --version 

On Linux: 

.. code:: bash 

   ./thor-linux-64 --version 

On Mac OS:

.. code:: bash 

   ./thor-macosx --version

This should produce a message like this: 

.. code::

   THOR 10.6.6
   Build bea8066 (2021-04-27 14:32:40)
   YARA 4.0.5
   PE-Sieve 0.2.8.5
   OpenSSL 1.1.1j
   Signature Database 2021/05/03-150936
   Sigma Database 0.19.1-1749-g2f12c5c5

What is the target platform that THOR fails on? 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please provide the output of the following commands.

On Windows: 

.. code:: batch 

   systeminfo > systeminfo.txt 

On Linux: 

.. code:: bash 

   uname -a 

On Mac OS:

.. code:: bash 

   system_profiler -detailLevel mini > system_profile.txt

Which command line arguments do you use?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please provide a complete list of command line arguments that you've used 
when the error occurred. 

.. code:: batch 

   thor64.exe --quick -e D:\logs -p C:\Windows\System32

Provide the log of a scan with --debug flag 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The most important element is a scan log of a scan with set **--debug** 
flag. 

The easiest way is to run the scan exactly as you've run it when the 
problem occured adding the **--debug** command line flag. 

e.g. 

.. code:: batch 

   thor64.exe --quick -e D:\logs -p C:\Windows\System32 --debug

If you're able to pinpoint the error to a certain module, you could limit 
the scan to that module to get to the problematic element more quickly, e.g.

.. code:: batch 

   thor64.exe -a Rootkit --debug

After the scan you will find the normal text log (\*.txt) in the program folder.
It is okay to replace confidential information like the hostname or IP addresses.

Note: The debug log files can be pretty big, so please compress the file before 
submitting it to us. Normal log files have a size between 1 and 4 MB. Scans started 
with the --debug flag typically have sizes of 30-200 MB. The compression ratio is 
typically between 2-4%, so a compressed file shouldn't be larger than 10 MB. 

Provide a Screenshot (Optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes errors lead to panics of the executables, which causes the situation 
that the relevant log lines don't appear in the log file. In these cases, please 
also create a screenshot of a panic shown in the command line window.

Provide the THOR database (Optional) 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :ref:`THOR DB <usage/other-topics:THOR DB>` helps us debug situations in which 
the THOR scan timed out or didn't complete at all. It contains statistics on the 
run time of all used modules and the durations of all folders up to the second 
folder level from the root of a partition. (e.g. C:\\Windows\\SysWow64). 

The default location of that file is: 

* Windows: **C:\\ProgramData\\thor\\thor.db** 
* Linux/macOS: **/var/lib/thor/thor.db**

Please provide that file in situations in which: 

* THOR exceeded its maximum run time 
* THOR froze and didn't complete a scan for days 
* THOR scans take too long for the selected scan targets

Further Notes 
^^^^^^^^^^^^^

* If the files are too big to send, even after compression, please contact us and you'll receive a file upload link that you can use 
* If a certain file or element (eventlog, registry hive) caused the issue, please check if you can provide that file or element for our analysis
