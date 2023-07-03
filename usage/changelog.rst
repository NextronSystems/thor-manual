Changelog
=========

This chapter contains all the changes of THOR.

THOR 10.7 (Techpreview)
#######################

THOR Version 10.7.8
~~~~~~~~~~~~~~~~~~~

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
      - New '--print-signatures-json' flag for JSON output of current signatures
    * - Feature
      - New '--init-selector' and '--init-filter' flags which allow the user to load only a subset of the normal signatures
    * - Change
      - When using '--encrypt', log files are now encrypted as they are written during the THOR scan. This prevents temporary log files, but also makes generation of HTML reports afterwards impossible. Use THOR Util instead to generate HTML reports after decrypting the logs.
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

THOR Version 10.7.7
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Change
      - THOR Lite licenses with Sigma now also have the Eventlog and EVTX modules enabled

THOR Version 10.7.6
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Add '--minimum-sigma-level' to specify which Sigma rules should trigger a finding. This defaults to high and is reduced to medium in intense mode, which is the current behaviour.
    * - Feature
      - Add '--audit-trail' for detailed log output of THOR scan trails. This feature is experimental so far, and the output and output format may yet change.
    * - Feature
      - Add '--background' to adjust THOR log level colors to specific backgrounds. Currently, optimized versions for dark and light backgrounds are available.
    * - Feature
      - Add '--jsonv2' which changes the JSON output to better reflect the structure of the log entry, with substructures now properly representing parts of the log entry. This also affects Thunderstorm responses when set.
    * - Change
      - Increased default value for '--yara-stack-size' to 32768
    * - Change
      - Standardized logging of filename IOC related reasons
    * - Change
      - Update to Golang v1.20.2
    * - Bugfix
      - Fix an issue where THOR scans failed due to a perceived symlink loop in the scan path

THOR Version 10.7.5
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Add new ETL feature for parsing ETL files
    * - Feature
      - Add '--vtkey', '--vtmode', and '--vtaccepteula' flag for integration of VirusTotal in THOR
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
      - '--print-signatures' now silences the normal initialization output
    * - Change
      - Use mimalloc for YARA allocations on Linux and MacOS
    * - Change
      - Scanning network paths now requires a Lab license
    * - Bugfix
      - Reduce log level for corrupt /etc/passwd entries from Notice to Info
    * - Bugfix
      - Identify packed samples correctly with --customonly set

THOR Version 10.7.4
~~~~~~~~~~~~~~~~~~~

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
      - Added '--lowioprio' flag for lowered IO priority
    * - Change
      - Update to Golang v1.19.2
    * - Change
      - CPU limit now applies only to THOR's CPU usage, not the the complete system
    * - Change
      - Windows Access Groups (e.g. in file permissions) are now always displayed in English
    * - Change
      - Modified the scoring formula to further reduce the impact of multiple subscores on the full score. As compensation, the default threshold for alerts has been reduced.
    * - Bugfix
      - .lnk file processing with '--virtual-map' no longer causes link targets to be scanned without applying the virtual mapping
    * - Bugfix
      - Access faults while reading memory mapped files no longer cause THOR to crash
    * - Bugfix
      - Panics on opening an archive are now handled properly

THOR Version 10.7.3
~~~~~~~~~~~~~~~~~~~

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

THOR Version 10.7.2
~~~~~~~~~~~~~~~~~~~

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

THOR Version 10.7.1
~~~~~~~~~~~~~~~~~~~

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
      - '--max_file_size_intense' is now deprecated. Instead, '--max_file_size' should be used.
    * - Change
      - '--virtual-map' now supports mounts in subpaths on Windows, e.g. as '--virtual-map G:\mount:C'
    * - Change
      - Upgrade PE-Sieve to v0.3.3
    * - Change
      - Filescan progress report for folders without subfolders was improved

THOR Version 10.7.0
~~~~~~~~~~~~~~~~~~~

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
      - Support scanning alternate data streams with '--ads'
    * - Feature
      - Check environment variables of processes
    * - Change
      - THOR now terminates if a positional argument was specified since none are expected
    * - Fix
      - Scan files written to the Dropzone only once the write is complete (or does not continue for at least 1 second)

THOR 10.6 (Stable)
##################

