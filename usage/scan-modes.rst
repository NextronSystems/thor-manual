
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
  | It is automatically activated on (more details in chapter :ref:`usage/other-topics:Automatic Soft Mode`):
  | - Systems with only a single CPU core
  | - Systems with less than 1024 MB of RAM

* | **Lab Scan (--lab)**
  | This mode scans only the file system and disables all other modules. (see :doc:`/usage/special-scan-modes` for more details and flags used in this scan mode)
  | Example: **./thor64 --lab -p /mnt/image\_c/**

* | **Intense (--intense)**
  | This mode is meant for system scanning in a non-productive or lab environment. It disables several speed optimizations and enables time-consuming extra checks for best detection results.

* | **Difference (--diff)**
  | The Diff Mode looks for a last scan and last finished modules in the local THOR DB and scans only elements on disk that have been changed or created since the last scan start. This mode applies short-cuts to the “Filesystem”, “Eventlog” and “Registry” modules. Diff scans are typically the shortest scans but require a completed previous scan. This scan mode is also susceptible to the so-called “Timestomping”.

These scan modes can also be combined, e.g. for `--soft --diff`, though not all combinations may make sense (e.g. `--soft --intense`).

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

Scan Mode Overview
^^^^^^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/scan-mode-overview.csv
  :widths: 20, 20, 20, 20, 20
  :delim: ;
  :header-rows: 1

.. [2] Disabled on Domain Controllers
.. [3] No process memory scan with YARA rules

Features
--------

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