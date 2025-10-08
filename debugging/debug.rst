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
specific element with the ``--debug`` parameter set.

To run a scan only with certain modules only use the ``--module`` (short hand ``-a``)
command line switch (see :ref:`scanning/modules:modules` for
a full list of module names):

.. code-block:: doscon

   C:\nextron\thor>thor64.exe -a Mutex
   C:\nextron\thor>thor64.exe -a FileScan
   C:\nextron\thor>thor64.exe -a Eventlog

.. hint::
   You can specify multiple modules within one command:

   .. code-block:: doscon

      C:\nextron\thor>thor64.exe -a Mutex,EnvCheck,Users

You can try to reduce the scope of a module even further by using lookbacks:

.. code-block:: doscon

   C:\nextron\thor>thor64.exe -a Eventlog --lookback 3
   C:\nextron\thor>thor64.exe -a FileScan -p C:\Windows\System32 --global-lookback --lookback 1

To find out why a certain file couldn't be detected, use
``--debug`` with ``--log-object-type file`` and try to switch into ``--intense`` mode.

.. code-block:: doscon

   C:\nextron\thor>thor64.exe -a Filescan -p C:\testfolder --debug --log-object-type file
   C:\nextron\thor>thor64.exe -a Filescan -p C:\testfolder --debug --log-object-type file --intense

If it has been detected in ``--intense`` mode but not in default mode,
the file extension or the magic header is most likely the problem.
You can adjust ``file-size-limit`` in ``./config/thor.yml`` or add a
magic header in ``./signatures/misc/file-type-signatures.cfg``.