THOR Version 10.6.21
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Add SIGTYPE fields to Sigma matches
    * - Feature
      - Add TYPE fields to reasons
    * - Change
      - Update to Golang v1.19.9
    * - Change
      - Terminate early when an invalid flag is used in the THOR template file
    * - Change
      - Report YARA matches in the DeepDive feature with reasons
    * - Change
      - Increase default YARA stack size to 32768
    * - Bugfix
      - Don't report filename matches on nonexisting files when resolving the file name from a reference using environment variables


THOR Version 10.6.20
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Add a warning when running on MacOS without full disk access
    * - Change
      - Update to Golang v1.19.5
    * - Bugfix
      - Improve trace output for decompressing EXE files
    * - Bugfix
      - Exclude MacOS directories used to for cloud storage unless '--alldrives' is specified
    * - Bugfix
      - Set rule date in '--print-signatures' output to modified date, if available
    * - Bugfix
      - Check if file is located remotely before trying to read file stats

THOR Version 10.6.19
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Change
      - Update to Golang v1.19.2
    * - Bugfix
      - Fixed an issue where scans were not properly resumed
    * - Bugfix
      - Fixed an issue that caused ASGARD to download THOR even if it was cached locally

THOR Version 10.6.18
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Change
      - Removed some exclusions where archives were not scanned

THOR Version 10.6.17
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Change
      - Errors now appear as the first section in HTML reports
    * - Change
      - Update to YARA v4.2.3
    * - Change
      - Update to Golang v1.18.5

THOR Version 10.6.16
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Show Office Connection Cache entries
    * - Change
      - Show informational message when downloading a license from Portal or ASGARD
    * - Change
      - Update to Golang v1.18.3
    * - Change
      - Update to YARA v4.2.1
    * - Change
      - Improved HTML report generation performance and HTML report UI
    * - Change
      - Registry YARA rules are now loaded on other platforms than Windows as well (for image scans)
    * - Bugfix
      - Added MATCHED_STRINGS field to filename IOC matches to improve visibility for complex IOCs
    * - Bugfix
      - Fixed an issue where Sigma rules could use a large amount of memory during initialization
    * - Bugfix
      - Fixed an issue where Linux services were incorrectly reported as group writable
    * - Bugfix
      - Corrected the signature type (custom or internal) for C2 IOC matches on memory

THOR Version 10.6.15
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Added a new 'diagnostics' command for THOR Util that collects information about a hanging or terminated THOR process
    * - Feature
      - Custom process exclude regexps can now be specified in 'config/process-excludes.cfg'
    * - Bugfix
      - Log messages about suspicious services are now correctly logged as belonging to the 'ServiceCheck' module
    * - Bugfix
      - Process excludes are now handled more stringently, and accesses on excluded processes are less intrusive
    * - Bugfix
      - Scan end time no longer sometimes misses from the HTML report
    * - Change
      - Matches from deprecated sigma rules are no longer shown
    * - Change
      - Upgrade of the sigma matching engine from v1 to v2
    * - Change
      - Update to Golang v1.17.9
    * - Change
      - Update to PE-Sieve v0.3.3
    * - Change
      - Default maximum file size increased to 30 MB (200 MB for intense mode)

THOR Version 10.6.14
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Bugfix
      - The Bifrost 2 server option is again available in ASGARD

THOR Version 10.6.13
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Bugfix
      - Some YARA rules were not applied correctly on unpacked files
    * - Bugfix
      - Catch panics that could occur when unpacking certain RAR files
    * - Bugfix
      - THOR no longer attempts to access files that are not local (e.g. OneDrive files) when they are referenced from elsewhere unless '--alldrives' is used

THOR Version 10.6.12
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Executing 32 bit THOR on a 64 bit Windows system now causes a warning
    * - Feature
      - Hash IOCs may now have an optional score (default is 100, as before)
    * - Change
      - Disable RarVM support
    * - Change
      - Change colors for some log levels to improve readability in specific terminals
    * - Change
      - THOR Util can no longer download licenses from ASGARD, use THOR instead
    * - Change
      - THOR now terminates if the internal signatures can't be loaded
    * - Change
      - Intrusive process actions that require process memory access are now skipped on excluded processes
    * - Change
      - THOR Lite Util no longer supports '--force' for upgrades and updates
    * - Change
      - Update to Golang v1.16.13
    * - Bugfix
      - Process dumps are now created with secure access rights

