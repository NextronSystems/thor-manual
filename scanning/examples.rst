.. Index:: Examples

Examples
========

This page shows a few common examples of how to use THOR in specific
scenarios.

Log to a Network Share
^^^^^^^^^^^^^^^^^^^^^^

The following command writes a JSON log file to the ``rep`` share on the
system ``sys``, provided that the user running the command has the
required access rights.

.. code-block:: doscon

  C:\thor>thor64.exe ^
    --no-html ^
    --no-csv ^
    --json \\sys\rep\%COMPUTERNAME%_thor.jsonl

Log to a Syslog Server
^^^^^^^^^^^^^^^^^^^^^^

The following command instructs THOR to log only to a remote syslog
server.

.. code-block:: doscon

  C:\thor>thor64.exe ^
    --no-html ^
    --no-csv ^
    --no-json ^
    --remote-log syslog.server.net

Scan a Single Directory
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\thor>thor64.exe --module Filescan --path C:\temp

Change the Output Directory
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\thor>thor64.exe --output-directory Z:\

Only Scan the Last 7 Days of Windows Event Logs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\thor>thor64.exe --lookback 7

By default, the ``--lookback`` flag applies only to Windows Event Logs.
To apply the same limit to all supported modules, use
``--lookback-global``.

Intense Scan and DeepDive on a Mounted Image
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following examples show how to scan a mounted image on Windows and
Linux.

.. important::
  Lab scanning mode requires a `forensic lab license <https://www.nextron-systems.com/2020/11/11/thor-forensic-lab-license-features/>`__,
  which is intended for forensic lab use.

Mounted as Drive Z (drive C on the source system)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: doscon

  C:\thor>thor64.exe ^
    --lab ^
    --path Z:\ ^
    --path-remap Z:C ^
    --target-os Windows

Mounted as /mnt
~~~~~~~~~~~~~~~

.. code-block:: console

  $ ./thor-linux-64 \
    --lab \
    --path /mnt \
    --path-remap /mnt:/ \
    --target-os Linux

Scan Multiple Paths
^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\thor>thor64.exe --lab --path C:\\ D:\\webapps E:\\inetpub

.. hint::
   Non-existent directories are skipped automatically.

Scan All Hard Drives (Windows Only)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: doscon

  C:\thor>thor64.exe --all-hard-drives

Do Not Scan Recursively
^^^^^^^^^^^^^^^^^^^^^^^

To instruct THOR to scan a folder without recursion, use the
``:NOWALK`` suffix.

.. code-block:: doscon

  C:\thor>thor64.exe --module FileScan --path C:\Windows\System32:NOWALK
