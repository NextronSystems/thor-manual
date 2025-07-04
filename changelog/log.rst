Changelog
#########

In this chapter you can find all the changes for THOR 10.7

THOR 10.7.22
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - THOR Lite now supports archive scanning
    * - Bugfix
      - File excludes are now applied to process images as well
    * - Bugfix
      - Fix an issue where usage of --threads in thor.yml caused an error at startup

THOR 10.7.21
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Revert removal of --action flags for now (will be removed in THOR 11)
    * - Bugfix
      - Fix a situation where Thor panics in Windows Safe Mode
    * - Bugfix
      - Fix an issue where SHIM cache entries were scanned repeatedly if more than one SHIM cache was scanned

THOR 10.7.20
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New ``unpack_source`` / ``unpack_parent`` variables are now available in YARA rules and display the previous unpacking steps the matched data went through
    * - Bugfix
      - When running with ``--follow-symlinks`` on Windows, don't skip reparse points
    * - Bugfix
      - Correctly include both hostname and IP when logging via syslog

THOR 10.7.19
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fix an issue with running ``thor-util diagnostics --run`` subsequent to a THOR run where ``--threads`` were specified explicitly
    * - Bugfix
      - Fix an issue where THOR on Windows incorrectly skipped USB drives
    * - Bugfix
      - Correctly categorize /usr as part of the running image

THOR 10.7.18
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fix an issue where cabinet file extraction could consume more memory than necessary
    * - Bugfix
      - Clarify error message if THOR DB file is not writable

THOR 10.7.17
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New ``--dropzone-delay`` flag to specify the delay between the last write to a file in the dropzone and the scan (to avoid scanning files that are still being written)
    * - Change
      - Add support for more sigma modifiers
    * - Bugfix
      - Fix an issue where remote IP / port weren't show in some ProcessConnection messages
    * - Bugfix
      - Fix an issue where THOR would access network paths on Windows even if ``--alldrives`` wasn't set

THOR 10.7.16
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - ``--maxsysloglength``, ``--rfc3164``, ``--rfc5424`` and ``--rfc`` no longer apply to syslog outputs with JSON formatted outputs (since the truncated output would be invalid JSON)
    * - Bugfix
      - Fix an issue where simultaneous truncation on a currently scanned file could cause a crash

THOR 10.7.15
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Shell completions can now be generated for bash, zsh, fish and powershell with ``--completions``
    * - Feature
      - Multithreading is now available for all license types (use ``--threads`` to set the number of threads)
    * - Bugfix
      - Fix an issue where usage of ``--syslog`` with CEF output caused a crash
    * - Bugfix
      - Apply '--max-hits' to Timestomp module

THOR 10.7.14
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New ``--max-reasons`` flag to limit the shown number of reasons per message. This flag replaces ``--allreasons``, which will still work, but is now deprecated.
    * - Bugfix
      - Fix an issue where the 32-bit version of THOR for Linux crashed when loading the signatures
    * - Bugfix
      - Fix an issue where large /etc/hosts files could cause extremely long scan times
    * - Bugfix
      - Fix an issue where entries in /etc/hosts that mapped multiple hostnames to the same IP address could cause hard-to-read log entries

THOR 10.7.13
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New ``--max-hits`` flag to limit the number of hits per IOC or YARA rule
    * - Feature
      - ``--eventlog-target`` now supports '*' as a target
    * - Change
      - Memory dump files are now scanned with process memory YARA rules rather than the default YARA rules
    * - Change
      - Update to Golang v1.20.13
    * - Bugfix
      - ``--lab --collector`` now activates the artifact collector, as intended
    * - Bugfix
      - Fix an issue where THOR could crash during initialization
    * - Bugfix
      - Dataless files on MacOS are now ignored
    * - Bugfix
      - Fix an issue where some network drives on Linux were scanned even if ``--alldrives`` was not activated
    * - Bugfix
      - Fix an issue where THOR for Linux could crash in the 'Crontab' module
    * - Bugfix
      - Fix an issue where some eventlogs could cause a crash in the 'Eventlog' module
    * - Bugfix
      - Fix an issue where, if an error occurred when reading a file, incorrect file hashes were displayed

THOR 10.7.12
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fix an issue where a high number of mutexes could cause a crash in THOR

