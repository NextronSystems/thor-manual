.. Index:: Scan Output

Scan Output
===========

THOR creates several files during and at the end of the scan.

* **Real Time**

  * The text and JSON log files are written during the scan process.
    Syslog output is also sent in real time to one or more remote
    systems.

* **End of Scan**

  * The full HTML report and the CSV file with suspicious Filescan
    elements are written at the end of the scan.

You can define different formatting options for both text log and
syslog output.

JSON File Output (.jsonl)
^^^^^^^^^^^^^^^^^^^^^^^^^

The JSON log file is written by default. It provides scan results in a
structured, machine-readable format. See the
[JSON log schema](https://github.com/NextronSystems/jsonlog) for a
detailed description of the format.

* **--no-json**

  * Do not create a JSON log file

Log File Output (.txt)
^^^^^^^^^^^^^^^^^^^^^^

The text log file is written only when explicitly enabled. It provides
the text log format that was the default in THOR 10.

* **--text log.txt**

  * Create a text log file

The log file format matches the format of syslog messages, which makes
it easy to import into most SIEM or log analysis systems.

CSV Output (.csv)
^^^^^^^^^^^^^^^^^

CSV output is an optional legacy output format with limited detail. It
contains only ``Filescan`` findings and consists of three columns:
file hash, file path, and score.

CSV File Output:

.. literalinclude:: ../examples/csv-example.csv
   :language: none
   :linenos:

If you need more detail than the CSV file provides, use the JSON output
instead.

CSV Stats
^^^^^^^^^

The CSV stats file is an optional output file that contains only scan
statistics. It consists of a single line with:

 - Hostname
 - Scan start
 - Scan end
 - THOR version
 - Command line flags
 - Number of alerts
 - Number of warnings
 - Number of notices
 - Number of errors

CSV Stats Output:

.. code-block::

   HYPERION,2025-02-17 17:01:25,2025-02-17 17:01:28,11.0.0,--lab --path C:\temp --stats-csv HYPERION.csv,5,2,3,0

Placeholders
^^^^^^^^^^^^

Two placeholders can be used in command-line parameters to make them
easier to reuse across operating systems.

* <hostname>
* <time>

These placeholders can be used in command-line parameters and scan
templates across all platforms.

.. code-block:: doscon

   C:\thor>thor64.exe -a FileScan -p S:\\ -o "<hostname>\_<time>.csv"

Console Output
^^^^^^^^^^^^^^

The output THOR writes to the console is based on the text log format,
but excludes some header information, for example the time of each log
entry.

It can be customized with the following flags:

* **--console-json**

  * Print JSON to the console, for example for Splunk scripted input

* **--console-key-value**

  * Print console output in ``KEY="VALUE"`` format, for example for
    Splunk scripted input

Audit trail
^^^^^^^^^^^

Audit trail output differs from the other output options. Usually, THOR
prints only elements such as files or registry entries that matched a
signature. Audit trail mode, by contrast, contains *all* scanned
elements, including those that THOR considers inconspicuous, as well as
their relations to each other.

This information can be used to visualize relationships between
elements, group suspicious items, and discover additional suspicious
elements laterally.

Output format
~~~~~~~~~~~~~

Audit trail output is written as a gzipped JSON file. The output file
can be specified with ``--audit-trail my-target-file.json.gz``.

The file contains newline-delimited JSON. Each JSON object follows the
following schema:

.. code-block:: json

   {
      "id": "string",
      "object": {
         "...": "..."
      },
      "timestamps": {
         "...": "..."
      },
      "reasons": [
         {
            "summary": "string",
            "score": "int",
            "...": "..."
         }
      ],
      "references": [
         {
            "target_id": "string",
            "relation_name": "string",
            "relation_type": "string"
         }
      ]
   }

- ``id`` contains a unique ID for the element
- ``object`` contains the matched element
- ``timestamps`` contains all timestamps found within this element
- ``reasons`` contains a list of signatures that matched this element
- ``references`` contains a list of IDs of other elements referenced by
  this element

Timestamps
^^^^^^^^^^

Timestamps in all modules use the **ANSI C** format:

.. code-block:: none

   Mon Jan  2 15:04:05 2006
   Mon Mar 19 09:04:05 2018

[Go time format reference](https://go.dev/src/time/format.go)

UTC
~~~

The ``--timestamp-utc`` parameter forces all timestamps to use UTC.

RFC3339 Time Stamps
~~~~~~~~~~~~~~~~~~~

The ``--timestamp-rfc3339`` parameter generates UTC timestamps in the
RFC 3339 format. Unlike the default format, RFC 3339 timestamps include
the year and look like this:

.. list-table::

  * - 2017-02-31T23:59:60Z

SCAN ID
^^^^^^^

The ``-scan-id`` parameter allows you to set a specific scan ID
(``SCANID``) that appears in every log line.

The scan ID helps SIEM and analysis systems correlate log lines from
multiple scans on a single host. Without it, questions such as the
following become difficult to answer:

* How many scans completed successfully on a certain endpoint?
* Which scan on a certain endpoint terminated during the scan run?

If no parameter is set, THOR automatically generates a random scan ID
that starts with ``S-`` and uses the characters
``a-zA-Z0-9_-``.

.. list-table::
   :header-rows: 1

   * - Example ScanIDs
   * - S-Rooa61RfuuM
   * - S-0vRKu-1\_p7A

You can override the scan ID with ``-scan-id myscanid`` to assign the
logs of multiple scan runs to a single logical scan, for example when
different partitions of a system are scanned separately in the lab but
should appear as a single scan in Analysis Cockpit or a SIEM.

In a log line, it looks like this, with line breaks added and content
shortened for readability:

.. code-block:: none

    Oct  2 11:19:14 arch/10.1.1.1 THOR: Warning: 
      MODULE: Filescan
      MESSAGE: Suspicious file found
      SCANID: S-Oro8r7WLkGA
      FILE: /samples/DSU.py EXTENSION: .py TYPE: Script
      SHA256: a1c06037ec4a23763b97911511991ec8c45d48df678dbf30602d8eaf0774abd3
      MODIFIED: Wed Sep  2 17:18:04.000 2020
      SIZE: 21811
      SCORE: 65
      REASON_1: YARA rule SUSP_Chmod_SetUid_Temp_Folder_Jul23 / Detects suspicious command that sets the setuid for a file in temp folders

Custom Scan ID Prefix
~~~~~~~~~~~~~~~~~~~~~

You can set a custom prefix with ``--scan-id-prefix``. The fixed
character ``S`` can be replaced with any custom string. This allows you
to define an identifier for a group of scans that should be grouped
together in a SIEM or Analysis Cockpit.

Personal Information
^^^^^^^^^^^^^^^^^^^^

THOR provides a ``--no-personal-data`` option that filters output
messages and replaces known locations and fields that may contain user
names or user IDs with the value ``ANONYMIZED_BY_THOR``.

Specifically, it:

* Replaces all ``USER`` and ``OWNER`` field values in all modules with
  the anonymized string
* Replaces subfolder names under ``C:\Users`` and
  ``C:\Documents and Settings`` with the anonymized string

There is no guarantee that all user identifiers will be removed, as
they can appear in unexpected locations. In most cases, however, this
approach is sufficient to support data protection requirements.
