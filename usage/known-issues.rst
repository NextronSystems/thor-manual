
Known Issues
============

THOR#001: Could not parse sigma logsources
------------------------------------------

.. code:: none

    Error could not parse sigma log sources
    FILE: config\sigma.yml ERROR: no logsources element found

The issue occurs only for very old THOR installations that at one time had the template file
``config\tmpl-sigma.yml`` named ``config\sigma.yml``.

THOR#001: Workaround
~~~~~~~~~~~~~~~~~~~~

The error can be ignored and the THOR scan will run as expected. To prevent
the error message from showing, remove ``config\sigma.yml`` or use a newly
downloaded THOR package.

THOR#001: Status
~~~~~~~~~~~~~~~~

Open

THOR#002: THOR in Lab-Mode does not scan network or external drives
-------------------------------------------------------------------

If running a command like ``thor64.exe --lab -p Z:\myshare`` THOR will not currently scan
the path. Normally the ``--alldrives`` flag should be implicitly activated in Lab-mode.

.. note: 
    This flag is only available with a THOR lab license

THOR#002: Workaround
~~~~~~~~~~~~~~~~~~~~

You have to add the ``--alldrives`` flag on your own. E.g.

.. code-block:: doscon

    C:\thor>thor64.exe --lab -p Z:\myshare --alldrives

THOR#002: Status
~~~~~~~~~~~~~~~~

Open

THOR#003: THOR shows the error: No rules with DEEPSCAN tag found
----------------------------------------------------------------

This error is caused by a missing signature set. Usually the user just copied the THOR executable and forgot to copy the whole program folder including the ``./signatures`` folder. The error message means that none of THOR's own signatures could be found. These signatures also include the so-called ``DEEPSCAN`` signatures. THOR reports that not a single one of these signatures could be found, which results in very limited scan capabilities. 

.. code-block:: doscon 

    MESSAGE: No rules with DEEPSCAN tag found

THOR#003: Solution 
~~~~~~~~~~~~~~~~~~

Make sure that you have the ``./signatures`` folder in your THOR program folder and that it contains at least the following files: 

* ``./signatures/yara/thor-all.yas``
* ``./signatures/yara/thor-deepscan-selectors.yasx``
* ``./signatures/yara/thor-expensive.yase``
* ``./signatures/yara/thor-keywords.yas``
* ``./signatures/yara/thor-log-sigs.yas``
* ``./signatures/yara/thor-meta.yas``
* ``./signatures/yara/thor-process-memory-sigs.yas``
* ``./signatures/yara/thor-registry.yas``