THOR 10.7.11
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fix an issue where THOR could hang when scanning specific processes on Linux

THOR 10.7.10
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New ``--nommap`` flag to disable memory mapping in features
    * - Change
      - Remove action feature due to potential abusability
    * - Change
      - Update to Golang v1.20.10
    * - Change
      - SFX RAR executables are now extracted using the Archive feature instead of the ExeDecompress feature, which allows access to the filenames within the archive
    * - Bugfix
      - Fix an issue where too many open handles on a system could cause a crash
    * - Bugfix
      - Fix an issue where a scan exit due to the Rescontrol could cause a deadlock
    * - Bugfix
      - Ensure that data is truncated, even if match strings are unusually large
    * - Bugfix
      - Fix an issue where the EtwWatcher could crash when finishing


THOR 10.7.9
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - CPU limit now applies only to full system CPU usage, not only THOR (reverts a change made in 10.7.4)
    * - Change
      - If THOR is cancelled by the Rescontrol feature, the information is now displayed as an Error instead of a Warning
    * - Change
      - Standardized logging of matches on processes
    * - Change
      - Update to Golang v1.20.6
    * - Change
      - Update to YARA v4.3.2
    * - Bugfix
      - Fixed an issue where simultaneous write access from another process to a file that THOR scanned could cause the THOR scan to fail
    * - Bugfix
      - Fixed an issue where old Windows systems could incorrectly be displayed as unpatched
    * - Bugfix
      - Fixed an issue where 'thor-util update' could remove the file type signatures

THOR 10.7.8
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - (via THOR Util) log conversion to CSV is now possible
    * - Feature
      - New Artifact Collector module, which allows collection of forensic artifacts from the current system into a ZIP file
    * - Feature
      - New ``--print-signatures-json`` flag for JSON output of current signatures
    * - Feature
      - New ``--init-selector`` and ``--init-filter`` flags which allow the user to load only a subset of the normal signatures
    * - Change
      - When using ``--encrypt``, log files are now encrypted as they are written during the THOR scan. This prevents temporary log files, but also makes generation of HTML reports afterwards impossible. Use THOR Util instead to generate HTML reports after decrypting the logs.
    * - Change
      - Display matches on reverse lookup IP addresses in a better way
    * - Change
      - Update to Golang v1.20.5
    * - Change
      - Update to OpenSSL 3.0.9
    * - Bugfix
      - Display error messages correctly in JSON logs
    * - Bugfix
      - On Linux, don't skip directories with children where lstat() fails

THOR 10.7.7
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Change
      - THOR Lite licenses with Sigma now also have the Eventlog and EVTX modules enabled

THOR 10.7.6
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Add ``--minimum-sigma-level`` to specify which Sigma rules should trigger a finding. This defaults to high and is reduced to medium in intense mode, which is the current behaviour.
    * - Feature
      - Add ``--audit-trail`` for detailed log output of THOR scan trails. This feature is experimental so far, and the output and output format may yet change.
    * - Feature
      - Add ``--background`` to adjust THOR log level colors to specific backgrounds. Currently, optimizeds for dark and light backgrounds are available.
    * - Feature
      - Add ``--jsonv2`` which changes the JSON output to better reflect the structure of the log entry, with substructures now properly representing parts of the log entry. This also affects Thunderstorm responses when set.
    * - Change
      - Increased default value for ``--yara-stack-size`` to 32768
    * - Change
      - Standardized logging of filename IOC related reasons
    * - Change
      - Update to Golang v1.20.2
    * - Bugfix
      - Fix an issue where THOR scans failed due to a perceived symlink loop in the scan path

THOR 10.7.5
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Add new ETL feature for parsing ETL files
    * - Feature
      - Add ``--vtkey``, ``--vtmode``, and ``--vtaccepteula`` flag for integration of VirusTotal in THOR
    * - Feature
      - Improve progress reports when scanning complex files
    * - Feature
      - Support Sigma scans with THOR Lite for specific licenses
    * - Change
      - Unify logging fields for many filename IOC, keyword IOC and YARA matches
    * - Change
      - Unify logging fields for many messages in the NetworkShares module
    * - Change
      - Update to Golang v1.19.5
    * - Change
      - Upgrade PE-Sieve to v0.3.5
    * - Change
      - ``--print-signatures`` now silences the normal initialization output
    * - Change
      - Use mimalloc for YARA allocations on Linux and MacOS
    * - Change
      - Scanning network paths now requires a Lab license
    * - Bugfix
      - Reduce log level for corrupt /etc/passwd entries from Notice to Info
    * - Bugfix
      - Identify packed samples correctly with --customonly set

