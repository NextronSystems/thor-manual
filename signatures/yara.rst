.. Index:: Yara Rules

YARA Rules
==========

THOR allows you to include your own custom YARA rules. Plain-text YARA
rules must use the ``.yar`` extension and encrypted YARA rules must use
the ``.yas`` extension. Rules can be encrypted with THOR Util.

Custom YARA rules must be saved in the
``.\custom-signatures\yara`` folder. To apply only custom YARA rules
and IOCs, use ``--custom-signatures-only``.

THOR supports three YARA rule types:

- Generic rules
    - Subtype: Process rules
- Meta rules
- Keyword rules
    - Subtype: Registry rules
    - Subtype: Log rules

The rule type is determined by specific keywords in the file name:

 - If a file name contains the keyword ``meta``, the rules in that file
   are treated as meta rules.
 - If a file name contains the keyword ``keyword``, ``registry``, or
   ``log``, the rules are treated as keyword rules, possibly with the
   corresponding subtype.
 - If a file name contains the keyword ``process``, or none of the
   keywords listed above, the rules are treated as generic rules, with
   the ``process`` subtype if applicable.


The following table shows which rule type is selected for several
example file names.

.. list-table::
   :header-rows: 1
   :widths: 55, 45

   * - Filename
     - Rule type
   * - incident-feb17.yar
     - Generic rule
   * - event-**log**-rules.yar
     - Log rule
   * - custom-**meta**.yar
     - Meta rule
   * - incident-feb17-**registry**.yar
     - Registry rule
   * - case-a23-**process**-rules.yar
     - Process rule


Generic YARA Rules
^^^^^^^^^^^^^^^^^^

Generic YARA rules are applied to the following elements:

* All files that are smaller than the ``--file-size-limit`` and that have been matched by the :ref:`signatures/yara:Deepscan Rules`.
* The process memory of all processes with a working set memory size smaller than the ``--process-size-limit``.
* The data chunks read during the DeepDive scan.

.. note::
    Rules with the ``process`` subtype are applied only to process
    memory and DeepDive chunks, not to files.

:ref:`signatures/yara:Additional Attributes` are available for generic
rules:

* For files, they are based on the file itself.
* For process memory, they are based on the process's image.
* For data chunks, they are based on the file where the data chunk originates.

.. warning::
    As described above, only files actively selected by
    :ref:`signatures/yara:Deepscan Rules` are scanned with generic YARA
    rules.

Meta YARA Rules
^^^^^^^^^^^^^^^

Meta rules are applied to all files without exception. However, they
can access only the :ref:`signatures/yara:Additional Attributes` and
the first 64 KB of a file.

Meta rules are also applied to irregular files. In these cases, THOR
provides the bytes to be scanned:
 - For symlinks, the file content is the target path.
 - For directories, the file content is the directory listing, with
   file names separated by newlines.

.. tip::
    Meta rules are most commonly used to trigger other features
    (see :ref:`scanning/features:Feature selectors`) or to select files
    for scanning with generic rules (see
    :ref:`signatures/yara:Deepscan Rules`).

Deepscan Rules
**************

If a meta rule with the special tag ``DEEPSCAN`` matches a file, THOR
scans that file with the :ref:`signatures/yara:Generic YARA Rules`.

.. note::
    THOR already ships with a broad set of deepscan rules that cover
    file types commonly used by attackers.

    These rules are used even if ``--custom-signatures-only`` is used.

    However, you can always add your own deepscan rules if you encounter uncommon file types that THOR does not pick up by default.

If such a rule also has the special tag ``FORCE``, it ignores the file
size limit and always triggers a scan with the generic YARA rules.

.. warning::
    Use ``FORCE`` with care, as it can significantly increase scan
    times.

Keyword YARA Rules
^^^^^^^^^^^^^^^^^^

Keyword rules are applied to all checked objects.

The *registry* and *log* subtypes of keyword rules are applied only to
registry keys or to log-related objects such as log lines, Event Log
entries, and journald entries.

