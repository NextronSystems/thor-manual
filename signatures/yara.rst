.. Index:: Yara Rules

YARA Rules
==========

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
  | THOR applies the Yara rules to all files that are smaller than the size limit set in the **thor.yml** and matches specific rules. :ref:`signatures/yara:Additional Attributes` are available.
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
  | Rules are applied to all files without exception, including directories, symlinks and the like, but can only access the THOR specific external variables (see :ref:`signatures/yara:Additional Attributes`) and the first 64KB of the file.
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

Additional Attributes
^^^^^^^^^^^^^^^^^^^^^

THOR provides certain external variables in your generic and meta YARA rules.
These external variables are:

* **filename**

  * single file name
  * Example: ``cmd.exe``

* **filepath**

  * file path without file name
  * Example: ``C:\temp``

* **extension**

  * file extension with a leading ``.``, lower case
  * Example: ``.exe``

* **filetype**

  * type of the file based on the magic header signatures
    (for a list of valid file types see:
    ``./signatures/misc/file-type-signatures.cfg``)
  * Example: ``EXE`` or ``ZIP``

* **timezone**

  * the system's time zone (see https://golang.org/src/time/zoneinfo_abbrs_windows.go for valid values)

* **language**

  * the systems language settings (see https://docs.microsoft.com/en-us/windows/win32/intl/sort-order-identifiers)

* **owner**

  * The file owner
  * Example: ``NT-AUTHORITY\SYSTEM`` on Windows
  * Example: ``root`` on Linux

* **group**

  * The file group
  * Example: ``root`` on Linux
  * This variable is empty on Windows

* **filemode**

  * file mode for this file (see https://man7.org/linux/man-pages/man7/inode.7.html, "The file type and mode").
  * On Windows, this variable will be an artificial approximation of a file mode since Windows is not POSIX compliant.

* **filesize**

  * The value contains the file size in bytes. It is provided directly by YARA and is not specific to THOR.

* **osversion**

  * The Windows build number (0 on non-Windows systems)

* **unpack_parent**

  * The file's origin (e.g. "ZIP" if it was contained in a ZIP file)
  * Possible values are:

    * Archives: ``ZIP``, ``RAR``, ``RAR``, ``TAR``, ``TARGZ``, ``TARBZ2``, ``CAB``, ``GZIP``, ``BZIP2``, ``7ZIP``
    * From a module: ``CHM``, ``CHUNK``, ``EMAIL``, ``ICS``, ``MACROS``, ``MFT``, ``OLE``, ``REGISTRY``, ``UNESCAPE``, ``UPX``, ``VBEDECODE``
    * From a plugin: user-defined via `Scanner.ScanFile <https://github.com/NextronSystems/thor-plugin/blob/ee8583e935f06737d5f83102e2adcd83bfad7ec6/thorplugin.go#L112>`__ from a `THOR plugin <https://github.com/NextronSystems/thor-plugin>`__.

* **unpack_source**

  * The file's origins, separated by ``>`` (e.g. ``EMAIL>ZIP`` if it was contained in a ZIP file that was an email attachment)
  * For possible values of a file's origin, see ``unpack_parent``.

* **permissions**

  * The permissions of the file.
  * On Unix systems, this is a string representation of the file mode.
  * On Windows, this contains the DACL of the file, separated with / (e.g "BUILTIN\Users:W / BUILTIN\Administrators:F")

* **age**

  * The file's age (in days), based on its creation timestamp.
  * If the file does not have a creation timestamp (e.g. because the underlying filesystem does not provide one), this is NaN.

Yara Rule with THOR External Variable:

.. code-block:: yara
   :linenos:

   rule demo_rule_enhanced_attribute_1 {
        meta:
             description = "Demo Rule - Eicar"
        strings:
             $a1 = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE"
        condition:
             $a1 and filename matches /eicar.com/
   }

A more complex rule using several of the THOR external variables would
look like the one in the following listing.

This rule matches to all files containing the EICAR string, having the
name "**eicar.com**", "**eicar.dll**" or "**eicar.exe**" and a file size
smaller 100byte.

Yara Rule with more complex THOR Enhanced Attributes.

.. code-block:: yara
   :linenos:

   rule demo_rule_enhanced_attribute_2 {
        meta:
             author = "F.Roth"
        strings:
             $a1 = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE"
        condition:
             $a1 and filename matches /eicar\.(com|dll|exe)/ and filesize < 100
   }

The following YARA rule shows a typical combination used in one of the
client specific rule sets, which are integrated in THOR. The rule
matches on ``.idx`` files that contain strings used in the Java
Version of the VNC remote access tool. Without the enhancements made
this wouldn't be possible as there would be no way to apply the rule
only to a special type of extension.

Real Life Yara Rule:

.. code-block:: yara
   :linenos:

   rule HvS_Client_2_APT_Java_IDX_Content_hard {
        meta:
             description = "VNCViewer.jar Entry in Java IDX file"
        strings:
             $a1 = "vncviewer.jar"
             $a2 = "vncviewer/VNCViewer.class"
        condition:
             1 of ($a*) and extension matches /\.idx/
   }

Restrict Yara Rule Matches
^^^^^^^^^^^^^^^^^^^^^^^^^^

On top of the keyword based initialization you can restrict Yara rules
to match on certain objects only. It is sometimes necessary to restrict
rules that e.g. cause many false positives on process memory to file
object detection only. Use the meta attribute "limit" to define if the
rule should only be applied by specific components.

Apply rule on file objects only:

.. code-block:: yara
   :linenos:

   rule Malware_in_fileobject {
        meta:
             description = "Think Tank Campaign"
             limit = "Filescan"
        strings:
             $s1 = "evilstring-infile-only"
        condition:
             1 of them
   }

See :ref:`scanning/modules:modules` and :ref:`scanning/features:features`
for a list of all available components.

