
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

   a. ``thor64.exe`` on 64bit Windows systems
   b. ``thor.exe`` on 32bit Windows systems
   c. ``thor-linux-64`` on x86-64 Linux systems
   d. ``thor-linux`` on i386 Linux systems
   e. ``thor-macosx`` on macOS

5. Wait until the scan has completed (this can take between 20 and 180 minutes)
6. When the scan is finished, check the text log and HTML report in the THOR program directory

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

Parameters possibly relevant for your Use Case
-----------------------------------------------

.. list-table::
  :header-rows: 1
  :widths: 30, 70

  * - Parameter
    - Description
  * - **-c, --cpulimit integer**
    - Instruct THOR to pause all scanning if the systems CPU load is higher than the value specified.

      Please see :ref:`usage/configuration:cpu limit (--cpulimit) explained` for more information.
  * - **--allhds**
    - By default THOR scans only the C: partition on Windows machines and other files/folders only

      in cases in which some reference points to a different partition (e.g. configured web root of IIS
      is on ``D:\inetpub``, registered service runs from ``D:\vendor\service``)
  * - **--lookback <days>**

      **--global-lookback**
    - Only check the elements changed or created during the last X days in all available modules (reduces the scan duration significantly)

.. hint::
  On Linux, the ``--allhds`` flag does nothing, since THOR already scans all mounted local file system (FS) devices.
  It does not scan remote file systems such as NFS, SMB, or other network shares **by default** - this has to be
  explicitly enabled.

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

.. code-block:: none

  thor64.exe --nohtml --nocsv -l \\sys\rep\%COMPUTERNAME%_thor.txt

Logging to Syslog Server
^^^^^^^^^^^^^^^^^^^^^^^^

The following command instructs THOR to log to a remote syslog server
only.

.. code-block:: none

  thor64.exe --nohtml --nocsv --nolog -s syslog.server.net

Scan a Single Directory
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe -a Filescan -p C:\temp

Change the output directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe -e Z:\

Only scan the last 7 days of (Windows) Event Logs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe --lookback 7

By default the ``--lookback`` flag/value only applies to (Windows) Event Logs.
To apply it to all modules, use the ``--global-lookback`` flag.

Scan System with Defaults and Make a Surface Scan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, the surface scan (DeepDive) applies all YARA rules in
"./custom-signatures" folder. In this example, all output files are
written to a network share.

.. code-block:: none

  thor64.exe --deepdivecustom -e \\server\share\thor_output\

Intense Scan and DeepDive on a Mounted Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following are two examples on how to scan a mounted image on
Windows and Linux.

.. important::
  Lab scanning mode requires a `forensic lab license <https://www.nextron-systems.com/2020/11/11/thor-forensic-lab-license-features/>`__
  type, which is meant to be used in forensic labs.

Mounted as Drive Z
~~~~~~~~~~~~~~~~~~

.. code-block:: none

  thor64.exe --lab --deepdive -p Z:\

Mounted as /mnt
~~~~~~~~~~~~~~~

.. code-block:: none

  thor64.exe --lab --deepdive -p /mnt

Scan Multiple Paths
^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe --lab -p C:\\ D:\\webapps E:\\inetpub

.. hint::
   non-existent directories will be automatically skipped

Scan All Hard Drives
^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe --allhds

.. hint::
  This flag only works with Windows

Don't Scan Recursively
^^^^^^^^^^^^^^^^^^^^^^

To instruct THOR to scan a folder non-recursively use the ``:NOWALK`` suffix.

.. code-block:: none

  thor64.exe -a FileScan -p C:\Windows\System32:NOWALK

Run a Scan with Specific Modules
--------------------------------

With the parameter ``-a`` you can run a single module or select a set of
modules that you'd like to run. All available modules can be found in the
section :ref:`usage/scan-modes:scan module names`.

Run a Rootkit check only:

.. code-block:: none

  thor64.exe -a Rootkit

Run the Eventlog and file system scan:

.. code-block:: none
	
  thor64.exe –a Eventlog -a Filescan

Select or filter Signatures during Initialization
-------------------------------------------------

THOR 10.7.8 introduces the ``Init Selector`` and ``Init Filter`` functionalities,
allowing users to fine-tune and customize their scanning process for
improved accuracy and efficiency.

You can use these flags to limit the signature set to a certain campaign,
threat or threat actor.

The filter values are applied to:

- Rule name
- Tags
- Description

Here are some examples:

.. code-block:: doscon

  C:\thor>thor64.exe --init-selector ProxyShell

You can pass multiple selector keywords separated by comma:

.. code-block:: doscon

  C:\thor>thor64.exe --init-selector RANSOM,Lockbit

Or filter a set of signatures that only cause false positives in your environment:

.. code-block:: doscon

  C:\thor>thor64.exe --init-filter AutoIt

It is important to note that while these features offer flexibility
and customization, we recommend utilizing a limited signature set only
for specific use cases. This approach is particularly suitable when
scanning exclusively for indicators related to a specific campaign.
By understanding the proper utilization of Init Selectors and Init
Filters, users can optimize their scanning process and effectively
identify targeted threats.

The main advantages of a reduced signature set are:

- improved scan speed
- lower memory usage

To get a list of all rules contained within the signature set of THOR,
you can run the following command. Please keep in mind that the output
is really long, so we recommend to send the console output to a file,
which makes it easier to search for specific metadata:

.. code-block:: doscon

  C:\thor>thor64.exe --print-signatures > signatures.txt

.. note::
  The command might take a bit, since the signature set is quite big.

PE-Sieve Integration
--------------------

THOR integrates `PE-Sieve <https://github.com/hasherezade/pe-sieve>`__,
an open-source tool by ``@hasherezade`` to check for malware masquerading
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

See the `PE-Sieve documentation <https://github.com/hasherezade/pe-sieve/wiki>`__
for more details on these values.

Multi-Threading
---------------

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
