
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
  | It is automatically activated on (more details in chapter 19.1 Automatic Soft Mode):
  | - Systems with only a single CPU core
  | - Systems with less than 1024 MB of RAM

* | **Lab Scan (--lab)**
  | This mode scan only the filesystem and disable all other modules. (see the dedicated chapter 9.1 for more details and flags used in this can mode)
  | Example: **./thor64 --lab -p /mnt/image\_c/**

* | **Intense (--intense)**
  | This mode is meant for system scanning in a non-productive or lab environment. It disables several speed optimizations and enables time-consuming extra checks for best detection results.

* | **Difference (--diff)**
  | The Diff Mode looks for a last scan and last finished modules in the local THOR DB and scans only elements on disk that have been changed or created since the last scan start. This mode applies short-cuts to the “Filesystem”, “Eventlog” and “Registry” modules. Diff scans are typically the shortest scans but require a completed previous scan. This scan mode is also susceptible to the so-called “Timestomping”.

Scan Modes Overview
-------------------

The following tables give an overview on the active modules and features
in the different scan modes. The ‘modules’ section lists all available
modules, whereas the ‘features’ section lists only features that are
handled differently in the different scan modes.

Modules
^^^^^^^
X = Disabled

+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | Module                    | | Default  | | Quick    | | Soft     | | Intense | | Domain    	       | | Linux /       |
|			      |            |		|	     |           | | Controller        | | macOS         |
+=============================+============+============+============+===========+=====================+=================+
| File System Scan            | Enabled    | Reduced    | Enabled    | Enabled   | --                  | Enabled         |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | Registry Scan             | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
| | (Full Walk)	              |		   |		|	     |		 |		       |		 | 
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Run Key Analysis            | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| SHIM Cache Scan             | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Mutex Check                 | Enabled    | Enabled    | X          | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Named Pipes Check           | Enabled    | Enabled    | X          | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| DNS Cache Check             | Enabled    | Enabled    | Enabled    | Enabled   | --                  | Enabled         |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Hotfix Check                | Enabled    | X          | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Hosts File Check            | Enabled    | Enabled    | Enabled    | Enabled   | --                  | Enabled         |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | Firewall Config           | Enabled    | X          | X          | Enabled   | --                  | X               |
| | Check		      |		   |		|	     |		 |		       |		 |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | Network Share             | Enabled    | X          | X          | Enabled   | --                  | X               |
| | Check		      |		   |		|	     |		 |		       |		 |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Logged In Check             | Enabled    | X          | X          | Enabled   | X                   | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Process Check               | Enabled    | Enabled    | Enabled    | Enabled   | --                  | Enabled         |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Service Check               | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Autoruns Check              | Enabled    | Enabled    | Enabled    | Enabled   | --                  | Enabled         |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Rootkit Check               | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | LSA Sessions              | Enabled    | Enabled    | X          | Enabled   | --                  | X               |
| | Analysis		      |		   |		|	     |		 |		       |		 |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| User Account Check          | Enabled    | Enabled    | Enabled    | Enabled   | X                   | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| User Profile Check          | Enabled    | X          | Enabled    | Enabled   | X                   | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | Network Sessions          | Enabled    | Enabled    | X          | Enabled   | X                   | X               |
| | Check		      |		   |		|	     |		 |		       |		 |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | Network Open              | Enabled    | Enabled    | X          | Enabled   | X                   | X               |
| | Files Check		      |		   |		|	     |		 |		       |		 |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| | Scheduled Tasks           | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
| | Analysis		      |		   |		|	     |		 |		       |		 |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| WMI Startup Check           | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| At Entries Check            | Enabled    | Enabled    | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| MFT Analysis                | X          | X          | X          | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+
| Eventlog Analysis           | Enabled    | X          | Enabled    | Enabled   | --                  | X               |
+-----------------------------+------------+------------+------------+-----------+---------------------+-----------------+

Features
^^^^^^^^

The following table gives an overview of several module features and
their use in the different scan modes.

X = Diasbled

+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Feature                        | | Default  | | Quick    | | Soft     | | Intense | | DC        | | Linux /       |
+--------------------------------+            |	           |		|           |	          | | macOS         |
| Parent			 |	      |	           |		|	    |		  |                 |
+================================+============+============+============+===========+=============+=================+
| Sigma Scan                     | X          | X          | X          | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |	          |                 |
| | Eventlog Analysis / 	 |	      |	           |		|	    |		  |                 |
| | Log File Scanning   	 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| EXE Decompression              | Enabled    | Enabled    | X          | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Archive Scan                   | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Double Pulsar Check            | Enabled    | Enabled    | X          | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| Rootkit Check  		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Groups XML Analysis            | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Vulnerability Check            | Enabled    | Enabled    | Enabled    | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Web Server Dir Scan            | Enabled    | X          | Enabled    | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| Process Check  		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| WMI Persistence                | Enabled    | Enabled    | X          | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Registry Hive Scan             | Enabled    | Enabled    | X          | Enabled   | X           | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| AmCache Analysis               | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Process Handle Check           | Enabled    | Enabled    | Enabled    | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| Process Check 		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Process Memory Check           | Enabled    | Enabled    | X          | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| Process Check 		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Process Connections Check      | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| Process Check          	 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Basic File Location Checks     | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Windows Error Report (WER)     | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Windows At Job File Analysis   | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Evil Users Check               | Enabled    | Enabled    | Enabled    | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| User Account Check		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| EVTX File Scanning             | Enabled    | X          | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Prefetch Library Scanning      | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Memory Dump DeepDive           | X          | X          | X          | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Log File Scanning (.log)       | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| File System Scan		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Event ID statistics            | Enabled    | X          | X          | Enabled   | --          | X               |
+--------------------------------+	      |	           |		|	    |		  |                 |
| Eventlog Analysis 		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+
| Suspicious Shellbag Entries    | Enabled    | Enabled    | Enabled    | Enabled   | --          | Enabled         |
+--------------------------------+	      |	           |		|	    |		  |                 |
| Registry Hive Scan 		 |	      |	           |		|	    |		  |                 |
+--------------------------------+------------+------------+------------+-----------+-------------+-----------------+

