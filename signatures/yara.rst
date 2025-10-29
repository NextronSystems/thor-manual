.. Index:: Yara Rules

YARA Rules
==========

THOR allows you include your own custom YARA rules.
YARA rules must have the **.yar** extension for plain text YARA rules
and the **.yas** extension for encrypted YARA rules. (the rules can be encrypted using THOR Util)

Custom YARA rules have to be saved to the ``.\custom-signatures\yara`` folder.
In order to apply only custom YARA rules and IOCs, use the ``--custom-signatures-only`` flag. 

There are three YARA rule types that you can define in THOR:

- Generic rules
    - Subtype: Process rules
- Meta rules
- Keyword rules
    - Subtype: Registry rules
    - Subtype: Log rules

The rule type is determined by specific keywords within the filename:

 - If a filename contains the keyword ``meta``, the rules within are meta rules.
 - If a filename contains the keyword ``keyword``, ``registry``, or ``log``, the
   rules within are keyword rules (possibly with the specified subtype).

 - If a filename contains the keyword ``process``, or none of the keywords listed
   above, the rules within are generic rules (with the ``process`` subtype, if specified).


The following table shows which rule type is used for which examplary filename.

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

The generic YARA rules are applied to the following elements:

* All files that are smaller than the ``--file-size-limit`` and that have been matched by the :ref:`signatures/yara:Deepscan Rules`.
* The process memory of all processes with a working set memory size smaller than the ``--process-size-limit``.
* The data chunks read during the DeepDive scan.

.. note::
    Rules with the ``process`` subtype are only applied to process memory and the DeepDive chunks, not to files.

:ref:`signatures/yara:Additional Attributes` are available for generic rules:

* For files, they are based on the file itself.
* For process memory, they are based on the process's image.
* For data chunks, they are based on the file where the data chunk originates.

.. warning::
    As described above, only files that are actively selected by :ref:`signatures/yara:Deepscan Rules` are scanned with the generic YARA rules.

Meta YARA Rules
^^^^^^^^^^^^^^^

Meta rules are applied to all files without exception.
However, they can only access the :ref:`signatures/yara:Additional Attributes` and the first 64KB of the file.

Meta rules are also applied to irregular files. In this case, the bytes that are scanned are provided by THOR:
 - When symlinks are scanned with the meta rules, the file content is their target path.
 - When directories are scanned with the meta rules, the file content is the directory listing (as file names, separated by newlines).

.. tip::
    Meta rules are most commonly used to trigger other features (see :ref:`scanning/features:Feature selectors`)
    or choose a file for a scan with the Generic Rules (see :ref:`signatures/yara:Deepscan Rules`).

Deepscan Rules
**************

If a meta rule which has the special tag ``DEEPSCAN`` matches on a file, THOR will scan the file with the :ref:`signatures/yara:Generic YARA Rules`.

.. note::
    THOR's signatures already contain a wide array of deepscan rules that cover the file types most commonly used by attackers.

    These rules are used even if ``--custom-signatures-only`` is used.

    However, you can always add your own deepscan rules if you encounter uncommon file types that THOR does not pick up by default.

If such a rule has the special tag ``FORCE``, it even ignores the file size limit and will always cause a scan with the generic YARA rules.

.. warning::
    Use ``FORCE`` with care since you can easily cause massive increases in scan times with this.

Keyword YARA Rules
^^^^^^^^^^^^^^^^^^

Keyword rules are applied to all objects that are checked.

The *registry* and *log* subtypes of keyword rules are only applied to registry keys or log lines / event log entries / journald log entries / ..., respectively.

Keyword rule scanning (including registry keys and logs) uses :ref:`signatures/yara:Bulk Scanning`.

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

THOR YARA Rules for Log Detection
*********************************

YARA Rules for logs are applied as follows:

- For text logs, each line is passed to the YARA rules.
- For Windows Event Logs, each event is serialized as follows for the YARA rules:
  ``Key1: Value1  Key2: Value2  ...``
  where each key / value pair is an entry in EventData or UserData in the XML representation of the event.

Score
^^^^^

The :ref:`score<signatures/scores:Scoring>` of a YARA rule
can be specified as a meta attribute in the rule:

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

If no "score" field is present, the rule gets a default score of 75.

The scoring system allows you to include ambiguous, low scoring rules
that can't be used with other scanners, as they would generate to many
false positives. If you noticed a string that is used in malware as well
as legitimate files, just assign a low score or combine it with other
attributes, which are used by THOR to enhance the functionality and are
described in :ref:`signatures/yara:Additional Attributes`.

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

Bulk Scanning
^^^^^^^^^^^^^

THOR scans objects (e.g. registry values or log lines) in bulks since each YARA
invocation has a relatively high overhead.
This means that during the scan, the following happens:

- THOR gathers objects that need to be scanned.
- When sufficiently many entries are gathered, all of them are combined (separated
  by line breaks) and passed to YARA.

   - The ruleset that is used is a modified one, where THOR tries to remove false positive conditions.
     Otherwise, false positive strings that occur in one entry could prevent another entry from being
     detected.

- If any YARA rule matches, the entries that contain the match strings are scanned
  separately with YARA to determine whether any YARA rule matches for these specific entries.

.. warning:

   YARA conditions can be very complex, and while we've done our best to make the modifications to the bulk scans robust,
   in case of very complex conditions (e.g. loops, or conditions looking at the string offsets), not all false positive
   conditions may be removed. If you have rules with these constructs, be careful with these rules in cases where bulk scanning is applied.

Creating Yara Rules
^^^^^^^^^^^^^^^^^^^

Using the UNIX "string" command on Linux systems or in a CYGWIN
environment enables you to extract specific strings from your sample
base and write your own rules within minutes. Use "**string -el**" to
also extract the UNICODE strings from the executable.

A useful Yara Rule Generator called "yarGen" provided by our
developers can be downloaded from Github. It takes a target directory
as input and generates rules for all files in this directory and so
called "super rules" if characteristics from different files can be
used to generate a single rule to match them all. (https://github.com/Neo23x0/yarGen)

Another project to mention is the "Yara Generator", which creates a
single Yara rule from one or multiple malware samples. Placing several
malware files of the same family in the directory that gets analyzed by
the generator will lead to a signature that matches all descendants of
that family. (https://github.com/Xen0ph0n/YaraGenerator)

We recommend testing the Yara rule with the "yara" binary before
including it into THOR because THOR does not provide a useful debugging
mechanism for Yara rules. The Yara binary can be downloaded from the
developers' website (https://github.com/VirusTotal/yara).

The best practice steps to generate a custom rule are:

1. | Extract information from the malware sample
   | (Strings, Byte Code, MD5 …)

2. Create a new Yara rule file. It is important to:

   a. Define a unique rule name – duplicates lead to errors

   b. Give a description that you want to see when the signature matches

   c. Define an appropriate score (optional but useful in THOR, default is 75)

3. Check your rule by scanning the malware with the Yara binary from
   the project's website to verify a positive match

4. Check your rule by scanning the "Windows" or "Program Files"
   directory with the Yara binary from the project's website to detect
   possible false positives

5. Copy the file to the "/custom-signatures/yara" folder of THOR and
   start THOR to check if the rule integrates well and no error is
   thrown

There are some THOR specific add-ons you may use to enhance your rules.

Also see these articles on how to write "simple but sound" YARA rules:

https://www.nextron-systems.com/2015/02/16/write-simple-sound-yara-rules/

https://www.nextron-systems.com/2015/10/17/how-to-write-simple-but-sound-yara-rules-part-2/

Typical Pitfalls
****************

Some signatures - even the ones published by well-known vendors - cause
problems on certain files. The most common source of trouble is the use
of regular expressions with a variable length as shown in the following
example. This APT1 rule published by the AlienVault team caused the Yara
Binary as well as the THOR binary to run into a loop while checking
certain malicious files. The reason why this happened is the string
expression "$gif1" which causes Yara to check for a "word character" of
undefined length. Try to avoid regular expressions of undefined length
and everything works fine.

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

Copying your rule to the signatures directory may cause THOR to fail
during rule initialization. If this happens you should check your rule
again with the Yara binary. Usually this is caused by a duplicate rule
name or syntactical errors.

YARA Rule Performance
*********************

We compiled a set of guidelines to improve the performance of YARA
rules. By following these guidelines you avoid rules that cause many CPU
cycles and hamper the scan process.

https://gist.github.com/Neo23x0/e3d4e316d7441d9143c7

Enhance YARA Rules with THOR Specific Attributes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following listing shows a typical YARA rule with the three main
sections "meta", "strings" and "condition". The YARA Rule Manual which
can be downloaded as PDF from the developer's website and is bundled
with the THOR binary is a very useful guide and reference to get a
function and keyword overview and build your own rules based on the YARA
standard.

The "meta" section contains all types of meta information and can be
extended freely to include own attributes. The "strings" section lists
strings, regular expressions or hex string to identify the malware or
hack tool. The condition section defines the condition on which the rule
generates a "match". It can combine various strings and handles keywords
like "not" or "all of them".

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

The following listing shows a more complex rule that includes a lot of
keywords used in typical rules included in the rule set.

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

The example above shows the most common keywords used in our THOR rule
set. These keywords are included in the YARA standard. The rule does not
contain any THOR specific expressions.

Yara provides a lot of functionality but lacks some mayor attributes
that are required to describe an indicator of compromise (IOC) defined
in other standards as i.e. OpenIOC entirely. Yara's signature
description aims to detect any kind of string or byte code within a file
but is not able to match on meta data attributes like file names, file
path, extensions and so on.

THOR adds functionality to overcome these limitations with :ref:`signatures/yara:Additional Attributes`.
