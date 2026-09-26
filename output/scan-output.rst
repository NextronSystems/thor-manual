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
`JSON log schema <https://github.com/NextronSystems/jsonlog>`__ for a
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

   C:\thor>thor64.exe ^
     --module FileScan ^
     --path S:\\ ^
     --csv "<hostname>\_<time>.csv"

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

The audit trail is not a mode that is activated like the other modes
THOR knows. It is an additional output that is written while the normal,
configured scan is running: THOR scans exactly as it would otherwise and 
writes its regular output as usual, plus a separate audit trail file.

The audit trail also differs in content from the other output options. 
Usually, THOR reports only elements such as files or registry entries 
that matched a signature. The audit trail, by contrast, contains *all* 
scanned elements, including those that THOR considers inconspicuous, as 
well as their relations to each other. In addition, it contains the THOR
messages that were logged during the scan.

This information can be used to visualize relationships between elements, 
group suspicious items, and discover additional suspicious elements laterally.

Because the audit trail is a record of the scan that was actually performed, 
everything that limits the scope of that scan also limits the audit trail - 
module filters, time based filters, exclusions and similar restrictions. 
Elements that THOR never looks at cannot appear in it.

Filters that are applied to the output rather than to the scan have no 
effect on it. In particular, score based thresholds that control which 
findings end up in the regular output are ignored: the audit trail always 
contains all assessed elements, regardless of their score.

One exception exists: Log lines, eventlog entries, Linux audit log entries,
registry keys and values and journald entries occur in such large numbers
that they are only written if a signature matched
them, if they are connected to another element by more than a parent or
origin relation, or if other elements were derived from them.

``--no-personal-data`` also applies to the audit trail. ``--log-size-limit``
does not: it only counts the regular log output, so the size of the audit
trail file is not bounded by it. Log encryption does not apply either, the
audit trail is always written as a plain gzipped file.

Output format
~~~~~~~~~~~~~

Audit trail output is written as a gzipped JSONL file. The output file can
be specified with ``--audit-trail my-target-file.jsonl.gz``, or without a
value to write ``<hostname>_audit_<time>.jsonl.gz`` into the output directory.

The file contains newline-delimited JSON. Every object carries a ``type``
field that identifies the record.

Objects of type ``THOR audit trail`` describe a scanned element:

.. code-block:: json

   {
      "type": "THOR audit trail",
      "id": "string",
      "subject": {
         "type": "string",
         "...": "..."
      },
      "timestamps": {
         "...": "..."
      },
      "reasons": [
         {
            "summary": "string",
            "signature": {
               "score": "int",
               "...": "..."
            },
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
   {
      "type": "THOR message",
      "meta": {
         "time": "string",
         "level": "string",
         "module": "string",
         "scan_id": "string",
         "event_id": "string",
         "hostname": "string"
         },
      "message": "string",
      "fields": { "...": "..." },
      "log_version": "string"
   }

- ``id`` contains a unique ID for the element
- ``subject`` contains the scanned element
- ``timestamps`` contains all timestamps found within this element, in UTC.
  If the element has none, a single ``OBSERVED_AT`` entry with the time of
  observation is written instead
- ``reasons`` contains a list of signatures that matched this element
- ``references`` contains a list of IDs of other elements referenced by
  this element

Objects of type ``THOR message`` contain the messages that THOR logged
during the scan, in the same form as in the JSON log:

.. code-block:: json

   {
      "type": "THOR message",
      "meta": {
         "time": "string",
         "level": "string",
         "module": "string",
         "scan_id": "string",
         "event_id": "string",
         "hostname": "string"
      },
      "message": "string",
      "fields": {
         "...": "..."
      },
      "log_version": "string"
   }

The first object in the file is always such a message; its ``log_version``
states the version of the audit trail format. Debug messages are never
written to the audit trail and are found exclusively in the THOR report.

Timestamps
^^^^^^^^^^

The text log writes two kinds of timestamps. Every event starts with the
time it was written, always in UTC:

.. code-block:: none

   Aug  3 18:54:22

Timestamps within a message, such as the file times of a scanned file,
use the following format. The same format is used for the console output
and for the text based syslog formats:

.. code-block:: none

   Mon Jan  2 15:04:05 2006
   Mon Mar 19 09:04:05 2018

This format is known as the **ANSI C** format. See the
`Go time format reference <https://go.dev/src/time/format.go>`__ for its
exact definition.

The day of month is padded with a space, not with a zero, and no time
zone is given: These timestamps are in the local time zone of the scanned
system unless ``--timestamp-utc`` is set. ``--timestamp-rfc3339`` writes
them in RFC3339 format instead, which includes the timezone.

The JSON log and the audit trail are not affected by either option. They
always use RFC3339 with nanoseconds and always include the timezone.

UTC
~~~

``--timestamp-utc`` converts the timestamps of all scanned elements to UTC.
This applies to the text log, the JSON log and the audit trail alike. The
leading timestamp of each text log event is written in UTC in any case.

RFC3339 Time Stamps
~~~~~~~~~~~~~~~~~~~

The ``--timestamp-rfc3339`` parameter generates UTC timestamps in the
RFC 3339 format. Unlike the default format, RFC 3339 timestamps include
the year and look like this:

.. list-table::

  * - 2017-02-31T23:59:60Z

SCAN ID
^^^^^^^

The ``--scan-id`` parameter allows you to set a specific scan ID
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

You can override the scan ID with ``--scan-id myscanid`` to assign the
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
