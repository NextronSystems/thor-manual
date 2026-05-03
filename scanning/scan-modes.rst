.. Index:: Scan Modes

Scan Modes
==========

THOR provides several scan modes:

- **Default**

  We recommend the default scan mode for most broad scanning
  activities. Scan duration typically ranges from one to six hours,
  depending on partition size and the number of relevant files.

  In default mode, THOR automatically switches to **Soft** mode if the
  system has limited CPU or RAM resources.

- **Fast** ``--fast``

  This is the fastest scan mode. It follows a "Pareto Principle"
  approach by covering around 80% of the modules and checks in about 20%
  of the normal scan time. In fast mode, THOR skips elements that were
  not created or modified within the last two days in the ``Eventlog``,
  ``Registry``, and ``Filescan`` modules. A set of more than 40
  predefined directories is still checked completely, for example
  ``AppData``, ``Recycler``, and ``System32``. Fast mode is typically
  used as a quick preventive scan.

Additional scan modes:

- **Soft** ``--soft`` - force disable with ``--no-soft``

  This mode disables modules and checks that could put system stability
  at risk. It also tries to reduce THOR's RAM usage.
  It is automatically activated on:

  - Systems with only a single CPU core
  - Systems with less than 1024 MB of RAM

- **Deep** ``--deep``

  This mode is intended for system scanning in non-productive or lab
  environments. It disables several speed optimizations and enables
  time-consuming additional checks for the best possible detection
  results. Be careful when using this mode on database servers, as the
  high system load can put service stability at risk. Snapshots or
  backups are recommended before using this mode.

- **Difference** ``--delta``

  Delta mode looks for the last scan and the last completed modules in
  the local THOR database, then scans only elements on disk that were
  changed or created since the previous scan started. This mode applies
  shortcuts to the ``Filesystem``, ``Eventlog``, and ``Registry``
  modules. Delta scans are typically the shortest scans, but they
  require a previously completed scan. This scan mode is also
  susceptible to so-called "timestomping".

These scan modes can also be combined, for example ``--soft --delta``.
Not every combination is useful, for example ``--soft --deep``.

For more detail on module coverage and scan behavior, see
:ref:`scanning/modules:modules` for the full list of available modules
and :ref:`scanning/features:features` for features that behave
differently across scan modes.
