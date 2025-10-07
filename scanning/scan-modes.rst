Scan Modes
==========

You can select between six different scan modes in THOR:

- **Default**

  We recommend using the default scan mode for all sweeping activities. Scans take
  from one to six hours, depending on the partition size and number of interesting files.
  
  In default mode, THOR automatically chooses  the "**Soft**" mode if the system has only limited
  CPU and RAM resources.

- **Quick** ``--quick``

  This mode is the fastest one and oriented on the "Pareto Principle", covering 80% of
  the modules and checks in 20% of the normal scan time. In "quick" mode, THOR skips
  elements that have not been created or modified within the last 2 days in the "Eventlog",
  "Registry" and "Filescan" modules. A set of 40+ predefined directories will still be checked
  completely (e.g. AppData, Recycler, System32). "Quick" mode is known to be the
  "preventive" scan mode – less intense and very fast.

Themed scan modes:

- **Soft** ``--soft`` - force disable with ``--no-soft``

  This mode disables all modules and checks that could be risky for system stability. It furthermore
  tries to reduce RAM usage of THOR.
  It is automatically activated on (more details in chapter :ref:`other/rescontrol:Automatic Soft Mode`):
  
  - Systems with only a single CPU core
  
  - Systems with less than 1024 MB of RAM

* **Lab Scan** ``--lab``

  This mode scans only the file system and disables all other modules.
  (see :ref:`scanning/special-scan-modes:lab scanning` for more details
  and flags used in this scan mode)
  
  Example: 
  
  .. code-block:: console
    
    user@unix:~/thor$ ./thor64 --lab -p /mnt/image_c/

  .. note::
    "Lab Scanning" requires a special forensic license.

* **Deep** ``--deep``

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

These scan modes can also be combined, e.g. for ``--soft --diff``, though not
all combinations may make sense, e.g. ``--soft --intense``.

The following tables give an overview on the active modules and features
in the different scan modes. The :ref:`scanning/modules:modules` section lists
all available modules, whereas the :ref:`scanning/features:features` section
lists only features that are handled differently in the different scan modes.