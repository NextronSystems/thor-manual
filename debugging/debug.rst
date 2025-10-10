.. Index:: Debug Output

Debug Output
------------

Most unexpected behavior can be debugged by using the parameter ``--debug``.

This can be useful if you ever encounter a situation in which:

* THOR doesn't produce an alert on a known malicious element
* THOR exits with an error
* THOR takes a long time or unexpected short time on elements

Debugging Examples
------------------

If you found the culprit for your problematic scan, try scanning that
specific element with the ``--debug`` parameter set. For example,
a specific file seems to cause problems during a THOR scan. You can
use the ``Filescan`` module to only scan this file and see the debug
output of THOR:

.. code-block:: doscon

   C:\thor>thor64.exe -a Filescan -p C:\tools\file --debug

The above command will:

- Only use the Filescan module (``-a Filescan``)
- Only scan a single file (``-p C:\tools\file``)
- Enable THORs debug output (``--debug``)

To run a scan only with certain module(s), use the ``--module`` (short hand ``-a``)
command line switch :

.. code-block:: doscon

   C:\thor>thor64.exe -a Mutex
   C:\thor>thor64.exe -a FileScan
   C:\thor>thor64.exe -a Eventlog

.. hint::
   You can specify multiple modules within one command (see :ref:`scanning/modules:modules`
   for a full list of module names):

   .. code-block:: doscon

      C:\thor>thor64.exe -a Mutex,EnvCheck,Users

You can try to reduce the scope of a module even further by using ``--lookback``:

.. code-block:: doscon

   C:\thor>thor64.exe -a Eventlog --lookback 3
   C:\thor>thor64.exe -a FileScan -p C:\Windows\System32 --lookback-global --lookback 1

To find out why a certain file couldn't be detected, use
``--debug`` with ``--log-object file`` and try to switch into ``--deep`` mode.

.. code-block:: doscon

   C:\thor>thor64.exe -a Filescan -p C:\testfolder --debug --log-object file
   C:\thor>thor64.exe -a Filescan -p C:\testfolder --debug --log-object file --deep

If it has been detected in ``--deep`` mode but not in default mode,
the file extension or the magic header is most likely the problem.
You can adjust ``file-size-limit`` in ``./config/thor.yml`` or add a
magic header in ``./signatures/misc/file-type-signatures.cfg``.