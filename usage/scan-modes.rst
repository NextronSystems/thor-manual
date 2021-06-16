
Scan Modes
==========

You can select between 6 different scan modes in THOR:

* | **Default**
  | We recommend using the default scan mode for all sweeping activity. Scans take from 1 to 6 hours depending on the partition size and number of interesting files.
  | In default mode, THOR automatically choses "Soft" mode if the system has only limited CPU and RAM resources.
  | There's a special "Lab Scanning" (**--lab**) method described in section 9.1 that disables many limitations and allows to scan mounted images in a Lab scenario, even with multiple THOR instances on a single Workstation.

-  | **Quick (--quick)**
   | This mode is the fastest one and oriented on the "Pareto Principe", covering 80% of the modules and check in 20% of the normal scan time. In "quick" mode, THOR skips elements that have not been created or modified within the last 2 days in the "Eventlog", “Registry” and "Filescan" modules. A set of 40+ directories will still be checked completely (e.g. AppData, Recycler, System32). "Quick" mode is known to be the "preventive" scan mode – less intense and very fast.

Themed scan modes:

* | **Soft (--soft / force disable with --nosoft)**
  | This mode disables all modules and checks that could be risky for system stability.
  | It is automatically activated on (more details in :ref:`chapter Automatic Soft Mode <usage/other-topics:Automatic Soft Mode>`):
  | - Systems with only a single CPU core
  | - Systems with less than 1024 MB of RAM

