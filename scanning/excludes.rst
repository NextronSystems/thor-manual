.. Index:: Exclude Elements

Exclude Elements
================

This chapter explains how to exclude specific paths and other elements
from a THOR scan.

Files and Directories
^^^^^^^^^^^^^^^^^^^^^

Use the ``--exclude-path`` flag to exclude directories and files from a
scan.

.. note::
   As with other CLI flags, you can also use `exclude-path:` in
   ``thor.yml`` to avoid having to specify excludes each time.

THOR does not scan the contents of these directories. This is useful for
excluding sensitive files such as databases or directories with very
large amounts of content. If you want to suppress false positives
generated in these directories, see the section on
``false_positive_filters.cfg`` below.

The flag accepts regular expressions that are applied to each scanned
element. Each element consists of the full file path and file name, for
example ``C:\IBM\temp_tools\custom.exe``. If one of the defined
expressions matches, the element is excluded. Exclusions can match the
full element name, the beginning, the end, or any part of the name.

.. note::
   If used in combination with flags like ``--path-remap`` that
   change the original path on the filesystem, the exclusions are
   applied to the real path on the filesystem, not the original path.

   For example, when using ``--path-remap F:C`` and
   scanning a file located at ``F:\Windows\explorer.exe``,
   THOR will check if ``F:\Windows\explorer.exe`` is excluded,
   not if ``C:\Windows\explorer.exe`` is excluded.

Because exclusions are treated as regular expressions, special
characters must be escaped with a backslash. This applies at least to:
``[]\^$.\|?\*+()-``

.. list-table::
   :header-rows: 1
   :widths: 60, 40

   * - Element to exclude
     - Possible solution
   * - C:\\IBM\\temp\_tools\\custom.exe
     - ``C:\\IBM\\temp_tools\\``
   * - Log folder of the tool "hpsm" regardless on the partition
     - ``\\HPSM\\log\\``
   * - Every file with the extension .nsf
     - ``\.nsf$``
   * - THOR custom signatures
     - ``\\THOR\\custom\-signatures\\``
   * - SQL database
     - ``/var/lib/mysql/``

Eventlogs
^^^^^^^^^

Event Log sources can be excluded entirely with
``--exclude-eventlog``.

The flag can be specified multiple times. Each instance expects a
regular expression that is applied to the Event Log name, for example
``Microsoft-Windows-Windows Defender/Operational``.

.. list-table::
   :header-rows: 1
   :widths: 60, 40

   * - Element to exclude 
     - Possible solution 
   * - Windows PowerShell 
     - Windows PowerShell 
   * - Microsoft-Windows-Windows Defender/Operational
     - Windows Defender

Registry
^^^^^^^^

Registry paths and keys can be excluded with
``--exclude-registry-key``.

The flag can be specified multiple times. Each instance expects a
regular expression that is applied to each registry key, for example
``Software\\WOW6432Node``. Do not include the root of the key, for
example ``HKLM``.

.. list-table::
   :header-rows: 1
   :widths: 50, 50

   * - Element to exclude 
     - Exclude Definition 
   * - ``HKEY_LOCAL_MACHINE\Software\Wow6432Node\Symantec\Symantec Endpoint Protection\AV\Exclusions``
     - Symantec Endpoint Protection\\AV\\Exclusions 

Process
^^^^^^^

Processes can be excluded with ``--exclude-process``.

The flag can be specified multiple times. Each instance expects a
regular expression. The expressions are applied to the process name,
image path, and command line. If any of these match, the process is not
analyzed.

Processes are also excluded if their executable file is excluded with
``--exclude-path``.

False Positives
^^^^^^^^^^^^^^^

False positive filters work similarly to directory and file exclusions.
A regular expression is applied to the **full** event, excluding the
event header, for example
``Sep 14 12:07:07 some-hostname/192.168.0.20``.

For example, if you want to exclude all messages that contain the string
``Trojan_Buzus_dev``, add this string to the
``false_positive_filters.cfg`` file. Because the file uses regular
expressions, you can also define patterns such as
``chinese_(charcode|keyboard)``.

Filter Verification
^^^^^^^^^^^^^^^^^^^

If you are unsure whether the configured filters behave as expected, we
recommend a short test run on a directory that matches the criteria.

You can start such a test run with:

.. code-block:: doscon
   
   C:\thor>thor.exe -a FileScan --deep -p C:\\TestDir
