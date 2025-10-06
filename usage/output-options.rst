
Output Options 
==============

Scan Output
-----------

THOR creates several files during and at the end of the scan.

* **Real Time**
  
  * the text and json log files are written during the scan process.
    Also the SYSLOG output is sent in real-time to one or more remote
    systems.

* **End of Scan**

  * the full HTML report and CSV file with all file scan
    elements reported as suspicious are written at the end of the scan.

You can define different formatting options for both text log and
SYSLOG output.

Placeholders
^^^^^^^^^^^^

Two placeholders can be used in command line parameters to facilitate
the use of parameter on different operating systems.

* <hostname>
* <time>

These can be used in command line parameters and scan templates across
all platforms.

.. code-block:: doscon

   C:\thor>thor64.exe -a FileScan -p S:\\ -o "<hostname>\_<time>.csv"

JSON File Output (.json)
^^^^^^^^^^^^^^^^^^^^^^^^

The JSON log file is written by default. It provides the scan results
in a structured, machine readable format. See https://github.com/NextronSystems/jsonlog
for a detailed description and schema of the output format.

* **--no-json**
  
  * Don't create a JSON log file

Log File Output (.txt)
^^^^^^^^^^^^^^^^^^^^^^

The text log file is written only when explicitly enabled. It provides the
text log format that was default for THOR 10.

* **--text log.txt**
  
  * Create a text log file

The log file's format aligns with the format of SYSLOG messages. This
way it can easily be imported to most SIEM or log analysis systems.

CSV Output (.csv)
^^^^^^^^^^^^^^^^^

The CSV output is an optional legacy output file without much details.
It contains only “Filescan” module findings and consist of 3 columns,
file hash, file path and score.

CSV File Output:

.. literalinclude:: ../examples/csv-example.csv
   :language: none
   :linenos:

If you need more information than the CSV provides, consider processing the JSON
output instead.

CSV Stats
^^^^^^^^^

The CSV stats file is an optional output file that contains only the
scan statistics. It contains a single line with:

 - Hostname
 - Scan start
 - Scan end
 - THOR version
 - Command line flags
 - number of alerts
 - number of warnings
 - number of notices
 - number of errors

CSV Stats Output:

.. list-table::

   * - HYPERION,2025-02-17 17:01:25,2025-02-17 17:01:28,11.0.0,--lab --path C:\temp --stats-file HYPERION.csv,5,2,3,0

Console Output
^^^^^^^^^^^^^^

The output THOR writes to the console is based on the text log format, but excludes some information in the header
(e.g. the time for each log entry).

It can be customized with the following flags:

* **--console-json**
  
  * Print JSON format into the console (e.g. used with Splunk
    scripted input)

* **--console-key-value**
  
  * Print console output in a ``KEY="VALUE"`` format (e.g. used with Splunk
    scripted input)

Audit trail
^^^^^^^^^^^

Audit trail output contains different output from the other output options.
Usually, THOR only prints elements (e.g. files, or registry entries) that have been matched on by some signature.
Audit trail mode, on the other hand, contains _all_ scanned elements, even those that THOR considers inconspicious,
as well as their relations to each other.

This information can be used to visualize these elements, and help with grouping suspicious elements or laterally
finding more suspicious elements.

Output format
~~~~~~~~~~~~~
Audit trail output is a gzipped JSON file. The file can be specified with ``--audit-trail my-target-file.json.gz``.

The file contains newline delimited JSON. where each contained JSON object follows the following schema:

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

- ``id`` contains a unique ID for the element that was matched on
- ``object`` contains the element that was matched on
- ``timestamps`` contains all timestamps found within this element
- ``reasons`` contains a list of signatures that matched on this element
- ``references`` contains a list of IDs of other elements that this element referred to in some way

Timestamps
^^^^^^^^^^

Timestamp in all modules are using the  **ANSI C** format:

.. code-block:: none

   Mon Jan  2 15:04:05 2006
   Mon Mar 19 09:04:05 2018

https://go.dev/src/time/format.go

UTC
~~~

The ``--utc`` parameter allows to use UTC in all timestamps.

RFC3339 Time Stamps
~~~~~~~~~~~~~~~~~~~

The parameter ``--rfc3339`` generates time stamps for UTC time in the
format described in RFC 3339. In contrast to the default time stamps RFC
3339 timestamps include a year and look like this:

.. list-table::

  * - 2017-02-31T23:59:60Z

SCAN ID
^^^^^^^

The parameter ``-scan-id`` allows users to set a certain scan ID
(SCANID) that appears in every log line.

The scan ID helps SIEM and analysis systems to correlate the scan lines
from multiple scans on a single host. Otherwise it would be very
difficult to answer the following questions:

* How many scans completed successfully on a certain endpoint?
* Which scan on a certain endpoint terminated during the scan run?

If no parameter is set, THOR will automatically generate a random scan
ID, which starts with an ``S-`` and contains the following
characters: ``a-zA-Z0-9_-``

.. list-table::
   :header-rows: 1

   * - Example ScanIDs
   * - S-Rooa61RfuuM
   * - S-0vRKu-1\_p7A

