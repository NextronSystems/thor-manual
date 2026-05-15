.. Index:: Debug Output

Debug Output
============

Many unexpected behaviors can be investigated by using the
``--debug`` parameter.

This can be useful in situations such as:

* THOR does not produce an alert for a known malicious element
* THOR exits with an error
* THOR takes unexpectedly long, or unusually short, on specific
  elements

Debugging Examples
------------------

If you identified the element that causes problems during a scan, try
scanning that specific element with ``--debug`` enabled. For example,
if a single file appears to cause problems during a THOR scan, you can
use the ``Filescan`` module to scan only that file and review THOR's
debug output:

.. code-block:: doscon

   C:\thor>thor64.exe -a Filescan -p C:\tools\file --debug

The command above will:

- Only use the Filescan module (``-a Filescan``)
- Only scan a single file (``-p C:\tools\file``)
- Enable THOR's debug output (``--debug``)

To run a scan with only specific modules, use the ``--module``
parameter, or its short form ``-a``:

.. code-block:: doscon

   C:\thor>thor64.exe -a Mutex
   C:\thor>thor64.exe -a FileScan
   C:\thor>thor64.exe -a Eventlog

.. hint::
   You can specify multiple modules in a single command. See
   :ref:`scanning/modules:modules` for a full list of module names.

   .. code-block:: doscon

      C:\thor>thor64.exe -a Mutex,EnvCheck,Users

You can reduce the scope of some modules even further by using
``--lookback``:

.. code-block:: doscon

   C:\thor>thor64.exe -a Eventlog --lookback 3
   C:\thor>thor64.exe -a FileScan -p C:\Windows\System32 --lookback-global --lookback 1

To find out why a file was not detected, use ``--debug`` together with
``--log-object file`` and, if needed, test the same path in
``--deep`` mode.

.. code-block:: doscon

   C:\thor>thor64.exe -a Filescan -p C:\testfolder --debug --log-object file
   C:\thor>thor64.exe -a Filescan -p C:\testfolder --debug --log-object file --deep

If the file is detected in ``--deep`` mode but not in default mode, the
file extension or the magic header is the most likely cause. You can
adjust ``file-size-limit`` in ``./config/thor.yml`` or add a magic
header in ``./signatures/misc/file-type-signatures.cfg``.
