
Scan
====

This chapter is a quick introduction on how to run a THOR scan
and how to personalize scans to better fit your environment and
expectations.

Please note, the command line arguments are used to fine tune
your scans and yield potentially better results for your use cases.

There is no "one fits all" command line argument, but we designed
THOR to cover the broadest area with minimal impact in the default
operating mode. Default in this case means no additional command
line arguments.

Quick Start
-----------

Follow these steps to complete your first THOR scan

1. Make sure you've read the :doc:`/usage/beforeyoubegin` guide
2. Open a command line as administrative user
   
   a. Administrator on Windows
   b. root on Linux and macOS

3. Navigate to the folder in which you've extracted the THOR package and placed the license file(s)
4. Start THOR on your command line
   
   a. ``thor64.exe`` on 64-bit Windows systems
   b. ``thor.exe`` on 32-bit Windows systems
   c. ``thor-linux-64`` on x86-64 Linux systems
   d. ``thor-linux`` on i386 Linux systems
   e. ``thor-macos`` on macOS

5. Wait until the scan has completed (this can take between 20 and 180 minutes)
6. When the scan is finsihed, check the text log and HTML report in the THOR program directory

Often Used Parameters
---------------------

.. list-table::
  :header-rows: 1
  :widths: 30, 70

  * - Parameter
    - Description
  * - **--soft**
    - Reduce CPU usage, skip all checks that can consume a lot of memory (even if only for a few seconds)
  * - **--quick**
    - Perform a quick scan (skips Eventlog and checks only the most relevant folders); see :doc:`/usage/scan-modes` 
  * - **-e target-folder**
    - Write all output files to the given folder

Parameters Possibly Relevant for Your User Case
-----------------------------------------------

.. list-table::
  :header-rows: 1
  :widths: 30, 70

  * - Parameter
    - Description
  * - **-c, --cpulimit percentage**
    - Reduce the average CPU load to the given percentage value. This can be helpful to reduce the load e.g. on server systems with real-time services or reduce the noise produced by fans on user laptops.

      The specified value is a percentage value for the complete CPU. For example, ``--cpulimit 50`` on a quad-core system limits THOR to using at most 50% of the available CPU time, which would be 2 cores.
  * - **--allhds**
    - By default THOR scans only the C: partition on Windows machines and other files/folders only in cases in which some reference points to a different partition (e.g. configured web root of IIS is on ``D:\inetpub``, registered service runs from ``D:\vendor\service``)
  * - **--lookback days**
      **--globallookback**
    - Only check the elements changed or created during the last X days in all available modules (reduces the scan duration significantly)

Risky Flags
-----------

This list contains flags that should better be avoided unless you know exactly what you're doing.

.. list-table::
  :header-rows: 1
  :widths: 30, 70

  * - Parameter
    - Description
  * - **--intense**
    - long runtime, stability issues due to disabled resource control
  * - **--c2-in-memory**
    - many false positives on user workstations (especially browser memory)
  * - **--alldrives**
    - long runtime, stability issues due to scan on network drives or other remote file systems
  * - **--mft**
    - stability issues due to high memory usage
  * - **--dump-procs**
    - stability issues, possibly high disk space usage (free disk space checks are implemented but may fail)
  * - **--full-registry**
    - longer runtime, low positive impact

Lesser Known But Useful Flags
-----------------------------

This list contains flags that are often used by analysts to tweak the scan in useful ways.

.. list-table::
  :header-rows: 1
  :widths: 30, 70

  * - Parameter
    - Description
  * - **--allreasons**
    - Show all reasons that led to a certain score
  * - **--printshim**
    - Print all available SHIM cache entries into the log
  * - **--utc**
    - Print all timestamps in UTC (helpful when creating timelines)
  * - **--string-context num-chars**
    - Number of characters preceeding and following the string match to show in the output

Help and Debugging
------------------

You can use the following parameters help you to understand THOR and the output better.

.. list-table::
  :header-rows: 1
  :widths: 30, 70

  * - Parameter
    - Description
  * - **--debug**
    - Get debug information if errors occur
  * - **--help**
    - Get a help with the most important scan options
  * - **--fullhelp**
    - Get a help with all scan options

Examples
--------

Logging to a Network Share
^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command creates a plaintext log file on a share called
"rep" on system "sys" if the user running the command has the respective
access rights on the share.

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --nohtml --nocsv -l \\sys\rep\%COMPUTERNAME%_thor.txt

Logging to Syslog Server
^^^^^^^^^^^^^^^^^^^^^^^^

The following command instructs THOR to log to a remote syslog server
only.

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --nohtml --nocsv --nolog -s syslog.server.net

Scan Run on a Single Directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --lab -p C:\ProgramData
  C:\nextron\thor>thor64.exe --lab -p I:\mounted\_image\disk1

.. important::
  This feature requires a `forensic lab license <https://www.nextron-systems.com/2020/11/11/thor-forensic-lab-license-features/>`__
  type which is meant to be used in forensic labs. 

