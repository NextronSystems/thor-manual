
Known Issues
============


Could not parse sigma logsources
--------------------------------

.. code:: none

    Error could not parse sigma log sources
    FILE: config\sigma.yml ERROR: no logsources element found

The issue occurs only for very old THOR installations that at one time had the template file
``config\tmpl-sigma.yml`` named ``config\sigma.yml``.

Workaround
~~~~~~~~~~
The error can be ignored and the THOR scan will run as expected. To prevent
the error message from showing, remove ``config\sigma.yml`` or use a newly
downloaded THOR package.

Status
~~~~~~
Open

THOR in Lab-Mode does not scan network or external drives
---------------------------------------------------------

If running a command like ``thor64.exe --lab -p Z:\myshare`` THOR will not currently scan
the path. Normally the ``--alldrives`` flag should be implicitly activated in Lab-mode.

Workaround
~~~~~~~~~~

You have to add the ``--alldrives`` flag on your own. E.g.

.. code:: none

    thor64.exe --lab -p Z:\myshare --alldrives

Status
~~~~~~
Open