THOR Version 10.6.11
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Feature
      - Support Apple M1
    * - Feature
      - Save resume state on system shutdown or logoff
    * - Change
      - Upgrade PE-Sieve to v0.3.1
    * - Change
      - Upgrade OpenSSL to v1.1.1l

THOR Version 10.6.10
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Update to Golang v1.16.7
    * - Bugfix
      - Show process details for PPL processes correctly

THOR Version 10.6.9
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Print rule authors for YARA rule matches
    * - Feature
      - Check environment variables for other processes
    * - Feature
      - Use Administrator rights on Windows, if available
    * - Change
      - Upgrade PE-Sieve to v0.3.0
    * - Fix
      - Handle UTF-16 output in string matches better
    * - Fix
      - Improve progress estimation for Eventlog module
    * - Fix
      - Skip non-local files on Windows (from e.g. OneDrive) unless '--alldrives' is set

THOR Version 10.6.8
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Analyze ETW logs in the background for CobaltStrike beacon characteristics. This can be disabled with '--noetwwatcher'.
    * - Feature
      - Check IP forwarding on Linux as part of the Firewall module.
    * - Feature
      - Analyze authorized_keys files that are found. This feature can be disabled with '--noauthorizedkeys'.
    * - Feature
      - Support metadata YARA rules which are applied to all files, but can only access the first 100 bytes of the file. These files must contain the "meta" word in their filename. If a Metadata YARA rule with the DEEPSCAN tag matches, a full YARA scan on the file will be triggered.
    * - Feature
      - Add the "group" external variable to YARA rules for non-Windows scans.
    * - Change
      - Upgrade YARA to v4.1.1
    * - Change
      - Print more timestamps for deep dive targets
    * - Change
      - Disable global YARA rules since they could impact THOR's internal rules
    * - Fix
      - Handle a bug where THOR froze when calculating the hash of a file opened via the MFT

THOR Version 10.6.7
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Apply cross platform IOCs correctly if '--lab' is set
    * - Bugfix
      - Don't scan specific files twice if '--lab' is set

THOR Version 10.6.6
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Upstream
      - Merge current changes from THOR Version 10.5.16
    * - Feature
      - Scanning for symlinks and irregular files with Filename IOCs
    * - Feature
      - YARA Meta rules (filename needs to contain the word meta) which are applied on all files, but which only can access the first 100 Bytes of the file
    * - Feature
      - Improve Scheduled Task parsing and give a notice if a task's binary does not exist
    * - Feature
      - Parse Cobalt Strike beacon configurations and return basic information about them
    * - Feature
      - New command line option '--allfiles' that includes file types and locations that are usually not interesting. This is a subset of what '--intense' does.
    * - Change
      - Upgrade PE-Sieve to v0.2.9.6
    * - Change
      - Disable quick edit mode for a Windows console while THOR is running in it
    * - Change
      - Update to Golang 1.15.11
    * - Bugfix
      - Fix some issues with using THOR Util templates

THOR Version 10.6.5
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Upstream
      - Merge changes from THOR Version 10.5.15
    * - Change
      - Multithreading and virtual mapping have been restricted to Forensic Lab and Incident Response license types
    * - Change
      - THOR TechPreview packages now contain a THOR Util configuration file to default to the TechPreview on upgrades.

THOR 10.5 (Legacy)
##################

THOR Version 10.5.18
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Remove outdated content from the tools folder in THOR packages
    * - Bugfix
      - Exclude THOR logs from being detected by THOR

THOR Version 10.5.17
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Authors of YARA rules are now included in match outputs
    * - Change
      - Update PE-Sieve to v0.2.9.6
    * - Change
      - Global YARA rules now cause an error since they can inadvertently affect THOR's internal signatures
    * - Change
      - Some modules were removed on specific platforms (especially on MacOS and AIX) that only held dummy
    * - Change
      - Add EVTX 3.2 support
    * - Bugfix
      - Print Eventlog timestamps in local timezone, unless '--utc' is used

THOR Version 10.5.16
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Upgrade PE-Sieve to v0.2.9.5
    * - Change
      - Upgrade OpenSSL to 1.1.1j
    * - Bugfix
      - Ensure THOR honors low CPU limits correctly
    * - Bugfix
      - Correct loading for some named pipe IOC files
    * - Bugfix
      - Incorrect formatting for JSON syslog output

