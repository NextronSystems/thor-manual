.. Index:: Configuration

Configuration
=============

This chapter contains information on how to configure
THOR to your liking. This ensures that your scan results
are consistent across your environment.

Scan Templates
--------------

THOR accepts config files (called "templates") in YAML format. They
reflect all command options to make them flexible and their use as
comfortable as possible.

This means that every parameter set via command line can be provided in
the form of a config file. You can even combine several of these config
files in a single scan run.

Default Template
^^^^^^^^^^^^^^^^

By default, THOR only applies the file named ``thor.yml`` in the
``./config`` sub folder. Other config files can be applied using the
``-t`` command line parameter.

Apply Custom Scan Templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command line provides a custom scan template named
``mythor.yml`` in the ``config`` directory.

.. code-block:: doscon
   
  C:\nextron\thor>thor.exe -t config\mythor.yml

Example Templates
^^^^^^^^^^^^^^^^^

The default config ``thor.yml`` in the ``./config`` folder has the
following content.

Content of THOR's Default Config ``thor.yml``:

.. literalinclude:: ../examples/thor.yml
   :language: yaml
   :linenos:

Content of Config File ``mythor.yml``:

.. literalinclude:: ../examples/mythor.yml
   :language: yaml
   :linenos:

The default scan template is always applied first. Custom templates can
then overwrite settings in the default template. In the example above,
the ``cpu-limit`` and ``file-size-limit`` parameters are overwritten by
the custom template.

As you can see in the example file, you have to use the long form of the
command line parameter (e.g. ``remote-log``) and not the short form (e.g.
``-s``) in the template files. The long forms can be looked up in the
command line help using ``--help full``.

.. figure:: ../images/image20.png
   :alt: Lookup command line parameter long forms using --help full

   Lookup command line parameter long forms using ``--help full``

CPU Limit
---------

Since the ``--cpu-limit`` behavior can cause some confusion, we will
explain the functionality of it a bit more in detail here.

This argument will take an integer (default 95; minimum 15), which
represents the maximum CPU load at which THOR will be actively scanning.
The value can be seen as percentage of the systems maximum CPU load.

This can be helpful to reduce the load on server systems with real-time
services, or to reduce the noise produced by fans in laptops.
      
The specified value instructs THOR to pause (all scanning), if the load
of the systems CPU is higher than the ``cpu-limit``. One example would be,
if a user is doing something CPU intensive, and THOR is running at the same
time, THOR will pause and wait until the CPU load drops below the limit
before continuing.

To illustrate this a bit, please see the table below:

.. list-table:: --cpu-limit 40
   :header-rows: 1

   * - Total CPU load of system
     - THOR status
   * - 20 %
     - running
   * - 80 % (user is running CPU intensive tools)
     - paused/idle
   * - 30 %
     - running

.. hint::
   A tool like ``top`` might show values greater than 100% for a running THOR
   process. Please see ``Irix Mode`` in the man page of
   ``top``: https://man7.org/linux/man-pages/man1/top.1.html

File Size Limit
---------------

The default file size limit for deeper investigations (hash
calculation and YARA scanning) is 30 MB. The file size limit for the
``--deep`` scan mode is 200 MB.

You can adjust the values in ``./config/thor.yml``. This file does not
get overwritten by an update or upgrade.

Special scan features like the EVTX or Memory Dump scan ignore these
limits. See :ref:`scanning/scan-modes:scan modes` for a full list of features
and how they interact with the file size limit.

Chunk Size in DeepDive
^^^^^^^^^^^^^^^^^^^^^^

The chunk size in DeepDive module is set to the value defined as 
``--chunk-size``. DeepDive uses overlapping chunks of this size for 
YARA rule scanning.

Example: If the chunk size is set to a default of 12 MB, DeepDive use the
following chunks in its scan to apply the YARA rule set:

.. code-block:: 

   Chunk 1: Offset 0 – 12
   Chunk 2: Offset 6 – 18
   Chunk 3: Offset 12 – 24
   Chunk 4: Offset 18 – 30

Exclude Elements
----------------

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
        If used in combination with flags like ``--virtual-map`` that
        change the original path on the filesystem, the exclusions are
        applied to the real path on the filesystem, not the original path.

        For example, when using ``--virtual-map F:C`` and
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
   
   C:\nextron\thor>thor.exe -a FileScan --intense -p C:\\TestDir

Personal Information
^^^^^^^^^^^^^^^^^^^^

THOR features an option named ``--no-personal-data`` that allows to filter the output
messages and replace all known locations and fields that can contain
user names or user ids with the value ``ANONYMIZED_BY_THOR``.

What it does is:

* Replace all "USER" and "OWNER" field values of all modules with the anonymized string value
* Replaced the subfolder names of ``C:\Users`` and ``C:\Documents and Settings`` with the anonymized string value

There is no guarantee that all user IDs will be removed by the filter,
as they may appear in the most unexpected locations, but in most cases
this approach is sufficient to comply with data protection requirements.
