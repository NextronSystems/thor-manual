.. Index:: THOR DB

THOR DB
-------

THOR creates an SQLite database by default.
The location differs by OS and whether THOR runs as administrator / root:

.. list-table::
   :widths: 50, 50

   * - Windows (as administrator)
     - **C:\\ProgramData\\thor\\thor10.db**
   * - Windows (not as administrator)
     - **%LOCALAPPDATA%\\thor\\thor10.db**
   * - Unix (as administrator)
     - **/var/lib/thor/thor10.db**
   * - Unix (not as administrator)
     - **~/.local/state/thor/thor10.db**

You can deactivate THOR DB and all its features by using the ``--nothordb`` flag.

It stores persistent information over several scan runs:

* Timing Information

  * This information can be used by users to analyze why a specific THOR scan took a long time

* Scan State Information

  * This information is used to resume scan runs where they were stopped

* Delta Comparison

  * This detection feature allows to compare the result of a former module
    check with the current results and indicate suspicious changes between scan runs

The THOR DB related command line options are:

.. list-table::
   :header-rows: 1
   :widths: 25, 75

   * - Parameter
     - Description
   * - **--exclude-component ThorDB**
     - Disables THOR DB completely. All related features will be disabled as well.
   * - **--thordb-path [string]**
     - Allows to define a location of the THOR database file. File names or path names are allowed. If a path is given, the database file ``thor10.db`` will be created in the directory. Environment variables are expanded.
   * - **--resume**
     - Resumes a previous scan (if scan state information is still available and the exact same command line arguments are used)
   * - **--resume-only**
     - Only resume a scan if a scan state is available. Do not run a full scan if no scan state can be found.

Resume a Scan
^^^^^^^^^^^^^

THOR tries to resume a scan when you set the ``--resume`` parameter.

It will only resume the previous scan if

1. You have started the scan with ``--resume``

2. The argument list is exactly the same as in the first scan attempt

3. You haven't disabled the :ref:`other/thordb:THOR DB`

4. Scan state information is still available (could have been cleared by
   running THOR a second time without the ``--resume`` parameter)

You can always clear the resume state and discard an old state by
running thor.exe once without using the ``--resume`` parameter.

Delta Comparison
^^^^^^^^^^^^^^^^

The delta comparison feature allows comparing former scan results on a
system with the current results, indicating changes in system
configurations and system components.

Currently, the following scan modules feature the delta comparison
check:

* Autoruns

  * THOR compares the output of the Autoruns module with the output of
    the last scan run. The Autoruns module does not only check "Autorun"
    locations but also elements like browser plugins, drivers, LSA
    providers, WMI objects and scheduled tasks.

* Services
  
  * The comparison detects new service entries and reports them.

* Hosts

  * New or changed entries in the "hosts" file could indicate system
    manipulations by attackers to block certain security functions or
    intercept connections.