Users can overwrite the scan ID with ``-scan-id myscanid`` to assign the logs of
multiple scan runs to a single logical scan, e.g. if multiple partitions
of a system get scanned in the lab in different scan runs, but should be
shown as a single scan in Analysis Cockpit or your SIEM of choice.

In a log line, it looks like (set newlines and shortened for readability):

.. code-block:: none

    Oct  2 11:19:14 arch/10.1.1.1 THOR: Warning: 
      MODULE: Filescan
      MESSAGE: Suspicious file found
      SCANID: S-Oro8r7WLkGA
      FILE: /samples//DSU.py EXTENSION: .py TYPE: Script
      SHA256: a1c06037ec4a23763b97911511991ec8c45d48df678dbf30602d8eaf0774abd3
      MODIFIED: Wed Sep  2 17:18:04.000 2020
      SIZE: 21811
      SCORE: 65
      REASON_1: YARA rule SUSP_Chmod_SetUid_Temp_Folder_Jul23 / Detects suspicious command that sets the setuid for a file in temp folders

Custom Scan ID Prefix
~~~~~~~~~~~~~~~~~~~~~

You are able to set you custom prefix by using
``--scanid-prefix``. The fixed character "S" can be replaced with any
custom string. This allows users to set an identifier for a group of
scans that can be grouped together in a SIEM or Analysis Cockpit.

Syslog or TCP/UDP Output
------------------------

Target Definition
^^^^^^^^^^^^^^^^^

THOR version 10 comes with a very flexible remote log target definition. You
can define as many targets as you like and give them different ports,
protocols and formats.

For example, if you want to send the THOR log entries to a Syslog server
and an ArcSight SIEM at the same time, you just have to define two log
targets with different formats.

.. code-block:: doscon
   
   C:\nextron\thor>thor64.exe -s syslog1.server.net -s arsight.server.net:514:CEF

THOR supports two different definitions:

+----------+-----+--------+-----+--------+-----+------------+
| System   | :   | Port   | :   | Format | :   | Protocol   |
+----------+-----+--------+-----+--------+-----+------------+

Or: 

+----------+-----+--------+
| URL      | :   | Format |
+----------+-----+--------+

In the latter case, no protocol is specified as the URL's protocol (HTTP or HTTPS) is used.

Available formats
~~~~~~~~~~~~~~~~~

The available formats are:

.. list-table::
   :header-rows: 1
   :widths: 40, 60

   * - Option
     - Format
   * - DEFAULT
     - standard THOR log format
   * - CEF
     - Common Event Format (ArcSight)
   * - JSON
     - Raw JSON
   * - SYSLOGJSON
     - encoded and escaped single line JSON
   * - SYSLOGKV
     - syslog messages that contain strict key/value pairs

If not specified, the DEFAULT type is used.


Protocols
~~~~~~~~~

The protocols that can be specified are:

- UDP
- TCP
- TCPTLS

The default protocol is UDP.


Examples
~~~~~~~~

Sending Syslog to a target on a port that differs from the default port
514/udp looks like this:

.. code-block:: none

   --remote-log 10.0.0.4:2514

Sending logs to a receiving server using an SSL/TLS encrypted TCP
connection:

.. code-block:: none

   --remote-log 10.0.0.4:6514:DEFAULT:TCPTLS

Sending JSON logs to an HTTP webhook:

.. code-block:: none

   --remote-log https://my-webhook.internal:6514/receive:JSON

Sending JSON formatted messages to a certain UDP port:

.. code-block:: none 

   --remote-log 10.0.0.4:5444:JSON:UDP

Common Event Format (CEF)
^^^^^^^^^^^^^^^^^^^^^^^^^

THOR supports the CEF format for easy integration into ArcSight SIEM
systems. The CEF mapping is applied to a log line if the syslog target
has the CEF format set, e.g.:

.. code-block:: doscon

   C:\nextron\thor>thor.exe -s syslog1.server.local:514:CEF

Local Syslog
^^^^^^^^^^^^

If your Linux system is already configured to forward syslog messages,
you might just want to write to your local syslog and use the existing
system configuration to forward the events. This can be achieved by
using the ``--local-syslog`` flag.

THOR logs to the ``local0`` facility, which is not being written to a
file by default on every Linux distribution. By default Debian derivatives
log it to ``/var/log/syslog``; Others such as Red Hat do not. To enable
writing ``local0`` messages to a file a syslog configuration for
rsyslog (e.g. ``/etc/rsyslog.conf``) could look like:

.. code-block:: none

    # THOR --local-syslog destination
    local0.*        -/var/log/thor

Do not forget to restart the syslog daemon (e.g. ``systemctl restart rsyslog.service``).

You then either add that file in your syslog forwarding configuration
or write to a file that is already forwarded instead.

Encrypted Output Files
----------------------

THOR allows to encrypt the output files of each scan using the
``--encryption-key`` parameter. This parameter must receive an RSA public key of 1024,
2048 or 4096 bit size in PEM format.

.. code-block:: doscon
 
   C:\nextron\thor>thor64.exe --encryption-key mykey-public.pem

THOR Util can be used to decrypt the logs later on: 

.. code-block:: console

   nextron@unix:~$ thor-util decrypt --privkey mykey-private.pem thorlog.json

For more information on "thor-util" see the separate `THOR Util manual <https://thor-util-manual.nextron-systems.com/>`__.
