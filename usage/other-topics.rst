
Other Topics 
============

License Retrieval
-----------------

THOR allows for a more flexible way to fetch licenses,
besides the classic way of placing a license file in
the program folder. See :ref:`usage/deployment:Licensing` for details.

Process Memory Dumps
--------------------

THOR supports process dumping to backup volatile
malware information. This can be enabled with ``--dump-procs``.

When enabled, THOR on Windows creates a process dump of any process that is considered
malicious. Maliciousness is determined as anything that triggers a
warning or an alert.

This process dump can then be analyzed with standard tools later on to
examine the found malware.

.. figure:: ../images/image23.png
   :alt: Process dumping

   Process dumping

.. figure:: ../images/image24.png
   :alt: Process dumps on disk

   Process dumps on disk

To prevent flooding the disk fully in case many dumps are created, old
dumps of a process are overwritten if a new dump is generated. Also,
THOR will only generate up to 10 dumps per scan. This can be customized
with ``--process-dump-limit``.

Also note that THOR will never dump lsass.exe to prevent these dumps
from potentially being used to extract passwords by any attackers.

Resource Control
----------------

THOR's internal resource control feature puts the system's stability and
the responsiveness of running services first.

Resource control is active by default. You can deactivate it using
**--no-resource-check**.

Be advised that due to Resource Control, the THOR scan may terminate its
completion. The scan gets terminated under the following conditions:

1. If the available physical memory drops below 50MB (can be customized with ``--memory-limit``)

2. | If more than 60 MB of log data have been written (disk / syslog) (can be customized with ``--log-size-limit``)
   | In this case, THOR switches in the "reduced-logging" mode in which it only transmits "Notices, Warnings and Alerts" and after another 4 MB of log data THOR terminates itself in order to prevent log flooding due to a high number of false positives.

If the scan terminates repeatedly you should check what causes the
performance issues or choose times with less workload (e.g. weekends,
night). To debug such states, you can check the last warning that THOR
generates before exiting the scan. It includes the top memory consumers
that could have caused the memory exhaustion.

.. figure:: ../images/image25.png
   :alt: Resource Control Scan Termination

   Resource Control Scan Termination

.. warning:: 
  Deactivating Resource Control on systems with exhausted
  resources can put the system's stability at risk.

Automatic Soft Mode
^^^^^^^^^^^^^^^^^^^

Soft mode is automatically activated on systems with low hardware
resources.

If any of the following conditions is fulfilled, THOR activates soft mode:

* Less than 2 CPU cores
* Less than 1024 MB of RAM

In Soft mode several checks and features that could risk system's
stability or could provoke an Antivirus or HIDS to intervene with the
scanner are disabled. See :ref:`usage/scan-modes:scan modes` for a complete
overview.


Scoring System
--------------

The scoring system is one of THOR's most prominent features. Both YARA
signatures and filename IOCs contain a score field. The score is an
integer value that can be negative to reduce the score on elements that
are prone to false positives.

Only YARA rules and Filename IOCs support a user defined score. But
since you are able to write YARA rules for almost every module, the
scoring system is very flexible.

The total score of an element determines the level/severity of the
resulting log message.

.. list-table::
  :header-rows: 1
  :widths: 20, 20, 60

  * - Score
    - Level
    - Condition
  * - >= 40
    - Notice
    - 
  * - >= 60
    - Warning
    - 
  * - > 80
    - Alert
    - At least 1 sub score more than 75

.. note::
  All scores are between 0 and 100. The score is a metric that expresses
  a combination of confidence and severity in percent. This means a
  finding with a score of 95 can be seen as a severe finding with a
  high confidence. Exceptions might be - as always - obvious false
  positives like unencrypted or in-memory AV signatures.

Scoring per Signature Type Match
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
  :header-rows: 1
  :widths: 25, 75

  * - Type
    - Score
  * - YARA match
    - Defined in the meta data of the YARA rule as integer value (e.g. "score = 50")
  * - IOC match
    - Defined in the IOC (dependent on the format, see ::ref:`usage/custom-signatures:YAML IOC files`)
  * - Sigma rule match
    - Based on the Sigma rule's level:
      - Level low translates to score 40
      - Level medium translates to score 50
      - Level high translates to score 70
      - Level critical translates to score 100

Accumulated Scores
^^^^^^^^^^^^^^^^^^

If multiple signatures match on an element, the scores of all signatures
will be accumulated and calculated into one final score.
The following chapters show you how those scores are calculated.

Please keep in mind that only positive scores and the top two reasons are
shown by default. You can use ``--alert-reason-limit`` to customize the number of
reasons shown.

Reason scores are not added up for the total score. Instead, given a number
of scores (s_0, s_1, ...) that are ordered descending. The total score is
calculated with the following formula:

.. code-block :: none

   100 * (1 - (1 - s_0 / 100 / 2^0) * (1 - s_1 / 100 / 2^1)  * (1 - s_2 / 100 / 2^2) * ...)

This means, scores are "capped" at a maximum of 100, and multiple lower
scores are weighted far less.

You can use python to calculate the score and try the formula. Please note
that we use an example with five sub-scores and no sub-score higher than the
threshold of 75 to turn classify this as an alert:

.. code-block:: python

   subscore0 = 1 - 70 / 100 / pow(2, 0)
   subscore1 = 1 - 70 / 100 / pow(2, 1)
   subscore2 = 1 - 50 / 100 / pow(2, 2)
   subscore3 = 1 - 40 / 100 / pow(2, 3)
   subscore4 = 1 - 40 / 100 / pow(2, 4)
   score = 100 * (1 - (subscore0 * subscore1 * subscore2 * subscore3 * subscore4))
   print(score)
   84.195859375

THOR DB
-------

THOR creates an SQLite database by default.
The location differs by OS and whether THOR runs as administrator / root:

.. list-table::
   :header-rows: 1
   :widths: 50, 50

   * - Windows (as administrator)
     - **C:\ProgramData\thor\thor10.db**
   * - Windows (not as administrator)
     - **%LOCALAPPDATA%\thor\thor10.db**
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

3. You haven't disabled the :ref:`usage/other-topics:THOR DB`

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

Archive Scan
------------

The ``Archive`` feature supports the following archive types:

- ZIP
- RAR
- TAR
- GZIP
- 7ZIP
- CAB
- BZIP2

When scanning a file within any of these file types, THOR will append
the path within the archive to the archive's own path for reporting and scan purposes
(like filename IOCs or YARA rules). For example, an archive ``C:\temp\test.zip``
containing a file ``path/in/zip.txt`` will cause the simulated path to
be ``C:\temp\test.zip\path\in\zip.txt``.
