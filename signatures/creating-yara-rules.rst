.. Index:: Creating Yara Rules

Creating Yara Rules
===================

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

THOR adds functionality to overcome these limitations.

Score
*****

THOR makes use of the possibility to extend the Meta information section
by adding a new parameter called "score".

This parameter is the essential value of the scoring system, which
enables THOR to increment a total score for an object and generate a
message of the appropriate level according to the final score.

Every time a signature matches the value of the score attribute is added
to the total score of an object.

Yara Rule with THOR specific attribute "score":

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

Feel free to set your own "score" values in rules you create. If you
don't define a "score" the rule gets a default score of 75.

The scoring system allows you to include ambiguous, low scoring rules
that can't be used with other scanners, as they would generate to many
false positives. If you noticed a string that is used in malware as well
as legitimate files, just assign a low score or combine it with other
attributes, which are used by THOR to enhance the functionality and are
described in :ref:`signatures/creating-yara-rules:Additional Attributes`.

Additional Attributes
*********************

THOR allows using certain external variables in your generic and meta YARA rules.
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

False Positive Yara Rules
^^^^^^^^^^^^^^^^^^^^^^^^^

Yara rules reduce the score on the respective element by defining a
negative "score" attribute.

False Positive Rule:

.. code-block:: yara
   :linenos:

   rule FalsePositive_AVSig1 {
        meta:
             description = "Match on McAfee Signature Files"
             score = -50
        strings:
             $s1 = "%%%McAfee-Signature%%%"
        condition:
             1 of them
   }