Keyword rule scanning (including registry keys and logs) uses :ref:`signatures/yara:Bulk Scanning`.

THOR YARA Rules for Registry Detection
**************************************

THOR allows you to check a complete registry key with YARA rules. To do
so, THOR composes a string from the registry key values and formats
them as follows:

| **KEYPATH;VALUENAME;VALUE\\n**
| **KEYPATH;VALUENAME;VALUE\\n**
| **KEYPATH;VALUENAME;VALUE\\n**

**Registry Base Names**

Please note that strings such as ``HKEY_LOCAL_MACHINE``, ``HKLM``,
``HKCU``, and ``HKEY_CURRENT_CONFIG`` are **not** part of the key path
to which your YARA rules are applied. They depend on the analyzed hive
and should not appear in the strings you define.

Values are formatted as follows:

 - REG\_BINARY values are hex encoded with upper case.
 - REG\_MULTI\_SZ values are printed with ``\\0`` separating the multiple strings.
 - Numeric values are printed normally (with base 10; e.g., use ``32`` for REG_DWORD 0x00000020).
 - String values are printed normally.

This means you can write a YARA rule such as the following. Remember to
escape all backslashes:

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

To initialize a YARA rule file as a registry rule set, the file name
must contain the keyword **registry**, for example
``registry_exe_in_value.yar``.

THOR YARA Rules for Log Detection
*********************************

YARA rules for logs are applied as follows:

- For text logs, each line is passed to the YARA rules.
- For Windows Event Logs, each event is serialized as follows for the YARA rules:
  ``Key1: Value1  Key2: Value2  ...``
  where each key / value pair is an entry in EventData or UserData in the XML representation of the event.

Score
^^^^^

The :ref:`score<signatures/scores:Scoring>` of a YARA rule can be
specified as a meta attribute in the rule:

.. code-block:: yara
   :linenos:

   rule demo_rule_score {
       meta:
            description = "Demo Rule"
            score = 80
       strings:
            $a1 = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE"
            $a2 = "honkers" fullword
       condition:
            1 of them
   }

If no ``score`` field is present, the rule receives the default score
of ``75``.

The scoring system allows you to include ambiguous, low-scoring rules
that would generate too many false positives in other scanners. If a
string appears both in malware and in legitimate files, assign a lower
score or combine the rule with other attributes as described in
:ref:`signatures/yara:Additional Attributes`.

Additional Attributes
^^^^^^^^^^^^^^^^^^^^^

THOR provides a number of external variables for generic and meta YARA
rules. These variables are:

* **filename**

  * Single file name
  * Example: ``cmd.exe``

* **filepath**

  * File path without the file name and without a trailing path delimiter
  * Example: ``C:\temp`` or ``/var/log``

* **extension**

  * File extension in lower case, including the leading ``.``
  * Example: ``.exe``

* **filetype**

  * File type based on the magic header signatures
    (for a list of valid file types, see:
    ``./signatures/misc/file-type-signatures.cfg``)
  * Example: ``EXE`` or ``ZIP``

* **timezone**

  * The system time zone (see
    https://golang.org/src/time/zoneinfo_abbrs_windows.go for valid
    values)

