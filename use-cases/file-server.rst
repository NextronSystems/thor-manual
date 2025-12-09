.. Index:: Scanning a Fileserver

Scanning a Fileserver
---------------------

The recommendation for scanning a fileserver is running THOR directly on the
system. If that is not possible, because the operating system of the fileserver
is not supported by THOR, we recommend a dedicated system to perform a filescan
on the shares. The system should have at least 2 CPU cores and 2 GB of RAM.

The recommended flags to run THOR are:

.. code-block:: doscon

   C:\thor>thor64.exe --threads 0 --module Filescan --all-drives --path X: --path Y: --path Z:

.. note:: 
    The ``--all-drives`` flag is only available with a lab license

If needed or desired, the scan can be adapted using the following flags.
In general, the following options are not recommended but can help in special scenarios.

* ``--resume-scan``

  * If a previous scan failed (e.g. because of a exceeded max. runtime)
    the scan can be resumed, if the same flags (and additional the resume
    flag) are used to start the scan.

* ``--timeout 0``

  * Default timeout is 7 days, 0 means no timeout. Change this value if your scans need more time.

* ``--path \\fileserver01\shareA``

  * If permissions allow anonymous access, the shares can be accessed
    using the UNC path and do not need to be mounted.
    
  * If the share is not accessible anonymously, you need to mount the shares using valid
    user credentials. This has to be done before the scan and access granted to the user running the THOR scan.
    If you use ASGARD to launch THOR the user performing the scan is ``NT AUTHORITY\SYSTEM``.

* ``--no-soft``

  * If your scanning system has too little system resources, the softmode
    is automatically enabled. This flag prevents that.

* ``--lookback 8 --lookback-global``

  * Only scans files that were modified within the last 8 days. Apply Lookback to all modules that support it (not only Eventlog). Faster scan
    time but vulnerable to timestomping attacks.

* ``--diff``

  * Only scans new files or files that were modified since the last scan.
    Faster scan time but vulnerable to timestomping attacks. THOR DB is
    needed for diff, so cannot be used in combination with ``--exclude-component ThorDB``.

* ``--file-size-limit ?????``
 
  * Maximum file size (specify as e.g. ``50MB``)). The default is 64 MB. If you need to scan bigger files,
    you might need to increase the file size limit.

* ``--exclude-component``

  * Disable features like scanning Eventlogs (``--exclude-component Eventlog``), if your share contains
    files that trigger special feature checks of THOR, that are not desired. Please see
    :ref:`scanning/modules:modules` and :ref:`scanning/features:features`
    for a list of module/feature names that can be passed to ``--exclude-component``.

* ``--files-all``

  * Scan all files with YARA, regardless of file extensions or magic headers.
    Increase the ``--file-size-limit`` to 200MB unless a custom value is specified.
    (Caution: This will increase the scan time drastically!)

The usage of diff and lookback are generally not recommended, but can be used if your fileshare scan does not finish in the timeframe you desire.
Another option is to use multiple dedicated systems to run scans on the fileserver shares in parallel.

