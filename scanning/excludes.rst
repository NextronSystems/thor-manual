.. Index:: Exclude Elements

Exclude Elements
----------------

This chapter shows how specific paths and/or elements
can be excluded from your THOR scan.

Files and Directories
^^^^^^^^^^^^^^^^^^^^^

You may use the ``--exclude-path`` flag to exclude directories and
files from the scan.

.. note::
   As with other CLI flags, you can also use `exclude-path:` in
   ``thor.yml`` to avoid having to specify excludes each time.

THOR will not scan the contents of these directories. This
configuration is meant to avoid scanning sensitive
files like databases or directories with a lot of content. If you want
to suppress false positives that are generated in these directories,
please see the following chapter and how to suppress them by using
``false_positive_filters.cfg``.

The flag receives regular expressions that are applied to each
scanned element. Each element consists of the file path and file name
(e.g. ``C:\IBM\temp_tools\custom.exe``). If one of the defined
expressions matches, the element is excluded. Exclusions can be defined
for a full element name, at the beginning, at the end or somewhere in the
element name.

.. note::
   If used in combination with flags like ``--path-remap`` that
   change the original path on the filesystem, the exclusions are
   applied to the real path on the filesystem, not the original path.

   For example, when using ``--path-remap F:C`` and
   scanning a file located at ``F:\Windows\explorer.exe``,
   THOR will check if ``F:\Windows\explorer.exe`` is excluded,
   not if ``C:\Windows\explorer.exe`` is excluded.

As the configured exclusions are treated as regular expressions, special
characters must be masqueraded by backslash. This applies at least for:
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

Eventlog sources can be excluded as whole with
"**--exclude-eventlog**".

The flag can be specified multiple times and
expects a regular expression each time that it applies
on the name of the Eventlog.
(e.g. ``Microsoft-Windows-Windows Defender/Operational``)

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

Registry paths/keys can be excluded with ``--exclude-registry-key``.

The flag can be specified multiple times and
expects a regular expression each time that it applies to each
registry key (e.g. “Software\\WOW6432Node“). Don't
include the root of the key, e.g. HKLM.

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

The flag can be specified multiple times and
expects a regular expression each time.
These regular expressions are applied to process name, image path, and
command line; if any of these match, the process is not analyzed.

Processes are also excluded if their executable file is excluded with
``--exclude-path``.

False Positives
^^^^^^^^^^^^^^^

The false positive filters work like the directory/file excludes. A
regular expression is applied to the **full** event, excluding the event
header (e.g. ``Sep 14 12:07:07 some-hostname/192.168.0.20``).

E.g. if you want to Exclude all messages that contain the string
``Trojan_Buzus_dev`` you just add this string to the
``false_positive_filters.cfg`` file. The file works with regular
expressions so you could also define something like
``chinese_(charcode|keyboard)``.

Filter Verification
^^^^^^^^^^^^^^^^^^^

If you are unsure about the filters you just set, we recommend a test
run on a certain directory that matches the criteria.

You can start a short test run on a certain directory with:

.. code-block:: doscon
   
   C:\nextron\thor>thor.exe -a FileScan --deep -p C:\\TestDir