THOR 10.7.4
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - New OLE feature for extraction of Office macros
    * - Feature
      - ExeDecompress feature is now also supported on Linux
    * - Feature
      - Added ``--lowioprio`` flag for lowered IO priority
    * - Change
      - Update to Golang v1.19.2
    * - Change
      - CPU limit now applies only to THOR's CPU usage, not the the complete system
    * - Change
      - Windows Access Groups (e.g. in file permissions) are now always displayed in English
    * - Change
      - Modified the scoring formula to further reduce the impact of multiple subscores on the full score. As compensation, the default threshold for alerts has been reduced.
    * - Bugfix
      - .lnk file processing with ``--virtual-map`` no longer causes link targets to be scanned without applying the virtual mapping
    * - Bugfix
      - Access faults while reading memory mapped files no longer cause THOR to crash
    * - Bugfix
      - Panics on opening an archive are now handled properly

THOR 10.7.3
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Meta rule matches with 'FORCE' tag will now cause THOR to ignore the maximum file size for that file
    * - Feature
      - Improved matching behaviour of YARA rules on bulks. Scans on bulks (but not scans on single bulk elements) will now use a different YARA ruleset where common false positive constructs (e.g. filesize) are removed.
    * - Feature
      - Improved performance in cases where a rule or IOC matched on a bulk
    * - Feature
      - Improved memory usage and performance of HTML report generation
    * - Feature
      - THOR now issues a Notice or Warning for Office connection cache entries
    * - Feature
      - THOR now scans archives (e.g. ZIP files) recursively. This changes how matches in subfiles of archives are reported.
    * - Feature
      - Added '.cab' support in the 'Archive' feature
    * - Feature
      - Added '.gz' support in the 'Archive' feature
    * - Feature
      - Added '.7z' support in the 'Archive' feature
    * - Feature
      - Added new 'EML' feature for scanning .eml files
    * - Change
      - Increase amount of bytes scanned by meta rules to 2048
    * - Change
      - THOR now prefers reading files via memory maps over using the file read API
    * - Bugfix
      - Improved performance of Sigma rule loading
    * - Bugfix
      - Fixed a bug where THOR scanned some files multiple times, possibly resulting in a loop

THOR 10.7.2
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Process memory checks are now enabled on Linux and MacOS
    * - Feature
      - Added a check on Linux for deleted executables
    * - Feature
      - UTF-16 Log files are now parsed correctly
    * - Change
      - Upgrade YARA to v4.2.1

THOR 10.7.1
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Sigma rules are now applied to running processes on the system
    * - Feature
      - New command line option '-follow-symlinks' that causes the FileScan module to follow symlinks.
    * - Feature
      - Checking e.g. log lines from a file with YARA will now set the THOR external variables like 'filepath' appropriately
    * - Feature
      - THOR now shows modules names where string matches were found if a YARA rule matches on process memory
    * - Feature
      - THOR now shows a warning if low rlimits are detected
    * - Change
      - THOR will now scan processes even in soft mode, with a maximum process size of 250MB.
    * - Change
      - ``--max_file_size_intense`` is now deprecated. Instead, ``--max_file_size`` should be used.
    * - Change
      - ``--virtual-map`` now supports mounts in subpaths on Windows, e.g. as ``--virtual-map G:\mount:C``
    * - Change
      - Upgrade PE-Sieve to v0.3.3
    * - Change
      - Filescan progress report for folders without subfolders was improved

THOR 10.7.0
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Mark files with names close to common Windows executables as suspicious
    * - Feature
      - Change how score is added to avoid cases where scores added up to absurd values
    * - Feature
      - Support scanning alternate data streams with ``--ads``
    * - Feature
      - Check environment variables of processes
    * - Change
      - THOR now terminates if a positional argument was specified since none are expected
    * - Fix
      - Scan files written to the Dropzone only once the write is complete (or does not continue for at least 1 second)