THOR Version 10.5.15
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Add support for a THOR Util configuration file. This file allows setting a default configuration (e.g. to always upgrade to the TechPreview).
    * - Change
      - Notarize THOR for MacOS

THOR Version 10.5.14
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Scan all event logs if '--intense' was specified
    * - Feature
      - Allow fetching the signatures in development by using '--sigdev' with thor-util update
    * - Change
      - Add version info resource to THOR Windows files
    * - Change
      - Refactor bulk scanning to have less memory allocated / released to reduce memory usage volatility
    * - Change
      - Let THOR Util default to its own directory for THOR and license paths (same behaviour as THOR already has)
    * - Change
      - Check YARA / IOC filename indicators (like log, registry, keyword) with word boundaries
    * - Change
      - Add additional event logs to list scanned by default
    * - Change
      - Don't allow a downgrade in THOR Util unless '--force' is specified
    * - Change
      - Update to Golang 1.15.10
    * - Change
      - Specific options (dropzone mode, deep dive mode, fsonly, nodoublecheck, hostname rewrite) have been restricted to Forensic Lab and Incident Response license types
    * - Bugfix
      - Add checks for improved handling of corrupted registry hives
    * - Bugfix
      - Clarify some messages of THOR Util
    * - Bugfix
      - Apply excludes with OS path separators with '--cross-platform'

THOR Version 10.5.13
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Minor directory exclusion adjustments for Microsoft Exchange

THOR Version 10.5.12
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Remove some directory excludes specific to Microsoft Exchange

THOR Version 10.5.11
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Make bulk scan size manually configurable with '--bulk-size'
    * - Change
      - Disable 60 MB log size limit if debugging (with '--debug' or '--trace') is active

THOR Version 10.5.10
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Suppress rule matches on log files after the same rule matched 10 times or more, this can be deactivated with '--showall'
    * - Feature
      - Add a context menu for filtering to the HTML reports
    * - Feature
      - Add support for NFTables firewalls on Linux
    * - Feature
      - Add a field 'SIGTYPE' to messages which displays whether an IOC or YARA rule is custom or built-in
    * - Feature
      - Reuse previous Scan ID if a scan is resumed
    * - Feature
      - Add additional information to files detected in a Windows recycle bin (original file name, deletion time)
    * - Change
      - Limit file enrichment to 10 files per message
    * - Change
      - Name automatically generated YARA rules for C2 domains after the domain rather than after a counter
    * - Change
      - Reduce score of a C2 match with a YARA rule by 30
    * - Change
      - Upgrade to YARA 4.0.5
    * - Change
      - Make matching of C2 IOCs on process memory optional, it can be enabled with '--c2-in-memory'
    * - Bugfix
      - Deduplicate listen ports per process
    * - Bugfix
      - Improve permission vulnerability check for Linux services
    * - Bugfix
      - Skip specific registry hives where THOR could behave unstable

THOR Version 10.5.9
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Apply C2 checks to log scans
    * - Change
      - Increase the default maximum runtime to 1 week
    * - Change
      - Apply special scan features on files even if those files exceed the maximum file size set
    * - Bugfix
      - Remove several false positives on process memory of Antivirus products
    * - Bugfix
      - Fix an issue where THOR Remote could freeze if too many remote scans were started
    * - Bugfix
      - Fix an issue where packed files weren't unpacked completely before being scanned

THOR Version 10.5.8
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Print time of currently analyzed event in Eventlog module

THOR Version 10.5.7
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Upgrade to Golang 1.14.7
    * - Change
      - Catch Panics in a Module to leave other modules unaffected
    * - Change
      - Disable support for licenses using an obsolete encryption method
    * - Bugfix
      - Extend output in a specific Events module message
    * - Bugfix
      - New parameter '--max_process_size' that limits the size of processes that THOR scans with YARA rules. Default value is 500 MB. THOR memory usage increases as this value is increased.

THOR Version 10.5.6
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Catch possible panic during Amcache parsing
    * - Bugfix
      - Catch possible panic if the Application Eventlog could not be opened

