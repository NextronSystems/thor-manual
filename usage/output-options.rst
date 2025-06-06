
Output Options 
==============

Scan Output
-----------

THOR creates several files during and at the end of the scan.

* **Real Time**
  
  * the text log file is written during the scan process.
    Also the SYSLOG output is sent in real-time to one or more remote
    systems.

* **End of Scan**

  * the full HTML report and CSV file with all file scan
    elements reported as suspicious are written at the end of the scan.

You can define different formatting options for each the FILE and the
SYSLOG output.

Placeholders
^^^^^^^^^^^^

Two placeholders can be used in command line parameters to facilitate
the use of parameter on different operating systems.

* \:hostname\:
* \:time\:

These can be used in command line parameters and scan templates across
all platforms.

.. code-block:: doscon

   C:\thor>thor64.exe -a FileScan -p S:\\ -o :hostname:\_:time:.csv

Log File Output (.txt)
^^^^^^^^^^^^^^^^^^^^^^

The standard log file is written by default.

* **--nolog**
  
  * Don't create a log file

* **--logfile filename**
  
  * Set a filename for the log file

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

Be aware that archives with matches show up as
“archive.zip\|file-with-finding.js” (pipe separator) in the second
column.

If you need more columns in that CSV, consider processing the JSON
output instead. To do this, you can use ``thor-util`` to convert
logs from one format to the other:

https://thor-util-manual.nextron-systems.com/en/latest/usage/log-conversion.html

CSV Stats
^^^^^^^^^

The CSV stats file is an optional output file that contains only the
scan statistics. It contains a single line with:

Hostname, scan start, scan end, THOR version, used command line flags,
number of alerts, number of warnings, number of notices and number of
errors

CSV Stats Output:

.. list-table::

   * - HYPERION,2021-02-17 17:01:25,2021-02-17 17:01:28,10.6.2,--lab -p C:\temp -o HYPERION:time:.csv --csvstats,5,2,3,0

JSON Output (.json)
^^^^^^^^^^^^^^^^^^^

The JSON output file can be configured with these options:

* **--json** (deprecated since THOR 10.7, use ``--jsonv2``)
  
  * Create a JSON output file

* **--jsonv2** (THOR >= 10.7)

  * Use the JSON v2 format, which is easier to parse than the old v1 format.
  * This can be used with ``--jsonfile``.

* **--jsonfile filename**
  
  * Log file for JSON output. If no value is specified, defaults to ``:hostname:_thor_:time:.json``.

* **--cmdjson**
  
  * Print JSON format into the command line (e.g. used with Splunk
    scripted input)

* **--syslog [syslogtarget]:[port]:SYSLOGJSON**
  
  * Send syslog messages with JSON formatting

Key Value Output
^^^^^^^^^^^^^^^^

THOR provides the option to create a "Key/Value" pair output that
simplifies the SIEM integration.

By using the "**--keyval**" option you get the text and syslog output
transformed as shown in the following example. The command line output
stays untouched by this setting.

There are three different Key Value Pair Formatting flags:

* **--keyval**
  
  * Write key/value pairs to the log file

* **--cmdkeyval**
  
  * Print key/value pairs in the command line (e.g. used with Splunk
    scripted input)
* **--syslog [syslogtarget]:[port]:SYSLOGKV**
  
  * Send syslog messages with proper key/value formatting

.. list-table::
   :header-rows: 1

   * - Default - Without "--keyval" parameter
   * - Jul 10 09:08:47 PROMETHEUS/10.0.2.15 THOR: Alert: MODULE: SHIMCache MESSAGE: Malware name found in Shim Cache Entry ENTRY: C:\\Users\\neo\\Desktop\\ncat.exe KEYWORD: \\\\ncat\\.exe DATE: 07/29/13 05:16:04 TYPE: system HIVEFILE: None EXTRAS: N/A N/A True

.. list-table::
   :header-rows: 1

   * - Key/Value Pairs - With "--keyval" parameter
   * - Jul 10 09:07:59 PROMETHEUS/10.0.2.15 THOR : Alert: MODULE="SHIMCache" MESSAGE="Malware name found in Shim Cache Entry" ENTRY="C:\\Users\\neo\\Desktop\\ncat.exe" KEYWORD="\\\\ncat\\.exe" DATE="07/29/13 05:16:04" TYPE="system" HIVEFILE="None" EXTRAS="N/A N/A True"

Output format
~~~~~~~~~~~~~
The Audit Trail Log feature in THOR provides users with a comprehensive, structured, and
detailed JSON record of all forensic artifacts and findings encountered during a scan.
It captures this information in a dedicated gzipped JSON file, designed to support forensic workflows that require detailed traceability —
including both malicious and benign objects.

