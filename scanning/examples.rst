.. Index:: Examples

Examples
--------

Below are a few examples on how you can use THOR for specific
scenarios.

Logging to a Network Share
^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command creates a JSON log file on a share called
"rep" on system "sys" if the user running the command has the respective
access rights on the share.

.. code-block:: none

  thor64.exe --no-html --no-csv --json \\sys\rep\%COMPUTERNAME%_thor.json

Logging to Syslog Server
^^^^^^^^^^^^^^^^^^^^^^^^

The following command instructs THOR to log to a remote syslog server
only.

.. code-block:: none

  thor64.exe --no-html --no-csv --no-json --remote-log syslog.server.net

Scan a Single Directory
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe -a Filescan -p C:\temp

Change the output directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe -e Z:\

Only scan the last 7 days of (Windows) Event Logs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe --lookback 7

By default the ``--lookback`` flag/value only applies to (Windows) Event Logs.
To apply it to all modules, use the ``--lookback-global`` flag.

Intense Scan and DeepDive on a Mounted Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following are two examples on how to scan a mounted image on
Windows and Linux.

.. important::
  Lab scanning mode requires a `forensic lab license <https://www.nextron-systems.com/2020/11/11/thor-forensic-lab-license-features/>`__
  type, which is meant to be used in forensic labs.

Mounted as Drive Z (drive C on the source system)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: none

  thor64.exe --lab -p Z:\ --path-remap Z:C

Mounted as /mnt
~~~~~~~~~~~~~~~

.. code-block:: none

  thor64.exe --lab -p /mnt --path-remap /mnt:/

Scan Multiple Paths
^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe --lab -p C:\\ D:\\webapps E:\\inetpub

.. hint::
   non-existent directories will be automatically skipped

Scan All Hard Drives (Windows Only)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: none

  thor64.exe --all-hard-drives

Don't Scan Recursively
^^^^^^^^^^^^^^^^^^^^^^

To instruct THOR to scan a folder non-recursively use the ``:NOWALK`` suffix.

.. code-block:: none

  thor64.exe -a FileScan -p C:\Windows\System32:NOWALK