THOR Version 10.5.5
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Exchange signing certificate for newer version
    * - Bugfix
      - Check Registry Hive entries in the same format as Live Registry entries
    * - Bugfix
      - Check UserData elements in EVTX files

THOR Version 10.5.4
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Support download of Tech Preview versions in Thor-Util
    * - Feature
      - Support license download from ASGARD 2.5+ with '--asgard-token'
    * - Bugfix
      - Terminate if started with '--resumeonly' and no previous scan with the same context existed
    * - Bugfix
      - Calculate the context that '--resume' used to check for previous scans differently, excluding elements prone to change

THOR Version 10.5.3
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Catch Panic when handling specific Registry Hives on disk.

THOR Version 10.5.2
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Disable PE-Sieve by default to follow up on some rare issues. It can be enabled with '--process-integrity' or '--intense'.

THOR Version 10.5.1
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Generate process dumps of suspicious processes (for now Windows only) when '--procdumps' is specified
    * - Feature
      - New command line option '--procdump-dir' to control where process dumps are stored
    * - Feature
      - Integrate parser for Windows LNK files
    * - Feature
      - New command line option '--image-chunk-size' to set the size of chunks when scanning image files
    * - Feature
      - New command line option '--generate-config' to create a configuration file for THOR based on command line options
    * - Feature
      - Open busy registry hives using a raw disk image and the MFT
    * - Feature
      - On interactive interrupts, show progress and a menu to continue or abort the scan
    * - Feature
      - Support new IOC file for named pipes on Windows
    * - Feature
      - Detect files with uncommon / unlikely timestamps (timestomping)
    * - Change
      - Reduce log level for open port messages to Info
    * - Change
      - Extend '--all-module-lookback' to Registry Hive files and EVTX log files, rename it to '--global-lookback'
    * - Change
      - Update used YARA version to 4.0.1
    * - Change
      - Print last scanned element when maximum runtime is exceeded
    * - Bugfix
      - Don't stop HTML log generation on encountering certain uncommon log lines


THOR Version 10.5.0
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New PowerShell script to download and run Thor easily
    * - Feature
      - Execute PE-Sieve at runtime to discover processes with malicious sections, sensitivity can be raised further with '--full-proc-integrity'
    * - Feature
      - New command line option '--scanid-prefix' to set a custom Scan ID prefix
    * - Feature
      - New command line option '--print-signatures' to print metadata to all YARA and Sigma signatures
    * - Feature
      - New command line option '--all-module-lookback' that applies lookback to the Filesystem, Registry, and Services modules as well
    * - Feature
      - Make score for Handle IOCs customizable
    * - Feature
      - New command line option '--ascii' to exclude non-ASCII characters from the logs
    * - Change
      - Check open files without using an external 'lsof' executable on Unix platforms
    * - Change
      - Update descriptions for most command line options
    * - Change
      - Print non-ASCII strings in matches as hex sequences
    * - Change
      - Include time (in addition to the date) in default log file name

THOR 10.4
#########


THOR Version 10.4.2
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Store resume information only if '--resume' is set to improve performance
    * - Feature
      - New command line option '--portal-key' to download a license at start time
    * - Feature
      - New command line option '--yara-max-strings-per-rule' to increase the supported number of IOCs
    * - Feature
      - New command line option '--nofserrors' to suppress filesystem errors
    * - Feature
      - Print integrated revision of the sigma rules at startup
    * - Feature
      - Include Scan ID in HTML report synopsis
    * - Change
      - Apply suspicious locations platform independently
    * - Bugfix
      - Don't stop HTML log generation on encountering certain uncommon log lines
    * - Bugfix
      - Remove anonymization on non-personal accounts like Default
    * - Bugfix
      - Apply Signatures for Windows Handles more precisely
    * - Bugfix
      - Remove a False Positive that could occur in the DNS cache
    * - Bugfix
      - Increase the supported number of IOCs massively beyond the default 10000.
    * - Bugfix
      - Fix a panic related to incorrectly formatted /etc/passwd files on Linux.

THOR Version 10.4.1
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Filescan panic on WER (Windows Error Report) files

THOR Version 10.4.0
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Added Bifrost 2 gRPC support for upcoming ASGARD 2
    * - Feature
      - EmoCheck in FileScan module
    * - Feature
      - TeamViewer password detection and decryption

