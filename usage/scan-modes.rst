Scan Modes
==========

You can select between six different scan modes in THOR:

- **Default**

  We recommend using the default scan mode for all sweeping activities. Scans take
  from one to six hours, depending on the partition size and number of interesting files.
  
  In default mode, THOR automatically chooses  the "**Soft**" mode if the system has only limited
  CPU and RAM resources.

  There's a special "Lab Scanning" (``--lab``) method described in section 
  :ref:`usage/special-scan-modes:lab scanning`, which disables many limitations
  and allows to scan mounted images in a Lab scenario, even with multiple THOR instances
  on a single Workstation.

  .. note::
    "Lab Scanning" requires a special forensic license.

- **Quick** ``--quick``

  This mode is the fastest one and oriented on the "Pareto Principle", covering 80% of
  the modules and checks in 20% of the normal scan time. In "quick" mode, THOR skips
  elements that have not been created or modified within the last 2 days in the "Eventlog",
  "Registry" and "Filescan" modules. A set of 40+ predefined directories will still be checked
  completely (e.g. AppData, Recycler, System32). "Quick" mode is known to be the
  "preventive" scan mode – less intense and very fast.

Themed scan modes:

- **Soft** ``--soft`` - force disable with ``--nosoft``

  This mode disables all modules and checks that could be risky for system stability.
  It is automatically activated on (more details in chapter :ref:`usage/other-topics:Automatic Soft Mode`):
  
  - Systems with only a single CPU core
  
  - Systems with less than 1024 MB of RAM

* **Lab Scan** ``--lab``

  This mode scans only the file system and disables all other modules.
  (see :ref:`usage/special-scan-modes:lab scanning` for more details
  and flags used in this scan mode)
  
  Example: 
  
  .. code-block:: console
    
    user@unix:~/thor$ ./thor64 --lab -p /mnt/image_c/

* **Intense** ``--intense``

  This mode is meant for system scanning in a non-productive or lab environment. It
  disables several speed optimizations and enables time-consuming extra checks for
  best detection results. Be careful with this mode on database servers, as this
  could corrupt your database due to the high load of the server. Snapshots/backups
  are advised before using this mode.

* **Difference** ``--diff``

  The Diff Mode looks for a last scan and last finished modules in the local THOR
  DB and scans only elements on disk that have been changed or created since the last
  scan start. This mode applies shortcuts to the "Filesystem", "Eventlog" and "Registry"
  modules. Diff scans are typically the shortest scans but require a completed previous
  scan. This scan mode is also susceptible to the so-called "Timestomping".

  However, the contents of some APT-relevant folders are scanned again even though no changes have been made to them. This behavior can be adjusted with the ``--force-aptdir-lookback`` flag.

These scan modes can also be combined, e.g. for ``--soft --diff``, though not
all combinations may make sense, e.g. ``--soft --intense``.

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

Features are being invoked by :ref:`usage/scan-modes:modules` and provide
further ``Details`` about an item. For example, the ``File System Scan``
might find a ``.zip`` file during a scan and invoke the ``Archive Scan``
feature. The ``Archive Scan`` feature in return will extract the zip file
and scan all the items in it.

Another example would be the ``Eventlog Analysis`` Module, which might invoke
the ``Sigma Scan`` feature on certain eventlog entries.

.. hint:: 
  Please see chapter :ref:`usage/other-topics:archive scan` for a list
  of supported archive formats.

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

When a (meta or generic) YARA rule with a specific tag matches on a file, the
corresponding feature is started and parses the file.

The standard signatures contain a number of rules with these tags, but if required,
you can add additional rules with these tags as custom signatures.

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
