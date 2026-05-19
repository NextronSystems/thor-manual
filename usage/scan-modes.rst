Scan Modes
==========

THOR provides several scan modes:

- **Default**

  We recommend the default scan mode for broad scanning activities.
  Scans typically take between one and six hours, depending on
  partition size and the number of relevant files.
  
  In default mode, THOR automatically switches to **Soft** mode if the
  system has limited CPU or RAM resources.

  There is also a special Lab Scanning mode (``--lab``) described in
  :ref:`usage/special-scan-modes:lab scanning`. It disables many
  limitations and allows you to scan mounted images in a lab scenario,
  even with multiple THOR instances on a single workstation.

  .. note::
    "Lab Scanning" requires a special forensic license.

- **Quick** ``--quick``

  This is the fastest scan mode. It follows a "Pareto Principle"
  approach by covering around 80% of the modules and checks in about
  20% of the normal scan time:
  
  - THOR skips elements that have not been created or modified within the last 3 days in "Filescan" modules
  
  - Log scanning is disabled (affects the “LogScan”, ‘Eventlog’, and “EVTX” features)
  
  - The “Firewall Config Check,” “User Profile Check,” “Hotfix Check,” and “MFT Analysis” modules are disabled
  
  - A set of 40+ predefined directories will still be checked completely (e.g. AppData, Recycler, System32)
  
  Quick mode is typically used as a fast preventive scan.

Additional scan modes:

- **Soft** ``--soft`` - force disable with ``--nosoft``

  This mode disables modules and checks that could put system stability
  at risk. It is automatically activated on (see
  :ref:`usage/other-topics:Automatic Soft Mode` for more details):
  
  - Systems with only a single CPU core
  
  - Systems with less than 1024 MB of RAM

* **Lab Scan** ``--lab``

  This mode scans only the file system and disables all other modules
  (see :ref:`usage/special-scan-modes:lab scanning` for more details
  and the flags used in this scan mode).
  
  Example: 
  
  .. code-block:: console
    
    user@unix:~/thor$ ./thor64 --lab -p /mnt/image_c/

* **Intense** ``--intense``

  This mode is intended for scanning non-productive or lab
  environments. It disables several speed optimizations and enables
  time-consuming additional checks for the best possible detection
  results. Be careful when using this mode on database servers, as the
  high system load can put service stability at risk. Snapshots or
  backups are recommended before using this mode.

* **Difference** ``--diff``

  Difference mode checks the last scan and the last completed modules
  in the local THOR DB, then scans only elements on disk that were
  changed or created since the previous scan started. This mode applies
  shortcuts to the ``Filesystem``, ``Eventlog``, and ``Registry``
  modules. Difference scans are typically the shortest scans, but they
  require a previously completed scan. This scan mode is also
  susceptible to so-called ``timestomping``.

  However, the contents of some APT-relevant folders are scanned again even though no changes have been made to them. This behavior can be adjusted with the ``--force-aptdir-lookback`` flag.

These scan modes can also be combined, for example ``--soft --diff``,
although not every combination is useful, for example
``--soft --intense``.

The following tables give an overview on the active modules and features
in the different scan modes. The :ref:`usage/scan-modes:modules` section lists
all available modules, whereas the :ref:`usage/scan-modes:features` section
lists only features that are handled differently in the different scan modes.

Modules
-------

Modules are standalone jobs, which are being executed one after the other by THOR.
Those modules are invoking one job, for example the ``File System Scan`` module will
scan your file system, or the ``User Account Check`` will scan your system for user
accounts. Modules can invoke one or multiple :ref:`usage/scan-modes:features`,
which we will explain further down in this section.

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
        .enabled {text-align: center;}
        .reduced {background-color:#cccccc !important; text-align: center;}
        .disabled {background-color:#888888 !important; text-align: center;}
        </style>

.. csv-table::
  :file: ../csv/os-module-overview.csv
  :widths: 25, 25, 25, 25
  :delim: ;
  :header-rows: 1

.. [1] No process memory scan with YARA rules

.. hint:: 
  For a list of module names and how to turn them off, please
  see :ref:`usage/scan-modes:scan module names`

Scan Mode Overview
^^^^^^^^^^^^^^^^^^

The table below shows you which modules will be active
with the different scan modes. For OS compatibility, see
:ref:`usage/scan-modes:os module overview`.

- Normal: THOR without any flags regarding modules or features
- Quick: THOR scan with ``--quick`` flag
- Soft: THOR scan with ``--soft`` flag
- Intense: THOR scan with ``--intense`` flag

.. csv-table::
  :file: ../csv/scan-mode-overview.csv
  :widths: 28, 18, 18, 18, 18
  :delim: ;
  :header-rows: 1

.. [2] Disabled on Domain Controllers
.. [3] No process memory scan with YARA rules

Scan Module Names
^^^^^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/scan-module-naming.csv
  :widths: 33, 33, 33
  :delim: ;
  :header-rows: 1

Scan Module Explanation
^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/scan-module-explanation.csv
  :widths: 20, 80
  :delim: ;
  :header-rows: 1

Features
--------

Features are invoked by :ref:`usage/scan-modes:modules` and provide
additional processing or details for an item. For example, the
``File System Scan`` might find a ``.zip`` file during a scan and
invoke the ``Archive Scan`` feature. The ``Archive Scan`` feature then
extracts the archive contents and scans the contained items.

Another example is the ``Eventlog Analysis`` module, which might invoke
the ``Sigma Scan`` feature for certain event log entries.

.. hint:: 
  See :ref:`usage/other-topics:archive scan` for a list of supported
  archive formats.

Feature Scan Mode Overview
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/feature-scan-mode-overview.csv
  :widths: 20, 20, 20, 20, 20
  :delim: ;
  :header-rows: 1

.. [4] Disabled on Domain Controllers
.. [5] Only supported on Windows

Feature caller list
^^^^^^^^^^^^^^^^^^^

The following table gives an overview of THOR's features and
how they are called by the different modules and other features.

.. csv-table::
  :file: ../csv/feature-caller-list.csv
  :widths: 50, 50
  :delim: ;
  :header-rows: 1

Feature selectors
^^^^^^^^^^^^^^^^^
Since THOR 10.7, some THOR features are triggered by YARA rules.

When a (meta or generic) YARA rule with a specific tag matches on a file, the
corresponding feature is started and parses the file.

The standard signatures contain a number of rules with these tags, but
you can add more rules with these tags as custom signatures if needed.

.. csv-table::
  :file: ../csv/feature-selector-list.csv
  :widths: 40, 40, 50
  :delim: ;
  :header-rows: 1

Feature names
^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/feature-naming.csv
  :widths: 33, 33, 33
  :delim: ;
  :header-rows: 1
