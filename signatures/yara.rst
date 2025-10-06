.. Index:: Yara Rules

YARA Rules
~~~~~~~~~~

THOR allows you include your own custom YARA rules.
YARA rules must have the **.yar** extension for plain text YARA rules
and the **.yas** extension for encrypted YARA rules. (the rules can be encrypted using THOR Util)

Custom YARA rules have to be saved to the ``.\custom-signatures\yara`` folder.
In order to apply only custom YARA rules and IOCs, use the ``--custom-signatures-only`` flag. 

There are two custom YARA rule types that you can define in THOR:

- Generic Rules
- Specific Rules

Generic YARA Rules
^^^^^^^^^^^^^^^^^^

All YARA rules which do not contain any specific tag (see :ref:`signatures/yara:Specific YARA Rules`)
are considered generic YARA rules.

The generic YARA rules are applied to the following elements:

* | Files
  | THOR applies the Yara rules to all files that are smaller than the size limit set in the **thor.yml** and matches specific rules.:ref:`signatures/creating-yara-rules:Additional Attributes` are available.
* | Process Memory
  | THOR scans the process memory of all processes with a working set memory size up to a certain limit. This limit can be altered by the "**--process-size-limit**" parameter.
* | Data Chunks
  | The rules are applied to the data chunks read during the DeepDive scan.

The following table shows in which modules the Generic YARA rules are
applied to content.

.. list-table::
   :header-rows: 1
   :widths: 55, 45

   * - Applied in Module
     - Examples
   * - Filescan, ProcessCheck, DeepDive
     - incident-feb17.yar
       
       misp-3345-samples.yar

Specific YARA Rules
^^^^^^^^^^^^^^^^^^^

The specific YARA rules contain certain tags in their filename to
differentiate them further:

* | Registry Keys
  | Tag: **'registry'**
  | Rules are applied to a whole key with all of its values. See :ref:`signatures/yara:THOR YARA Rules for Registry Detection` for more details.
* | Log Files
  | Tag: **'log'**
  | Rules are applied to each log entry. See :ref:`signatures/yara:THOR YARA Rules for Log Detection` for more details.
* | Process Memory
  | Tag: **'process'** or **'memory'**
  | Rules are applied to process memory only.
* | All String Checks
  | Tag: **'keyword'**
  | Rules are applied to all objects that are checked.
* | Metadata Checks
  | Tag: **'meta'**
  | Rules are applied to all files without exception, including directories, symlinks and the like, but can only access the THOR specific external variables (see :ref:`signatures/creating-yara-rules:Additional Attributes`) and the first 64KB of the file.
  | If a metadata rule has the special tag DEEPSCAN, THOR will perform a YARA scan on the full file with the default rule set (see :ref:`signatures/yara:Generic YARA Rules`).
  | When symlinks are scanned with the meta rules, the file content is their target path.
  | When directories are scanned with the meta rules, the file content is the directory listing (as file names, separated by newlines).

The following table shows in which modules the specific YARA rules are
applied to content.

.. list-table::
  :header-rows: 1
  :widths: 20, 45, 35

  * - Tag in File Name
    - Applied in Module
    - Examples
  * - registry
    - RegistryChecks, RegistryHive
    - incident-feb17-**registry**.yar
  * - log
    - Eventlog, Logscan, EVTX, ETL, Auditlog, Journald
    - general-**log**-strings.yar
  * - process
    - ProcessCheck (only on process memory)
    - case-a23-**process**-rules.yar
  * - keyword
    - All
    - misp-3345-**keyword**-extract.yar
  * - meta
    - Filescan
    - **meta**-rules.yar

THOR YARA Rules for Registry Detection
**************************************

THOR allows checking a complete registry key with Yara
rules. To accomplish this, THOR composes a string from the registry key's values
and formats them as follows:

| **KEYPATH;VALUENAME;VALUE\\n**
| **KEYPATH;VALUENAME;VALUE\\n**
| **KEYPATH;VALUENAME;VALUE\\n**

**Registry Base Names**

Please notice that strings like HKEY\_LOCAL\_MACHINE, HKLM, HKCU,
HKEY\_CURRENT\_CONFIG are **not** part of the key path that your YARA rules
are applied to. They depend on the analyzed hive and should not be in
the strings that you define in your rules.

Values are formatted as follows:

 - REG\_BINARY values are hex encoded with upper case.
 - REG\_MULTI\_SZ values are printed with ``\\0`` separating the multiple strings.
 - Numeric values are printed normally (with base 10; e.g., use ``32`` for REG_DWORD 0x00000020).
 - String values are printed normally.

This means that you can write a Yara rule that looks like this (remember
to escape all backslashes):

.. code-block:: yara

        rule Registry_DarkComet {
                meta:
                        description = "DarkComet Registry Keys"
                strings:
                        $a1 = "LEGACY_MY_DRIVERLINKNAME_TEST;NextInstance"
                        $a2 = "\\Microsoft\\Windows\\CurrentVersion\\Run;MicroUpdate"
                        $a3 = "Path;Value;4D5A00000001" # REG_BINARY value
                        $a4 = "Shell\\Open;Command;explorer.exe\\0comet.exe" # REG_MULTI_SZ value
                        $a5 = ";Type;32" # REG_DWORD 0x00000020
                condition:
                        1 of them
        }

Remember that you have to use the keyword **registry** in the file name in order to
initialize the YARA rule file as registry rule set (e.g. "**registry\_exe\_in\_value.yar**").

Registry scanning uses bulk scanning. See :ref:`signatures/rules:Bulk Scanning` for more details.

THOR YARA Rules for Log Detection
*********************************

YARA Rules for logs are applied as follows:

- For text logs, each line is passed to the YARA rules.
- For Windows Event Logs, each event is serialized as follows for the YARA rules:
  ``Key1: Value1  Key2: Value2  ...``
  where each key / value pair is an entry in EventData or UserData in the XML representation of the event.

Log (both text log and event log) scanning uses bulk scanning.
See :ref:`signatures/rules:Bulk Scanning` for more details.

Remember that you have to use the keyword **log** in the file name in order to
initialize the YARA rule file as registry rule set (e.g. ``my_log_rule.yar``).