THOR 10.3
#########

THOR Version 10.3.1
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Files mentioned in Archivescan do not show up in CSV export

THOR Version 10.3.0
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Iterate over process handles (files, events, mutants) natively without external tools
    * - Feature
      - Automatically set a random Scan ID that will be added to each log line
    * - Feature
      - Log to local syslog with '--local-syslog' (Linux and macOS only)
    * - Feature
      - SHIMCache entries will be scanned in Registry Hive files, too
    * - Feature
      - Do not skip registry paths with low relevance by using '--fullregistry' or '--intense'
    * - Feature
      - New license type 'Silent' for rollout / deployment testing
    * - Feature
      - Cross-platform filename IOCs in '--fsonly' mode (or with flag '--cross-platform')
    * - Feature
      - New exclude configurations 'registry-excludes.cfg' and 'eventlog-excludes.cfg'
    * - Feature
      - Enrich process information for event and mutant handles
    * - Feature
      - Apply regexes on event and mutant handles
    * - Feature
      - Added few more eventlog targets
    * - Feature
      - New flag '--process <pid>' to scan a specific process
    * - Change
      - Added comment to users' last logon date
    * - Change
      - Enrich file information in process check output
    * - Change
      - New flag '--max_file_size_intense' to set max file size for intense mode separately
    * - Change
      - Removed flag '--buffer_size'. THOR's buffer will now be as big as '--max_file_size'
    * - Change
      - Added YARA rules' date to match output
    * - Change
      - Upgraded THOR Util to 1.9.8
    * - Change
      - Wordings in flag descriptions
    * - Change
      - Duplicates in IOCs will be filtered automatically
    * - Bugfix
      - '-j <hostname>' will also rewrite names of THOR's logfiles
    * - Bugfix
      - Fixed sporadically missing start- and endtime in html report
    * - Bugfix
      - Fixed off-by-one error for '--maxloglines' flag
    * - Bugfix
      - Skip directory junctions when scanning remotely mounted windows ntfs partitions
    * - Bugfix
      - Fixed interaction of relevant file extensions and some file types

THOR 10.2
#########

THOR Version 10.2.11
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Sigma modifiers "startswith" and "endswith" are now supported

THOR Version 10.2.10
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Empty values for "(Default)" keys names in Registry matching

THOR Version 10.2.9
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Removed legacy files (sfx, bat)
    * - Change
      - Removed fix skip of "SOFTWARE\Classes" Registry key
    * - Bugfix
      - custom IOC initialization used different keywords than described in documentation ("c2" > "domain", "trusted" > "falsepositive")

THOR Version 10.2.8
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Increased default max. file size from 4.5 MB to 6.5 MB
    * - Bugfix
      - Fixed a bug in sigma scoring system

THOR Version 10.2.7
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Dropped max filesize check for many types in intense scan mode (--intense / --fsonly) including memory dumps, registry hives, EVTX files
    * - Change
      - Added PKZIP and MS Office PK header to headers eligible for archive scan
    * - Change
      - Added file name, file path, hostname and channel to matches on events found in EVTX files

THOR Version 10.2.6
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Improvements to MESSAGE field (better descriptions)

THOR Version 10.2.5
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - List available modules if selected module is unknown
    * - Change
      - Increased log window size for thor events in thor remote
    * - Change
      - Print reasons for invalid licenses
    * - Change
      - Sigma rules will be muted if they matched too often
    * - Change
      - Event IOCs will be applied on Mutex checks and vice versa

THOR Version 10.2.4
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fixed logic error in lsasessions' kerberos ticket life time checks

THOR Version 10.2.3
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Removed THOR Remote warning that a file could not be collected, which doesn't exist
    * - Change
      - Low sigma rules will not be printed anymore, medium sigma rules will only be printed in '--intense' mode

THOR Version 10.2.2
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New module 'Events' that checks for malicious Windows events

THOR Version 10.2.1
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New ThorDB table 'stats', which contains scan duration of scan elements
    * - Feature
      - New output mode '--reduced' to reduce output to warnings, alerts and errors
    * - Change
      - Files can be scanned multiple times in Dropzone mode

