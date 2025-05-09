
Debugging
=========

Most unexpected behavior can be debugged by using the parameter ``--debug``.

If you ever encounter a situation in which:

* THOR doesn't produce an alert on a known malicious element
* THOR exits with an error
* THOR takes a long time or unexpected short time on elements

Collecting a Diagnostcs Pack
----------------------------

THOR Util comes with the functionality to collect a diagnostics pack for
THOR scans. This is helpful if a scan is taking more time as expected
or if THOR exits unexpectedly. More details can be found in the
`diagnostics section of THOR Util <https://thor-util-manual.nextron-systems.com/en/latest/usage/diagnostics.html>`_.

Debugging Examples
------------------

If you found the culprit for your problematic scan, try scanning that
specific element with the ``--debug`` parameter set.

To run a scan only with certain modules only use the ``--module`` (short hand ``-a``)
command line switch (see :ref:`usage/scan-modes:scan module names` for
a full list of module names):

.. code-block:: doscon

   C:\nextron\thor>thor64.exe -a Mutex
   C:\nextron\thor>thor64.exe -a FileScan
   C:\nextron\thor>thor64.exe -a Eventlog

.. hint::
   You can specify multiple modules:

   .. code-block:: doscon

      C:\nextron\thor>thor64.exe -a Mutex -a EnvCheck -a Users

You can try to reduce the scope of a module even further by using lookbacks

.. code-block:: doscon

   C:\nextron\thor>thor64.exe -a Eventlog --lookback 3
   C:\nextron\thor>thor64.exe -a FileScan -p C:\Windows\System32 --global-lookback --lookback 1

To find out why a certain file couldn't be detected, use
``--debug`` with ``--printall`` and try to switch into ``--intense`` mode.

.. code-block:: doscon

   C:\nextron\thor>thor64.exe -a Filescan -p C:\testfolder --debug --printall
   C:\nextron\thor>thor64.exe -a Filescan -p C:\testfolder --debug --printall --intense

If it has been detected in ``--intense`` mode but not in default mode,
the file extension or the magic header is most likely the problem.
You can adjust ``max_file_size`` in ``./config/thor.yml`` or add a
magic header in ``./signatures/misc/file-type-signatures.cfg``.

Finding Bottlenecks
-------------------

You may get the error message ``MODULE: RuntimeWatcher MESSAGE: Maximum runtime has exceeded, killing THOR``
or encounter very slow/never-ending scans.

You can check the statistics table in ``thor10.db`` on the problematic
endpoint after a scan to determine the last element or elements that took
a long time to process.

We recommend using: https://sqlitebrowser.org/

The THOR DB is located at: ``C:\ProgramData\thor\thor10.db``.

.. figure:: ../images/image13.png
   :alt: Find Bottlenecks

Most Frequent Causes of Missing Alerts
--------------------------------------

Below you can find the most frequent causes of missing alerts.

THOR didn't scan file due to file size restrictions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Solution**: Use the ``--max_file_size`` parameter or set it permanently
in the config file ``./config/thor.yml``.

.. code-block:: doscon

   C:\nextron\thor>thor64.exe --max_file_size 206233600 # setting max file size to 100 MB

.. literalinclude:: ../examples/thor.yaml
   :caption: Default thor.yaml
   :language: yaml
   :linenos:
   :emphasize-lines: 3

THOR didn't scan the file due to a skipped deeper inspection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This can be caused by two reasons:

The magic header of that file is not in the list of interesting magic
headers (see ``./signatures/misc/file-type-signatures.cfg``) AND file
doesn't have a relevant file extension:

.. code-block:: none

   .asp, .vbs, .ps, .ps1, .rar, .tmp, .bas, .bat, .chm, .cmd, .com, .cpl, .crt, .dll,
   .exe, .hta, .js, .lnk, .msc, .ocx, .pcd, .pif, .pot, .pdf, .reg, .scr, .sct, .sys,
   .url, .vb, .vbe, .vbs, .wsc, .wsf, .wsh, .ct, .t, .input, .war, .jsp, .php, .asp,
   .aspx, .doc, .docx, .pdf, .xls, .xlsx, .ppt, .pptx, .tmp, .log, .dump, .pwd, .w,
   .txt, .conf, .cfg, .conf, .config, .psd1, .psm1, .ps1xml, .clixml, .psc1, .pssc,
   .pl, .www, .rdp, .jar, .docm, .ace, .job, .temp, .plg, .asm