* **language**

  * The system language settings (see
    https://docs.microsoft.com/en-us/windows/win32/intl/sort-order-identifiers)

* **owner**

  * The file owner
  * Example: ``NT-AUTHORITY\SYSTEM`` on Windows
  * Example: ``root`` on Linux

* **group**

  * The file group
  * Example: ``root`` on Linux
  * This variable is empty on Windows

* **filemode**

  * File mode for this file (see
    https://man7.org/linux/man-pages/man7/inode.7.html, "The file type
    and mode")
  * On Windows, this variable will be an artificial approximation of a file mode since Windows is not POSIX compliant.

* **filesize**

  * File size in bytes. This value is provided directly by YARA and is
    not specific to THOR

* **osversion**

  * The Windows build number (0 on non-Windows systems)

* **unpack_parent**

  * The file's origin, for example ``ZIP`` if the file was contained in
    a ZIP archive
  * Possible values include:

    * Archives: ``ZIP``, ``RAR``, ``RAR``, ``TAR``, ``TARGZ``, ``TARBZ2``, ``CAB``, ``GZIP``, ``BZIP2``, ``7ZIP``
    * From a module: ``CHM``, ``CHUNK``, ``EMAIL``, ``ICS``, ``MACROS``, ``MFT``, ``OLE``, ``REGISTRY``, ``UNESCAPE``, ``UPX``, ``VBEDECODE``
    * From a plugin: user-defined via `Scanner.ScanFile <https://github.com/NextronSystems/thor-plugin/blob/ee8583e935f06737d5f83102e2adcd83bfad7ec6/thorplugin.go#L112>`__ from a `THOR plugin <https://github.com/NextronSystems/thor-plugin>`__.

* **unpack_source**

  * The file's origins, separated by ``>``, for example ``EMAIL>ZIP``
    if the file was contained in a ZIP archive that arrived as an email
    attachment
  * For possible origin values, see ``unpack_parent``

* **permissions**

  * The permissions of the file
  * On Unix systems, this is a string representation of the file mode.
  * On Windows, this contains the DACL of the file, separated with / (e.g "BUILTIN\Users:W / BUILTIN\Administrators:F")

* **age**

  * The file's age in days, based on its creation timestamp
  * If the file does not have a creation timestamp, for example because
    the underlying file system does not provide one, the value is
    ``NaN``

YARA rule using a THOR external variable:

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

A more complex rule using several THOR external variables could look
like the following example.

This rule matches all files that contain the EICAR string, have the
name ``eicar.com``, ``eicar.dll``, or ``eicar.exe``, and are smaller
than 100 bytes.

YARA rule using more complex THOR-specific attributes.

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

In addition to keyword-based initialization, you can restrict YARA
rules so they match only certain object types. This is useful, for
example, when a rule causes many false positives in process memory but
should still be used for file object detection. Use the ``limit`` meta
attribute to define which components should apply the rule.

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

Bulk Scanning
^^^^^^^^^^^^^

THOR scans certain objects, such as registry values or log lines, in
bulk because each YARA invocation has relatively high overhead.
This means that during the scan, the following happens:

- THOR gathers objects that need to be scanned.
- Once enough entries have been collected, they are combined,
  separated by line breaks, and passed to YARA.

   - THOR uses a modified ruleset that tries to remove false positive
     conditions. Otherwise, false positive strings in one entry could
     prevent another entry from being detected.

- If any YARA rule matches, entries containing the matching strings are
  scanned again individually to determine which specific entries match.

.. warning:

   YARA conditions can be very complex. Although THOR tries to make bulk
   scanning robust, very complex conditions such as loops or conditions
   that inspect string offsets may prevent all false positive
   conditions from being removed. Be careful with such rules when bulk
   scanning is involved.

Creating Yara Rules
^^^^^^^^^^^^^^^^^^^

Using the Unix ``strings`` command on Linux systems or in a Cygwin
environment helps you extract relevant strings from a sample set and
write your own rules quickly. Use ``strings -el`` to extract Unicode
strings from executables as well.

A useful YARA rule generator called ``yarGen``, provided by our
developers, can be downloaded from GitHub. It takes a target directory
as input and generates rules for all files in that directory, including
so-called "super rules" when common characteristics from different
files can be used to generate one rule that matches them all.

Another useful project is ``YaraGenerator``, which creates a single YARA
rule from one or more malware samples. If several malware files from
the same family are placed in the analyzed directory, the generator can
produce a signature that matches the family more broadly.

We recommend testing every YARA rule with the ``yara`` binary before
adding it to THOR, because THOR does not provide a detailed debugging
mechanism for YARA rules. The ``yara`` binary is available from the
official project on GitHub.

Recommended steps for creating a custom rule:

1. | Extract information from the malware sample
   | (Strings, Byte Code, MD5 …)

2. Create a new YARA rule file. It is important to:

   a. Define a unique rule name. Duplicate names cause errors

   b. Add a description that you want to see when the signature matches

   c. Define an appropriate score. This is optional but useful in THOR;
      the default is 75

3. Scan the malware with the ``yara`` binary to verify a positive match

4. Scan the ``Windows`` or ``Program Files`` directory with the
   ``yara`` binary to identify possible false positives

5. Copy the file to THOR's ``/custom-signatures/yara`` folder and start
   THOR to verify that the rule loads cleanly without errors

THOR also provides several enhancements that you can use in your rules.

Also see these articles on how to write simple but sound YARA rules:

https://www.nextron-systems.com/2015/02/16/write-simple-sound-yara-rules/

https://www.nextron-systems.com/2015/10/17/how-to-write-simple-but-sound-yara-rules-part-2/

Typical Pitfalls
****************

Some signatures, including some published by well-known vendors, cause
problems on certain files. The most common source of trouble is the use
of regular expressions with a variable length, as shown in the
following example. This APT1 rule published by the AlienVault team
caused both the YARA binary and THOR to run into a loop while scanning
certain malicious files. The problem is the string expression
``$gif1``, which causes YARA to check for a word character of undefined
length. Avoid regular expressions of undefined length whenever
possible.

AlientVault APT1 Rule: yara

.. code-block:: yara
   :linenos:
   :emphasize-lines: 7

    rule APT1_WEBC2_TABLE {
        meta:
             author = "AlienVault Labs"
        strings:
             $msg1 = "Fail To Execute The Command" wide ascii
             $msg2 = "Execute The Command Successfully" wide
             $gif1 = /\w+\.gif/
             $gif2 = "GIF89" wide ascii
        condition:
             3 of them
    }

If copying your rule to the signatures directory causes THOR to fail
during rule initialization, test the rule again with the ``yara``
binary. The most common causes are duplicate rule names or syntax
errors.

YARA Rule Performance
*********************

We compiled a set of guidelines to improve YARA rule performance. By
following them, you can avoid rules that consume too many CPU cycles
and slow down scans.

https://gist.github.com/Neo23x0/e3d4e316d7441d9143c7

Enhance YARA Rules with THOR Specific Attributes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example shows a typical YARA rule with the three main
sections ``meta``, ``strings``, and ``condition``. The YARA Rule Manual,
which is bundled with the THOR binary and also available from the
official YARA project, is a useful reference for functions, keywords,
and general rule construction.

The ``meta`` section contains metadata and can be extended freely with
your own attributes. The ``strings`` section defines strings, regular
expressions, or hex patterns that identify malware or hack tools. The
``condition`` section defines when the rule generates a match and can
combine multiple strings with keywords such as ``not`` or ``all of
them``.

Simple Yara Rule:

.. code-block:: yara
   :linenos:

   rule simple_demo_rule_1 {
        meta:
             description = "Demo Rule"
        strings:
             $a1 = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE"
        condition:
             $a1
   }

The following example shows a more complex rule that uses several
keywords commonly found in the THOR rule set.

Complex Yara Rule:

.. code-block:: yara
   :linenos:

   rule complex_demo_rule_1 {
       meta:
            description = "Demo Rule"
       strings:
            $a1 = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE"
            $a2 = "li0n" fullword
            $a3 = /msupdate\.(exe|dll)/ nocase
            $a4 = { 00 45 9A ?? 00 00 00 AA }
            $fp = "MSWORD"
       condition:
            1 of ($a*) and not $fp
   }

The example above shows common keywords used in the THOR rule set. All
of these keywords are part of the YARA standard; the rule itself does
not use any THOR-specific expressions.

YARA provides extensive functionality, but it lacks some important
attributes that are useful for describing indicators of compromise as
defined in standards such as OpenIOC. YARA is designed primarily to
detect strings or byte patterns within a file, but it does not natively
match metadata such as file names, file paths, or extensions.

THOR extends YARA with additional functionality to overcome these
limitations; see :ref:`signatures/yara:Additional Attributes`.