You can imitate a lab scan without a lab license with these command line flags:

.. code-block:: doscon 

  C:\nextron\thor>thor64.exe -a Filescan --intense --norescontrol --nosoft --cross-platform -p C:\ProgramData

Save the result files to a different directory 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\nextron\thor>thor64.exe -s 10.1.5.14 -e Z:\

Only scan the last 7 days of the Windows Eventlog and log files on disk 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --lookback 7

Scan System with Defaults and Make a Surface Scan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, the surface scan (DeepDive) applies all YARA rules in
"./custom-signatures" folder. In this example, all output files are
written to a network share.

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --deepdivecustom -e \\server\share\thor_output\

Intense Scan and DeepDive on a Mounted Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following are two examples on how to scan a mounted image on
Windows and Linux.

Mounted as Drive Z
~~~~~~~~~~~~~~~~~~

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --lab --deepdive -p Z:\

Mounted as /mnt
~~~~~~~~~~~~~~~

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --lab --deepdive -p /mnt

.. important::
  Lab scanning mode requires a `forensic lab license <https://www.nextron-systems.com/2020/11/11/thor-forensic-lab-license-features/>`__
  type which is meant to be used in forensic labs. 

Scanning a Folder or Drive without a Forensic Lab License
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can achieve a similar (but not an equal) scan using a standard license and the following command line:

.. code-block:: doscon 

  C:\nextron\thor>thor64.exe -a Filescan --intense --norescontrol --cross-platform --alldrives -p E:\

You can find more information on the advantages of a THOR Forensic Lab license `here <https://www.nextron-systems.com/2020/11/11/thor-forensic-lab-license-features/>`__.

Throttled THOR Run (static throttling value)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Will restrict THOR's CPU usage in the long running modules "FileScan",
"Eventlog", "LogScan" and "Registry" to 60%. Note that THOR
automatically applies certain restrictions in automatic soft mode.

.. code-block:: doscon

  C:\nextron\thor>thor64.exe -c 60

Scan Multiple Paths
^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --lab -p C:\\ D:\\webapps E:\\inetpub

(non-existent directories will be automatically skipped)

Scan All Hard Drives (Windows Only)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\nextron\thor>thor64.exe --allhds

Don't Scan Recursively 
^^^^^^^^^^^^^^^^^^^^^^

To instruct THOR to scan a folder non-recursively use the ``:NOWALK`` suffix. 

.. code-block:: doscon

  C:\nextron\thor>thor64.exe -a FileScan -p C:\Windows\System32:NOWALK

Run a Scan with Specific Modules
--------------------------------

With the parameter ``-a`` you can run a single module or select a set of
modules that you'd like to run. All available modules can be found in the
section :ref:`usage/scan-modes:scan module names`.

Run a Rootkit check only:

.. code-block:: doscon
   
  C:\nextron\thor>thor64.exe -a Rootkit

Run the Eventlog and file system scan:

.. code-block:: doscon
	
  C:\nextron\thor>thor64.exe –a Eventlog -a Filescan

PE-Sieve Integration
--------------------

THOR integrates `PE-Sieve <https://github.com/hasherezade/pe-sieve>`__, 
an open-source tool by @hasherezade to check for malware masquerading 
as benevolent processes.

PE-Sieve can be activated by using the ``--processintegrity`` flag. It 
runs on Windows as part of the ProcessCheck module and is capable of 
detecting advanced techniques such as Process Doppelganging.

When investigating infections, you can also raise 
the sensitivity of the integrated PE-Sieve beyond the default with
``--full-proc-integrity`` (at the cost of possible false positives).

THOR reports PE-Sieve results as follows:

.. list-table::
  :header-rows: 1
  :widths: 50, 50

  * - Findings
    - THOR's Reporting Level 
  * - Replaced PE File
    - Warning
  * - Implanted PE File
    - Warning
  * - Unreachable File
    - Notice
  * - Patched
    - Notice
  * - IAT Hooked
    - Notice
  * - Others
    - No Output in THOR   

See the `PE-Sieve documentation <https://hasherezade.github.io/pe-sieve/structt__report.html>`__
for more details on these values.

Multi-Threading
---------------

Starting from version 10.6, THOR supports scanning a system with multiple
threads in parallel, allowing for a significant increase in speed in
exchange for a higher CPU usage.

To use this feature, use the ``--threads`` flag which allows you to
specify THOR's number of parallel threads.

When using the ``--lab`` (Lab Scanning), ``--dropzone`` (sample drop
zone) or ``--thunderstorm`` (Thunderstorm) command line flags, THOR will
default to using as many threads as the system has CPU cores; otherwise,
THOR will still default to running with a single thread.

.. note::
  The above listed modes are only available with the "Lab", "Thunderstorm"
  and "Incident Response" license type.

Enabled Modules
^^^^^^^^^^^^^^^

Not all modules support multi-threading. It is currently supported for:

* Filescan
* RegistryChecks
* Eventlog
* Thunderstorm (Thunderstorm License needed)
* Dropzone (Lab License needed)
