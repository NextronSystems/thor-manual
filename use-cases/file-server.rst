.. Index:: Scanning a Fileserver

Scanning a Fileserver
=====================

We recommend running THOR directly on the file server whenever
possible. If that is not possible because the file server operating
system is not supported by THOR, use a dedicated system to perform a
Filescan on the shares. That system should have at least 2 CPU cores
and 2 GB of RAM.

The following flags are recommended:

.. code-block:: doscon

   C:\thor>thor64.exe --threads 0 --module Filescan --all-drives --path X: --path Y: --path Z:

.. note:: 
    The ``--all-drives`` flag is only available with a lab license

If needed or desired, the scan can be adapted using the following flags.
In general, these options are not recommended by default, but they can
be useful in specific scenarios.

* ``--resume-scan``

  * If a previous scan failed, for example because it exceeded the
    maximum runtime, the scan can be resumed as long as the same flags
    are used together with ``--resume-scan``.

* ``--timeout 0``

  * The default timeout is 7 days. A value of ``0`` means no timeout.
    Change this value if your scans need more time.

* ``--path \\fileserver01\shareA``

  * If permissions allow anonymous access, the shares can be accessed
    using the UNC path and do not need to be mounted.
    
  * If the share is not accessible anonymously, you need to mount the
    shares with valid user credentials before the scan and grant access
    to the user running THOR. If you use ASGARD to launch THOR, the
    scanning user is ``NT AUTHORITY\SYSTEM``.

* ``--no-soft``

  * If the scanning system has too few resources, soft mode is enabled
    automatically. This flag prevents that.

* ``--lookback 8 --lookback-global``

  * Scans only files that were modified within the last 8 days and
    applies lookback to all supported modules, not just Eventlog. This
    speeds up the scan, but it is vulnerable to timestomping attacks.

* ``--diff``

  * Only scans new files or files that were modified since the last scan.
    This reduces scan time, but it is vulnerable to timestomping
    attacks. THOR DB is required for diff mode, so it cannot be used in
    combination with ``--exclude-component ThorDB``.

* ``--file-size-limit <size>``
 
  * Sets the maximum file size, for example ``50MB``. The default is
    64 MB. If you need to scan larger files, increase the file size
    limit accordingly.

* ``--exclude-component``

  * Disable features such as Eventlog scanning
    (``--exclude-component Eventlog``) if the share contains files that
    trigger feature checks you do not want. See
    :ref:`scanning/modules:modules` and
    :ref:`scanning/features:features` for a list of module and feature
    names that can be passed to ``--exclude-component``.

* ``--files-all``

  * Scan all files with YARA, regardless of file extensions or magic
    headers. Increase ``--file-size-limit`` to ``200MB`` unless a
    custom value is already specified.
    Caution: this can increase scan time drastically.

The use of diff and lookback is generally not recommended, but these
options can help if a file share scan does not finish within the
required time frame. Another option is to use multiple dedicated
systems to scan file server shares in parallel.