* | **Lab Scan (--lab)**
  | This mode scan only the filesystem and disable all other modules. (see :doc:`chapter Special Scan Modes <./special-scan-modes>` for more details and flags used in this scan mode)
  | Example: **./thor64 --lab -p /mnt/image\_c/**

* | **Intense (--intense)**
  | This mode is meant for system scanning in a non-productive or lab environment. It disables several speed optimizations and enables time-consuming extra checks for best detection results.

* | **Difference (--diff)**
  | The Diff Mode looks for a last scan and last finished modules in the local THOR DB and scans only elements on disk that have been changed or created since the last scan start. This mode applies short-cuts to the “Filesystem”, “Eventlog” and “Registry” modules. Diff scans are typically the shortest scans but require a completed previous scan. This scan mode is also susceptible to the so-called “Timestomping”.


The following tables give an overview on the active modules and features
in the different scan modes. The ‘modules’ section lists all available
modules, whereas the ‘features’ section lists only features that are
handled differently in the different scan modes.

Modules
-------------------
OS Module Overview
^^^^^^^^^^^^^^^^^^

.. raw:: html

        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script>
        $(document).ready(function() {
        $('table p:contains("Supported")').not(':contains("Not")').parent().addClass('enabled');
        $('table p:contains("Not Supported")').parent().addClass('disabled');
        $('table p:contains("Reduced")').parent().addClass('reduced');
        $('table p:contains("Enabled")').parent().addClass('enabled');
        $('table p:contains("Disabled")').parent().addClass('disabled');
        });
        </script>
        <style>
        .reduced {background-color:#cccccc !important;}
        .disabled {background-color:#888888 !important;}
        </style>

+-----------------------------+------------------+----------------+----------------+
| Module                      | Windows          | Linux          | MacOS          |
+=============================+==================+================+================+
| File System Scan            | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Registry Scan               | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| SHIM Cache Scan             | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Mutex Check                 | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Named Pipes Check           | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| DNS Cache Check             | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Hotfix Check                | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Hosts File Check            | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Firewall Config Check       | Supported        | Supported      | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Network Share Check         | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Logged In Check             | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Process Check               | Supported        | Supported\*    | Supported\*    |
+-----------------------------+------------------+----------------+----------------+
| Service Check               | Supported        | Supported      | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Autoruns Check              | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Rootkit Check               | Supported        | Supported      | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| LSA Sessions Analysis       | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| User Account Check          | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| User Profile Check          | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Network Sessions Check      | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Scheduled Tasks Analysis    | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| WMI Startup Check           | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| At Entries Check            | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| MFT Analysis                | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Eventlog Analysis           | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| KnowledgeDB Check           | Not Supported    | Not Supported  | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Environment Variables Check | Supported        | Supported      | Supported      |
+-----------------------------+------------------+----------------+----------------+
| Crontab Check               | Not Supported    | Supported      | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Integrity Check             | Not Supported    | Supported      | Not Supported  |
+-----------------------------+------------------+----------------+----------------+
| Event Check                 | Supported        | Not Supported  | Not Supported  |
+-----------------------------+------------------+----------------+----------------+

\* = No process memory scan with YARA rules

Scan Mode Overview
^^^^^^^^^^^^^^^^^^
+-----------------------------+------------+------------+------------+-----------+
| Module                      | Normal     | Quick      | Soft       | Intense   |
+=============================+============+============+============+===========+
| File System Scan            |            | Reduced    |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Registry Scan               |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| SHIM Cache Scan             |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Mutex Check                 |            |            | Disabled   |           |
+-----------------------------+------------+------------+------------+-----------+
| Named Pipes Check           |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| DNS Cache Check             |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Hotfix Check                |            | Disabled   |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Hosts File Check            |            |            | Disabled   |           |
+-----------------------------+------------+------------+------------+-----------+
| Firewall Config Check       |            | Disabled   | Disabled   |           |
+-----------------------------+------------+------------+------------+-----------+
| Network Share Check         |            |            | Disabled   |           |
+-----------------------------+------------+------------+------------+-----------+
| Logged In Check             | Enabled*   |            | Disabled   |           |
+-----------------------------+------------+------------+------------+-----------+
| Process Check               |            |            | Reduced\*\*|           |
+-----------------------------+------------+------------+------------+-----------+
| Service Check               |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Autoruns Check              |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Rootkit Check               |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| LSA Sessions Analysis       |            |            | Disabled   |           |
+-----------------------------+------------+------------+------------+-----------+
| User Account Check          | Enabled*   |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| User Profile Check          | Enabled*   | Disabled   |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Network Sessions Check      | Enabled*   |            | Disabled   |           |
+-----------------------------+------------+------------+------------+-----------+
| Scheduled Tasks Analysis    |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| WMI Startup Check           |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| At Entries Check            |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| MFT Analysis                | Disabled   | Disabled   | Disabled   | Enabled   |
+-----------------------------+------------+------------+------------+-----------+
| Eventlog Analysis           |            | Disabled   |            |           |
+-----------------------------+------------+------------+------------+-----------+
| KnowledgeDB Check           |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Environment Variables Check |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Crontab Check               |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Integrity Check             |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+
| Event Check                 |            |            |            |           |
+-----------------------------+------------+------------+------------+-----------+

| \* = Disabled on Domain Controllers
| \*\* = No process memory scan with YARA rules

Features
--------

Feature Scan Mode Overview
^^^^^^^^^^^^^^^^^^^^^^^^^^

+--------------------------------+------------+------------+------------+-------------+
| Feature                        | Normal     |   Quick    |   Soft     |   Intense   |
+================================+============+============+============+=============+
| Sigma Scan                     | Disabled   | Disabled   | Disabled   | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| EXE Decompression              | Enabled\*\*| Enabled    | Disabled   | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Archive Scan                   | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Double Pulsar Check            | Enabled\*\*| Enabled    | Disabled   | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Groups XML Analysis            | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Vulnerability Check            | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Web Server Dir Scan            | Enabled    | Disabled   | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| WMI Persistence                | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Registry Hive Scan             | Enabled*   | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| AmCache Analysis               | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Process Handle Check           | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Process Connections Check      | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Windows Error Report (WER)     | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Windows At Job File Analysis   | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| EVTX File Scanning             | Enabled    | Disabled   | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Prefetch Library Scanning      | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Memory Dump DeepDive           | Disabled   | Disabled   | Disabled   | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Text Log File Scanning         | Enabled    | Disabled   | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Shellbag Entry Analysis        | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Authorized Key File Analysis   | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Bifrost File Upload            | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Malicious Domain Check         | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| File Scan                      | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Cobalt Strike Beacon Parsing   | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+
| Process Integrity Check        | Disabled   | Disabled   | Disabled   | Enabled\*\* |
+--------------------------------+------------+------------+------------+-------------+
| SHIM Cache Analysis            | Enabled    | Enabled    | Enabled    | Enabled     |
+--------------------------------+------------+------------+------------+-------------+

| \* = Disabled on Domain Controllers
| \*\* = Only supported on Windows

Feature caller list
^^^^^^^^^^^^^^^^^^^

The following table gives an overview of THORs features and
how they are called by the different modules and other features.

+--------------------------------+--------------------------------+
| Feature                        | Callers                        |
+================================+================================+
| Sigma Scan                     | Eventlog, Log file scanning    |
+--------------------------------+--------------------------------+
| EXE Decompression              | File Scan                      |
+--------------------------------+--------------------------------+
| Archive Scan                   | File Scan                      |
+--------------------------------+--------------------------------+
| Double Pulsar Check            | Rootkit Check                  |
+--------------------------------+--------------------------------+
| Groups XML Analysis            | File Scan                      |
+--------------------------------+--------------------------------+
| Vulnerability Check            | File Scan                      |
+--------------------------------+--------------------------------+
| Web Server Dir Scan            | Process Check                  |
+--------------------------------+--------------------------------+
| WMI Persistence                | File Scan                      |
+--------------------------------+--------------------------------+
| Registry Hive Scan             | File Scan                      |
+--------------------------------+--------------------------------+
| AmCache Analysis               | File Scan                      |
+--------------------------------+--------------------------------+
| Process Handle Check           | Process Check                  |
+--------------------------------+--------------------------------+
| Process Memory Check           | Process Check                  |
+--------------------------------+--------------------------------+
| Process Connections Check      | Process Check                  |
+--------------------------------+--------------------------------+
| Windows Error Report (WER)     | File Scan                      |
+--------------------------------+--------------------------------+
| Windows At Job File Analysis   | File Scan                      |
+--------------------------------+--------------------------------+
| EVTX File Scanning             | File Scan                      |
+--------------------------------+--------------------------------+
| Prefetch Library Scanning      | File Scan                      |
+--------------------------------+--------------------------------+
| Memory Dump DeepDive           | File Scan                      |
+--------------------------------+--------------------------------+
| Text Log File Scanning         | File Scan                      |
+--------------------------------+--------------------------------+
| Shellbag Entry Analysis        | Registry Hive Scan             |
+--------------------------------+--------------------------------+
| Authorized Key File Analysis   | File Scan                      |
+--------------------------------+--------------------------------+
| Bifrost File Upload            | File Scan                      |
+--------------------------------+--------------------------------+
| Malicious Domain Check         | File Scan                      |
+--------------------------------+--------------------------------+
| File Scan                      | Most modules and features      |
+--------------------------------+--------------------------------+
| Cobalt Strike Beacon Parsing   | File Scan, Process Check       |
+--------------------------------+--------------------------------+
| Process Integrity Check        | Process Check                  |
+--------------------------------+--------------------------------+
| SHIM Cache Analysis            | SHIM Cache Scan, Registry Hive |
+--------------------------------+--------------------------------+