**Solution**: Use an intense scanning mode for that folder (``--intense``)
or add the magic header to ``file-type-signatures.cfg``

.. warning::
   This file gets overwritten with an update;
   Intense scanning mode threatens the scan and system stability!

THOR fails to initialize custom rules with the correct type
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It happens very often that users that prepare custom IOCs or YARA rules
forget to include the correct keyword in the filename of the IOC or YARA
rule file.

The correct use of keywords is described in the chapters :ref:`usage/custom-signatures:Simple IOCs`
for IOCs and :ref:`usage/custom-signatures:Specific YARA Rules` for YARA rules.

A wrong or missing keyword leads to situations in which a file that contains
YARA rules that are meant to be applied to log files, but doesn't contain a "log"
keyword in it's filename.

You can review a correct initialization in the command line output or log file.

.. code-block:: none

   Info Adding rule set from my-log-rules.yar as 'log' type

Using the keyword **c2** for C2 IOCs in a filename should result in a line like
the following:

.. code-block:: none

   Info Reading iocs from /tmp/thor10/custom-signatures/iocs/my-c2-iocs.txt as 'domains' type

Most Frequent Causes of Frozen Scans
------------------------------------

Whenever THOR stops or pauses without any traceback or panic message
and no error messages.

Usually the following sources are responsible (descending order, by frequency):

1. An :ref:`usage/debugging:antivirus or edr suspends thor` (>98%)
2. A "paused" command line window due to :ref:`usage/debugging:windows quick edit mode` (<1%)
3. A :ref:`usage/debugging:constant high system load` that causes THOR to stay back and wait for an idling CPU (<1%)
4. :ref:`usage/debugging:the perception of a stalled scan`, which is actually running (<1%)

Antivirus or EDR suspends THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In more than 98% of the cases, an Antivirus or EDR is responsible for a
stalled process. Especially McAfee AV/EDR is a well-known source of issues. This
is caused by the different dialogues in which exceptions have to be defined and
the fact certain kinds of blocks cannot be found in any logs.

If a THOR scans stalls in one of these modules, an Antivirus or EDR interaction is highly likely:

* Mutex
* Events
* NamedPipes
* ShimCache
* ProcessCheck

**Solution**: Review all possible exclusions in your AV / EDR and add the THOR folder to the exclusion list

Windows Quick Edit Mode
^^^^^^^^^^^^^^^^^^^^^^^

Since Windows 10, the Windows command line window has the so-called "Quick Edit Mode"
enabled by default. This mode causes a behavior that can lead to a paused THOR scan
process. Whenever a user switches the active windows from the cmd.exe to a different
application, e.g. Windows Explorer, and clicks back into the command line window, the
running process automatically gets suspended. A user has to press "Enter" to resume
the suspended process. As the progress indicator of THOR isn't always changing, this
could lead to the impression that the scan paused by itself.

**Solution**: Press "Enter" in the command line window

Constant High System Load
^^^^^^^^^^^^^^^^^^^^^^^^^

Since THOR automatically sets a low process priority a scan can slow down to a level
that appears to be paused or suspended on systems that are under a constant high load.

**Solution**: You can avoid this behaviour by using the ``--nolowprio`` flag. Be aware
that scans on a system with a constant high CPU load take longer than on other systems
and could slow down the processes that would otherwise take all the CPU capacity.

The Perception of a Stalled Scan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Under certain circumstances the scan may appear stalled but is still running. What we usually recommend in cases like this is:

1. Press CTRL+C to get into the interrupt prompt and check the currently scanned element.
2. Continue the scan.
3. Wait 30 minutes.
4. Press CTRL+C again and check if it still scans the same element.

**Solution**:

There are 3 possible outcomes:

a. **It scans the same element:** try to find out why (huge log file, huge registry hive)? Exclude it.
b. **It scans elements in a particular folder for a long time:** try to find out why (folder with many logs, folder with many files)? Exclude it.
c. **It doesn't scan the same element or a particular folder:** check the disk content, disk I/O, number of threads used, process monitor, external hard drive speed?

Most Frequent Causes of Failed Scans
------------------------------------

The following examples are the most frequent causes of a failed scan.

External Processes Terminating THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Whenever THOR dies without any traceback or panic message and no error
message in the log file, an external process terminated the THOR process.

Usually the four following sources are responsible (descending order, by frequency):

1. Antivirus or EDR killed the THOR process
2. A user killed the THOR process
3. A management solution that noticed a high CPU load caused by the THOR process killed it
4. Attackers killed the THOR process

