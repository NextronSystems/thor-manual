Changelog
=========

THOR 10.6 is currently still supported, but we advise customers to switch
to the newest productive version, `10.7 <https://thor-manual.nextron-systems.com>`_.
We will stop supporting 10.6 in the near future.

THOR 10.6.26
~~~~~~~~~~~~

.. list-table::
	  :header-rows: 1
	  :widths: 15, 85

	  * - Type
	    - Description
	  * - Bugfix
	    - Fix an issue where Emotet IOC matches could cause a panic

THOR 10.6.25
~~~~~~~~~~~~

.. list-table::
	  :header-rows: 1
	  :widths: 15, 85

	  * - Type
	    - Description
	  * - Bugfix
	    - Fix an issue where Emotet IOC matches could cause a panic

THOR 10.6.24
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fix an issue where ``--lowprio`` and ``--verylowprio`` were not working correctly on Linux

THOR 10.6.23
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Fix an issue where unicode characters in file names could cause panics
    * - Bugfix
      - Fix an issue where corrupt archive files could cause panics
    * - Bugfix
      - Fix an issue where the 32-bit version of THOR for Linux crashed when loading the signatures
    * - Bugfix
      - Fix an issue where the NetworkShares module incorrectly reported an error

THOR 10.6.22
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - SFX RAR executables are now extracted using the Archive feature instead of the ExeDecompress feature, which allows access to the filenames within the archive
    * - Change
      - Remove action feature due to potential abusability.
    * - Change
      - Update to Golang v1.20.8
    * - Change
      - Update to OpenSSL v1.1.1w
    * - Change
      - Update to YARA v4.3.2
    * - Bugfix
      - Fix an issue where registry values with new lines could lead to messages missing information about the registry key

THOR 10.6.21
~~~~~~~~~~~~

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


THOR 10.6.20
~~~~~~~~~~~~

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

THOR 10.6.19
~~~~~~~~~~~~

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

THOR 10.6.18
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Change
      - Removed some exclusions where archives were not scanned

THOR 10.6.17
~~~~~~~~~~~~

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

THOR 10.6.16
~~~~~~~~~~~~

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

THOR 10.6.15
~~~~~~~~~~~~

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

THOR 10.6.14
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description 
    * - Bugfix
      - The Bifrost 2 server option is again available in ASGARD

THOR 10.6.13
~~~~~~~~~~~~

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

THOR 10.6.12
~~~~~~~~~~~~

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

THOR 10.6.11
~~~~~~~~~~~~

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

THOR 10.6.10
~~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Change
      - Update to Golang v1.16.7
    * - Bugfix
      - Show process details for PPL processes correctly

THOR 10.6.9
~~~~~~~~~~~

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

THOR 10.6.8
~~~~~~~~~~~

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

THOR 10.6.7
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Bugfix
      - Apply cross platform IOCs correctly if '--lab' is set
    * - Bugfix
      - Don't scan specific files twice if '--lab' is set

THOR 10.6.6
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Upstream
      - Merge current changes from THOR 10.5.16
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

THOR 10.6.5
~~~~~~~~~~~

.. list-table::
    :header-rows: 1
    :widths: 15, 85

    * - Type
      - Description
    * - Upstream
      - Merge changes from THOR 10.5.15
    * - Change
      - Multithreading and virtual mapping have been restricted to Forensic Lab and Incident Response license types
    * - Change
      - THOR TechPreview packages now contain a THOR Util configuration file to default to the TechPreview on upgrades.

