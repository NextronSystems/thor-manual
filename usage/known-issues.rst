
Known Issues
============

THOR#003: No rules with DEEPSCAN tag found
------------------------------------------

.. list-table::
    :header-rows: 1
    :widths: 50, 50
    
    * - Introduced Version
      - Fixed Version
    * - N/A
      - N/A

This error is caused by a missing signature set. Usually the user just copied the
THOR executable and forgot to copy the whole program folder including the ``./signatures``
folder. The error message means that none of THOR's own signatures could be found.
These signatures also include the so-called ``DEEPSCAN`` signatures. THOR reports
that not a single one of these signatures could be found, which results in very limited
scan capabilities.

You can see that this is the case by inspecting your scan results:

.. code-block:: none
    :emphasize-lines: 4-5

    THOR: Warning: MODULE: Init MESSAGE: No rules with DEEPSCAN tag found.
        THOR won't scan any files with YARA rules. Please ensure that you use
        up-to-date signatures. SCANID: S-Qpw5dDmEBaw
    THOR: Info: MODULE: Init MESSAGE: Successfully compiled 0 custom default
        YARA rules SCANID: S-Qpw5dDmEBaw TYPE: YARA

You can also see during the initialization process of THOR, that no YARA rules
are compiled:

.. code-block:: doscon 
    :emphasize-lines: 11-12, 23-24

    C:\nextron\thor>thor64.exe
    [...]

    > Reading YARA signatures and IOC files ...
    Info Successfully compiled 0 default YARA rules TYPE: YARA
    Info Successfully compiled 0 log YARA rules TYPE: YARA
    Info Successfully compiled 0 registry YARA rules TYPE: YARA
    Info Successfully compiled 0 keyword YARA rules TYPE: YARA
    Info Successfully compiled 0 process YARA rules TYPE: YARA
    Info Successfully compiled 0 meta YARA rules TYPE: YARA
    Warning No rules with DEEPSCAN tag found. THOR won't scan any files with YARA rules.
        Please ensure that you use up-to-date signatures.
    Info Successfully compiled 0 custom default YARA rules TYPE: YARA
    Info Skip sigma initialization, use '--sigma' flag to scan with sigma
    Info Successfully compiled 0 STIXv2 indicators (skipped 0 indicators) TYPE: STIX
    Info Successfully compiled 0 keyword ioc strings TYPE: IOC
    Info Successfully compiled 0 filename ioc strings and 0 filename ioc regexs TYPE: IOC
    Info Successfully compiled 0 malware and 0 false positive hashes TYPE: IOC
    Info Successfully compiled 0 file type signatures TYPE: IOC
    Info Successfully compiled 0 malware domains TYPE: IOC
    Info Successfully compiled 0 malicious handles and 0 regex malicious handles TYPE: IOC
    Info Successfully compiled 0 named pipe ioc strings and 0 named pipe ioc regexs TYPE: IOC
    Warning No file type signatures compiled, file type detection can't be done.
        Because of this, many files won't be scanned.

    [...]

THOR#003: Solution 
~~~~~~~~~~~~~~~~~~

Make sure that you have the ``./signatures`` folder in your THOR program folder and
that it contains at least the following files: 

* ``./signatures/yara/thor-all.yas``
* ``./signatures/yara/thor-deepscan-selectors.yasx``
* ``./signatures/yara/thor-expensive.yase``
* ``./signatures/yara/thor-keywords.yas``
* ``./signatures/yara/thor-log-sigs.yas``
* ``./signatures/yara/thor-meta.yas``
* ``./signatures/yara/thor-process-memory-sigs.yas``
* ``./signatures/yara/thor-registry.yas``

THOR#002: THOR in Lab-Mode does not scan network or external drives
-------------------------------------------------------------------

.. list-table::
    :header-rows: 1
    :widths: 50, 50
    
    * - Introduced Version
      - Fixed Version
    * - N/A
      - >=10.6.16

If running a command like ``thor64.exe --lab -p Z:\myshare`` THOR will not currently scan
the path. Normally the ``--alldrives`` flag should be implicitly activated in Lab-mode.

.. note::
    The ``--alldrives`` flag is only available with a lab license

THOR#002: Workaround
~~~~~~~~~~~~~~~~~~~~

You have to add the ``--alldrives`` flag on your own. E.g.

.. code-block:: doscon

    C:\thor>thor64.exe --lab -p Z:\myshare --alldrives

THOR#001: Could not parse sigma logsources
------------------------------------------

.. list-table::
    :header-rows: 1
    :widths: 50, 50
    
    * - Introduced Version
      - Fixed Version
    * - N/A
      - N/A

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