.. note::
   A process termination that always happens at the same element is a
   sign for an Antivirus or EDR detection.

Insufficient Free Memory
^^^^^^^^^^^^^^^^^^^^^^^^

If the system you are trying to scan runs out of free memory, you will
encounter the following message in your scan log:

.. code-block:: none

   fatal error: out of memory

Probable causes:

1. Other processes consume a lot of memory
2. THOR's scanning of certain elements requires a lot of memory
3. You've set ulimit values that are too restrictive
4. You are using the wrong THOR version for your architecture
5. You've activated a feature that consumes a lot of memory (e.g. ``--mft`` or ``--intense``)

Whenever THOR recognizes a low amount of free memory, it checks the
top three memory consumers on the system and includes them in the log message,
before exiting the scan.

You could try running THOR in Soft Mode (``--soft``), which will deactivate
modules and features that require a lot of memory.

Using the 32bit binary of THOR named ``thor.exe`` on a 64bit system
can lead to interrupted scans with the above error message. The 32bit binary
is not able to address as much memory as the 64bit version. Always make
sure to use the correct THOR version for the respective architecture.

Several ``ulimits`` might cause THOR to terminate if they are too restrictive, including:

* locked-in-memory size
* address space
* number of open file descriptors
* maximum data size

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

Tell us the exact THOR version you are using:

1. For which operating system (Windows, Linux, macOS)
2. For which architecture (32bit, 64bit)

Run THOR only with the ``--version`` flag and copy the resulting text into
the ticket.

.. code-block:: console

   THOR 10.7.20
   Build 0527b35 (2025-02-17 14:31:26) (linux, amd64)
   YARA 4.5.0
   PE-Sieve 0.3.5
   OpenSSL 3.0.9
   Signature Database 2025/03/11-064342
   Sigma Database r2025-02-03-23-g3ce034bb2

What is the target platform that THOR fails on?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please provide the output of the following commands.

On Windows:

.. code-block:: doscon

   C:\Users\user>systeminfo > systeminfo.txt

On Linux:

.. code-block:: console

   user@desktop:~$ uname -a > uname.txt

On macOS:

.. code-block:: console

   user@macos:~$ system_profiler -detailLevel mini > system_profile.txt

Which command line arguments do you use?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please provide a complete list of command line arguments that you've used
when the error occurred.

.. code-block:: doscon

   C:\thor>thor64.exe --quick -e D:\logs -p C:\Windows\System32

Provide the log of a scan with the ``--debug`` flag
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The most important element is a scan log of a scan with the ``--debug``
flag used.

The easiest way is to run the scan exactly as you've run it when the
problem occurred adding the ``--debug`` command line flag.

.. code-block:: doscon

   C:\thor>thor64.exe --quick -e D:\logs -p C:\Windows\System32 --debug

If you're able to pinpoint the error to a certain module, you could limit
the scan to that module to get to the problematic element more quickly.

.. code-block:: doscon

   C:\thor>thor64.exe -a Rootkit --debug

After the scan you will find the normal text log (\*.txt) in the program folder.
It is okay to replace confidential information like the hostname or IP addresses.

Note: The debug log files can be pretty big, so please compress the file before
submitting it to us. Normal log files have a size between 1 and 4 MB. Scans started
with the ``--debug`` flag typically have sizes of 30-200 MB. The compression ratio is
typically between 2-4%, so a compressed file shouldn't be larger than 10 MB.

Provide a Screenshot (Optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes errors lead to panics of the executables, which causes the situation
in which relevant log lines don't appear in the log file. In these cases, please
also create a screenshot of a panic shown in the command line window.

Provide the THOR database (Optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :ref:`usage/other-topics:THOR DB` helps us debug situations in which
the THOR scan timed out or didn't complete at all. It contains statistics on the
run time of all used modules and the durations of all folders up to the second
folder level from the root of a partition. (e.g. ``C:\Windows\SysWow64``).

The default location of that file is:

* Windows: ``C:\ProgramData\thor\thor10.db``
* Linux/macOS: ``/var/lib/thor/thor10.db``

Please provide that file in situations in which:

* THOR exceeded its maximum run time
* THOR froze and didn't complete a scan for days
* THOR scans take too long for the selected scan targets

Further Notes
^^^^^^^^^^^^^

* If the files are too big to send, even after compression, please contact
  us and you'll receive a file upload link that you can use
* If a certain file or element (eventlog, registry hive) caused the issue,
  please check if you can provide that file or element for our analysis, as those
  files can contain sensitive information.