When activated using the `--audit-trail`` command-line option, the audit trail logs include:
* **All scan findings**, including detections from all THOR modules.
* **Analyzed objects** not detected by any module.
* **Structural relationships** between detected and non-detected elements (e.g., archive contents, extracted files).
The audit trail log integrates seamlessly into existing forensic workflows, allowing analysts to effectively use external timeline explorers and analysis tools. This comprehensive logging provides essential context, significantly improving the efficiency and accuracy of investigations.

If a filename is not specified, THOR automatically creates one using the pattern <hostname>_audit_<timestamp>.json.gz
### Audit Trail JSON Schema
The generated audit trail JSON file adheres to the following schema:
.. code-block:: json

   {
  "info": {
    "Name": "string",
    "Timestamps": {
      "...": "...",
    },
    "Id": "string",
    "Details": {
      "...": "...",
    }
  },
  "findings": [
    {
      "Level": "string",
      "Message": "string",
      "Module": "string",
      "Timestamps": {
        "...": "...",
      },
      "Details": {
        "...": "...",
        "reasons": [
          {
            "name": "string",
            "score": "int",
            "...": "..."
          },
        ]
      }
    }
  ],
  "references": [
    {
      "TargetId": "string"
    },
  ]
}

### Field Descriptions

#### `info`

* **Name**: Identifier of the scanned object or host.
* **Timestamps**: Relevant timestamp data (creation, modification, scan time).
* **Id**: Unique identifier of the scanned object.
* **Details**: Additional metadata providing context.

#### `findings[]`

* **Level**: Severity of the finding (e.g., alert, warning, notice).
* **Message**: Description of the detection.
* **Module**: THOR module responsible for the detection.
* **Timestamps**: Timestamps associated with the finding.
* **Details**: Contextual data and additional information.

  * **reasons\[]**: Reasons or rules that triggered the detection.

    * **name**: Name of the signature or rule.
    * **score**: Numeric severity or confidence score.

#### `references[]`

* **TargetId**: IDs referencing related artifacts, allowing analysts to map relationships and conduct deeper investigations.


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

The former parameter ``-i``, which has been used for so-called case IDs
(CID) has been repurposed to allow users to set a certain scan ID
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

Users can overwrite the scan ID with ``-i myscanid`` to assign the logs of
multiple scan runs to a single logical scan, e.g. if multiple partitions
of a system get scanned in the lab in different scan runs, but should be
shown as a single scan in Analysis Cockpit or your SIEM of choice.

In a log line, it looks like (set newlines for readability):

.. code-block:: none

   Jul 10 09:08:47 PROMETHEUS/10.0.2.15 THOR: Alert:
     MODULE: SHIMCache
     SCANID: S-r4GhEhEiIRg
     MESSAGE: Malware name found in Shim Cache Entry
     ENTRY: C:\Users\neo\Desktop\ncat.exe
     KEYWORD: \\ncat\.exe
     DATE: 07/29/13 05:16:04
     TYPE: system
     HIVEFILE: None
     EXTRAS: N/A N/A True

Custom Scan ID Prefix
~~~~~~~~~~~~~~~~~~~~~

Since THOR version 10.5 you are able to set you custom prefix by using
``--scanid-prefix``. The fixed character "S" can be replaced with any
custom string. This allows users to set an identifier for a group of
scans that can be grouped together in a SIEM or Analysis Cockpit.

Syslog or TCP/UDP Output
------------------------

Target Definition
^^^^^^^^^^^^^^^^^

THOR version 10 comes with a very flexible Syslog target definition. You
can define as many targets as you like and give them different ports,
protocols and formats.

For example, if you want to send the THOR log entries to a Syslog server
and an ArcSight SIEM at the same time, you just have to define two log
targets with different formats.

.. code-block:: doscon
   
   C:\nextron\thor>thor.exe -s syslog1.server.net -s arsight.server.net:514:CEF

The definition consists of 4 elements:

+----------+-----+--------+-----+--------+-----+------------+
| System   | :   | Port   | :   | Type   | :   | Protocol   |
+----------+-----+--------+-----+--------+-----+------------+

The available options for each element are:

.. code-block:: none

   (target ip):(target port):(DEFAULT/CEF/JSON/SYSLOGJSON/SYSLOGKV):(UDP/TCP/TCPTLS)

The available type field values require an explication:

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

There are default values, which do not have to be defined explicitly:

.. code-block:: none

   (your target system ip):514:DEFAULT:UDP

Sending Syslog to a target on a port that differs from the default port
514/udp looks like this:

.. code-block:: none

   --syslog 10.0.0.4:2514

Sending Syslog to a receiving server using an SSL/TLS encrypted TCP
connection:

.. code-block:: none

   --syslog 10.0.0.4:6514:DEFAULT:TCPTLS

You can define as many targets as you like.

An often used combination sends JSON formatted messages to a certain UDP port:

.. code-block:: none 

   --syslog 10.0.0.4:5444:JSON:UDP

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
``--encrypt`` parameter. A second parameter ``--pubkey`` can be used to
specify a public key to use. The public key must be an RSA key of 1024,
2048 or 4096 bit size in PEM format.

.. code-block:: doscon
 
   C:\nextron\thor>thor64.exe --encrypt --pubkey mykey.pub

If you don't specify a public key, THOR uses a default key. The private
key for this default key is stored in "thor-util", which can be used to
decrypt output files encrypted with the default key.

.. code-block:: console

   nextron@unix:~$ thor-util decrypt file.txt

For more information on "thor-util" see the separate `THOR Util manual <https://thor-util-manual.nextron-systems.com/en/latest/>`__.