THOR Version 10.2.0
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Upgraded YARA to 3.11.0
    * - Change
      - Extended output of '--version' command
    * - Change
      - Added ExecFlag to SHIMCache output
    * - Change
      - Apply YARA on WMI Event Filters
    * - Change
      - Passing new external YARA variables 'timezone' and 'language' to registry ruleset

THOR 10.1
#########


THOR Version 10.1.9
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Made YARA more robust - YARA rules will now compile even if there is a duplicate identifier
    * - Change
      - Made Sigma more robust - Sigma rules will now compile even if a rule is corrupt
    * - Change
      - Removed challenge-response for trial licenses that are host-based
    * - Change
      - Updated file types that will trigger a warning if cloaked 

THOR Version 10.1.8
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Reverting case-insensitive filename IOC checking
    * - Docs
      - New manual (fixed broken references)

THOR Version 10.1.7
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Crash reports are not truncated anymore
    * - Bugfix
      - Improved stability of ScheduledTasks module

THOR Version 10.1.6
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Improved Sigma initialization
    * - Change
      - Improved THOR Lite initialization

THOR Version 10.1.5
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - THOR Lite (replaces SPARK Core)

THOR Version 10.1.4
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Add ``https://`` protocol to '--bifrost2Server' if missing

THOR Version 10.1.3
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New flag '--bifrost2Ignore <pattern>' to specify ignore patterns for Bifrost 2

THOR Version 10.1.2
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Wordings in '--help' section
    * - Bugfix
      - Fixed THOR crash when scanning corrupt EVTX file

THOR Version 10.1.1
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - New flags '--ca <path>' and '--insecure' for tls host verification
    * - Feature
      - HTTP proxy support for Bifrost 2 and license generation with ASGARD

THOR Version 10.1.0
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - THOR Remote for Windows
    * - Feature
      - Bifrost 2
    * - Feature
      - Sigma value modifiers (contains, base64, re, ...)
    * - Bugfix
      - Fixed file descriptor leak in PE imphash calculation
    * - Bugfix
      - Fixed "has admin rights" output when running with different EUID
    * - Bugfix
      - Wrong eventtime in WER module output

THOR 10.0
#########

THOR Version 10.0.14
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Ignore filepaths of archives when scanning the contents with YARA

THOR Version 10.0.13
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fixes in exclusions and firewall indicator regex filters

THOR Version 10.0.12
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fixed obfuscated exclusion and apt presets

THOR Version 10.0.11
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - ZEUS port detection regex adjusted

THOR Version 10.0.10
~~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - More process excludes (OneDrive issue)

THOR Version 10.0.9
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Adjusted process excludes list (Windows Defender, OneDrive)

THOR Version 10.0.8
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Adjusted suspicious locations to avoid some SHIMCache false positives

THOR Version 10.0.7
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Eventlog module deactivation disfunctional (--noeventlog, --quick)

THOR Version 10.0.6
~~~~~~~~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Feature
      - Linux and MacOS support
    * - Feature
      - Scan eventlog and logfiles with Sigma
    * - Feature
      - STIX v2 in various checks and modules
    * - Feature
      - Log to JSON file, send JSON via UDP/TCP
    * - Feature
      - Scan templates '-t <template-file>' that holds preset command line arguments
    * - Feature
      - Get license from ASGARD with '--asgard <host>'
    * - Change
      - Update signatures with `thor-util update`
    * - Change
      - Upgrade scanner with `thor-util upgrade`
    * - Change
      - Changed programming language from Python to Golang
    * - Change
      - Configure actions with command line arguments '--action-command <cmd>', '--action-args <argN>' and '--action-level <level>'
    * - Change
      - Encrypt (RSA) scan results with '--encrypt', use custom key (or key file) with '--pubkey <key|file>'
    * - Change
      - Removed obsolete 'thor-upgrade.exe' tool
    * - Change
      - THOR doesn't require SYSINTERNALS 'autorunsc.exe' in tools directory anymore
    * - Change
      - Removed obsolete fast mode '--fast'
    * - Change
      - Command line arguments with multiple values can not be appended anymore, they require a key in front of each value
    * -      
      - Example: '-p <path1> -p <path2> ... -p <pathN>' instead of '-p <path1> <path2> ... <pathN>'
    * - Change
      - Short command line arguments with more than one character were removed. E.g. '-em <days>', use '--lookback <days>' instead
    * - Change
      - Removed log caching in ThorDB
