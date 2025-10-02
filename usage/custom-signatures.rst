Custom Signatures
=================

THOR checks the contents of the ``./custom-signatures`` subfolders;
there is a subfolder here for each signature type (e.g. YARA, Sigma, or
IOCs). Files must be placed in the correct subfolder to be loaded.

For YARA rules and simple IOC files, string tags in the file names are used to
further distinguish the signatures.

For example, a file named ``my-c2-iocs.txt`` will be
initialized as a file containing simple IOC indicators with
C2 server information.

Internally the regex ``\Wc2\W`` is used to detect the
tag, so ``mysource-c2-iocs.txt`` and
``dec15-batch1-c2-indicators.txt`` would be detected correctly,
whereas ``filenameiocs.txt`` or ``myc2iocs.txt`` would
not be detected.

If you do not wish to place your custom IOCs on potentially compromised systems
during an engagements, you can use thor-util to encrypting custom signatures.
This is described in detail in the
`THOR Util manual <https://thor-util-manual.nextron-systems.com/en/latest/>`_

.. this is for the formatting of the Feature/Module lists.
.. raw:: html

   <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
   <script>
   $(document).ready(function() {
   $("p").filter(function() {return $(this).text() === "Yes";}).parent().addClass('yes');
   $("p").filter(function() {return $(this).text() === "No";}).parent().addClass('no');
   });
   </script>
   <style>
   .yes {background-color:#64c864 !important; text-align: center;}
   .no {background-color:#c86464 !important; text-align: center;}
   </style>

IOCs
----

IOCs are indicators of compromise that are applied during a scan.
They are categorized based on their :ref:`usage/custom-signatures:IOC types`, and can be specified
as either :ref:`usage/custom-signatures:YAML IOC files` or  :ref:`usage/custom-signatures:Simple IOC files`.


All IOCs are text based and can either be regular expressions or plain strings. Furthermore, each IOC has:

 - A score which determines the severity of a match
 - A title that is used to identify this IOC
 - A description that may give additional information to an analyst
 - (Optional) A reference to additional information about the IOC's source
 - (Optional) false positive filters to exclude legitimate
   anomalies where the IOC would match otherwise.

.. hint::
   You can find IOC examples in the directory ``custom-signatures/iocs/templates``
   of THOR. This should help you to create your own IOC files.

IOC types
~~~~~~~~~

THOR supports different types of IOCs. An IOC's type determines on which data it is
applied during the scan.


For a list of Features/Modules which use the different IOC types,
please see the table below.

.. csv-table::
   :file: ../csv/thor_feature_iocs.csv
   :delim: ;
   :header-rows: 1

Hashes
^^^^^^

Hash IOC must be MD5, SHA1, SHA256, or PE import hashes. They are applied to the hashes
of all files that THOR scans.


File Names
^^^^^^^^^^

Filename IOC files allow you to define IOCs based on filename and filepath.

This can also be used to define false positives, or reduce the
score of well-known files and locations, by using negative scores.


Keywords
^^^^^^^^

.. warning::
   Keyword IOCs are deprecated. If you use keyword IOCs, consider switching to
   either keyword YARA rules or Sigma rules.

Keyword IOCs are applied to the text formatted objects as they are printed when
using ``--log-object-type``.

One use case would be to have different strings which you encountered in Scheduled Tasks
within Windows.

Domains
^^^^^^^

Domain IOCs (also called C2 IOCs) specify remote servers which are known to be malicious.
This can include:

 - Domain names
 - FQDNs
 - Single IPs
 - IP address ranges in CIDR notation

These IOCs are applied to the connections of examined processes
and can optionally be used to search process memory.


Mutexes or Events
^^^^^^^^^^^^^^^^^

Mutex or Event IOCs are applied to the processes' handles.

You can decide if you want to set a scope by using ``Global\\``
or ``BaseNamedObjects\\`` as a prefix. If you decide to use none, your expression
will be applied to any scope.

Unlike most other IOCs, which check for "contains", plain text mutex or event IOCs are applied as "equals".

Named Pipes
^^^^^^^^^^^

Named Pipe IOCs are applied to Windows Named Pipes. The ``\\\\.\\pipe\\``
prefix should not be part of the IOC.

Unlike most other IOCs, which check for "contains", plain text named pipe IOCs are applied as "equals".


YAML IOC files
~~~~~~~~~~~~~~

YAML IOC files contain metadata (e.g. an author, date, description, ...)
as well as the IOCs themselves. IOCs are grouped by the IOC type and can
optionally have false positive conditions.

They must have the `.yml` extension, or, if encrypted, the `.yms` extension.


.. code-block:: yaml
   :caption: iocs-report-internal.yml

   title: My Malicious Malware
   references:
   description: Detects a malware found internally during incident response
   date: 2024-01-21
   iocs:
      hashes:
         value: 0c2674c3a97c53082187d930efb645c2
         score: 70
      file_patterns:
         value: \my_malicious_filename.txt
         type: plain # Can be plain or regex. Defaults to plain if not specified.
         case_sensitive: true
         score: 70
         false_positives:
            value: \legitimate_usage\
            # Could use type or case_sensitive, just like the value above
      # Other IOC formats which are supported (in addition to hashes and file_patterns above) are:
      # - c2_iocs
      # - named_pipes
      # - mutexes
      # - events

Simple IOC files
~~~~~~~~~~~~~~~~

Simple IOC files are basically CSV files that include the IOC and
comments. Simple IOC files must have the extension ``.txt``.
encrypted simple IOC files must have the extension ``.dat``.

.. warning::
   Simple IOCs are deprecated and provide less flexibility than YAML IOCs. When writing new
   IOCs, we recommend using YAML IOCs.

The following tags for simple IOCs are currently supported:

* "**c2**" or "**domains**"
  
  * for :ref:`usage/custom-signatures:Domains`

* "**filename**" or "**filenames**"

  * for :ref:`usage/custom-signatures:File Names`

* "**hash**" or "**hashes**"

  * :ref:`usage/custom-signatures:Hashes`

* "**keyword**" or "**keywords**"

  * for :ref:`usage/custom-signatures:Keywords`

* "**trusted-hash**" or "**trusted-hashes**"
  or "**falsepositive-hash**" or "**falsepositive-hashes**"

  * for :ref:`usage/custom-signatures:Hashes` that you trust (implicitly gets score -100)

* "**handles**"

  * for :ref:`usage/custom-signatures:Mutexes or Events`

* "**pipes**" or "**pipe**"

  * for :ref:`usage/custom-signatures:Named Pipes`

.. list-table::
   :header-rows: 1
   :widths: 50, 50

   * - Tag/String in File Name
     - Example
   * - c2
     - misp-**c2**-domains-iocs.txt
   * - filename
     - Case-UX22-**filename**-iocs.txt
   * - filenames
     - Malicious-**filenames**-unitX.txt
   * - hash
     - op-aura-**hash**-iocs.txt
   * - hashes
     - int-misp-**hashes**.txt
   * - keyword
     - Incident-22-**keyword**.txt
   * - keywords
     - **keywords**-incident-3389.txt
   * - trusted-hash
     - my-**trusted-hashes**.dat (encrypted)
   * - handles
     - Operation-fallout-**handles**.txt
   * - pipes
     - incident-22-named-**pipes**.txt

Hashes
^^^^^^

Files with the string ``hash`` or ``hashes`` in their filename
get initialized as hash IOC sets.

Hash IOCs are specified per line and may have one of two supported formats:

.. code-block:: text

   hash;comment
   hash;score;comment

In case of the first format, the score defaults to 100.

The hash specified must be an MD5, SHA1, SHA256, or Imphash.

The comment can be freely chosen and will be printed as part of any match found.

.. code-block:: text
   :caption: custom-hashes-iocs.txt
   :emphasize-lines: 2
   :linenos:

   0c2674c3a97c53082187d930efb645c2;DEEP PANDA Sakula Malware - http://goo.gl/R3e6eG
   f05b1ee9e2f6ab704b8919d5071becbce6f9d0f9d0ba32a460c41d5272134abe;50;Vulnerable Lenovo Diagnostics Driver - https://github.com/alfarom256/CVE-2022-3699/tree/main

File Names
^^^^^^^^^^

Filename IOCs are specified per line and may have one of two supported formats:

.. code-block:: text

   # Comment
   my-filename-regex;score

   # Comment
   my-filename-regex;score;my-fp-regex

Filename IOCs are case insensitive if they don't use any special regex
characters (such as ``*``, ``.``, ``[``, ...). Otherwise, they are case
sensitive by default, but can be set as case insensitive by using ``(?i)``
anywhere in the regex.

.. code-block:: text
   :caption: psexec-filename-iocs.txt
   :linenos:

   \\PsExec\.exe;60;\\SysInternals\\

Keywords
^^^^^^^^

Keyword IOCs are specified in the following format:

.. code-block:: text

   my-keyword-ioc


The keyword-based IOC files contain plaintext strings that are matched
against the console output of THOR. Not all console output is being used for those
IOCs, you can find the full list here: :ref:`usage/custom-signatures:IOC types`.

Every line is treated as case-sensitive string. A comment can be specified
with a line starting with a ``#`` and applies to all following IOCs until
another comment is encountered.

Keyword IOCs are case sensitive.

.. code-block:: text
   :caption: custom-keyword-iocs.txt
   :linenos:
   
   # Evil strings from our case
   sekurlsa::logonpasswords
   failed to create Service 'GAMEOVER'
   kiwi.eo.oe

Domains
^^^^^^^

Domain IOCs are specified in one of the following formats:

.. code-block:: text

   # Description
   <domain/IP/CIDR>

   # Description
   <domain/IP/CIDR>;score

The score defaults to 100 if none is specified.

.. code-block:: text
   :caption: custom-c2-domains.txt
   :linenos:

   # Case 44 C2 Server
   mastermind.eu
   googleaccountservices.com
   89.22.123.12
   someotherdomain.biz;80

Mutexes or Events
^^^^^^^^^^^^^^^^^

Mutex or Event IOCs are specified in the following format:

.. code-block:: text

   <mutex/event>;Description

The score is always set to 70.


.. code-block:: text
   :linenos:
   :caption: custom-mutex-iocs.txt

   Global\\mymaliciousmutex;Operation Fallout – RAT Mutex
   Global\\WMI_CONNECTION_RECV;Flame Event https://bit.ly/2KjUTuP
   Dwm-[a-f0-9]{4}-ApiPort-[a-f0-9]{4};Chinese campaign malware June 19

Named Pipes
^^^^^^^^^^^

Named Pipe IOCs are specified in one of the following formats:

.. code-block:: text

   Named pipe;Description

   Named pipe;Score;description

If no score is present, it defaults to 100.

.. code-block:: text
   :caption: custom-named-pipes-iocs.txt
   :linenos:

   # Incident Response Engagement
   MyMaliciousNamedPipe;Malicious pipe used by known RAT
   MyInteresting[a-z]+Pipe;50;Interesting pipe we have seen in new malware

Rules
-----

There are different types of rules you can use to write your own custom
rules. This chapter will explain all the methods you can use to achieve
this.

.. _Rules Modules:

For a list of Features/Modules which are used by :ref:`usage/custom-signatures:sigma rules`,
:ref:`usage/custom-signatures:generic yara rules` and
:ref:`usage/custom-signatures:specific yara rules`, please see the table below.

.. csv-table::
   :file: ../csv/thor_feature_rules.csv
   :delim: ;
   :header-rows: 1

Sigma Rules
~~~~~~~~~~~

Sigma is a generic rule format for detections on structured data. Sigma is for
log data, what Snort is for network packets and YARA is for files.

THOR ships with the public Sigma rule set, which
is maintained by the community at `<https://github.com/SigmaHQ/sigma>`_,
as well as additional Nextron internal rules.

THOR applies Sigma rules to all objects it encounters. This is most relevant
for Windows Eventlogs and log files on disk (``.log``).

By default only the results of Sigma rules of level critical and high are shown.
If called with the ``--intense`` flag, medium level rules are applied as well.

Custom Sigma rules must have the ``.yml`` extension for unencrypted sigma rules
and the ``.yms`` extension for encrypted sigma rules.

.. figure:: ../images/image31.png
   :alt: Example Sigma match on Windows Eventlog

   Example Sigma match on Windows Eventlog

Sigma matching on THOR output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sigma rules can also be written to match on THOR content.
These rules need to have a logsource with `product: THOR`
and `service: object-type`.

The available object types that can be matched on can be listed with
``--describe-object-type all``. All objects of a specific type can also be
printed by using ``--log-object-type specificobjecttype``. This can be helpful
to determine available fields for matching.

Sigma Examples
^^^^^^^^^^^^^^

Scanning Logfiles with Sigma
****************************

Perform a scan with the Sigma rules on the different local Windows
Eventlogs (``-a Eventlog``)

.. code-block:: doscon

   C:\tools\thor>thor64.exe -a Eventlog

Perform a scan with the Sigma rules on logs of Linux systems (-a
LogScan) only

.. code-block:: doscon

   C:\tools\thor>thor64 -a Filesystem -p /var/log

Matching on Amcache with a custom Sigma rule
********************************************

.. code-block:: yaml

  title: Detecting execution of malicious hash via Amcache
  level: critical
  logsource:
    product: THOR
    service: AmCache entry
  detection:
    hash:
      SHA1: DEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF
    filter:
      PATH|endswith: \benign.exe
    detection: hash and not filter


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

All YARA rules which do not contain any specific tag (see :ref:`usage/custom-signatures:Specific YARA Rules`)
are considered generic YARA rules.

The generic YARA rules are applied to the following elements:

* | Files
  | THOR applies the Yara rules to all files that are smaller than the size limit set in the **thor.yml** and matches specific rules.:ref:`usage/custom-signatures:Additional Attributes` are available.
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
  | Rules are applied to a whole key with all of its values. See :ref:`usage/custom-signatures:THOR YARA Rules for Registry Detection` for more details.
* | Log Files
  | Tag: **'log'**
  | Rules are applied to each log entry. See :ref:`usage/custom-signatures:THOR YARA Rules for Log Detection` for more details.
* | Process Memory
  | Tag: **'process'** or **'memory'**
  | Rules are applied to process memory only.
* | All String Checks
  | Tag: **'keyword'**
  | Rules are applied to all objects that are checked.
* | Metadata Checks
  | Tag: **'meta'**
  | Rules are applied to all files without exception, including directories, symlinks and the like, but can only access the THOR specific external variables (see :ref:`usage/custom-signatures:Additional Attributes`) and the first 64KB of the file.
  | If a metadata rule has the special tag DEEPSCAN, THOR will perform a YARA scan on the full file with the default rule set (see :ref:`usage/custom-signatures:Generic YARA Rules`).
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

Registry scanning uses bulk scanning. See :ref:`usage/custom-signatures:Bulk Scanning` for more details.

THOR YARA Rules for Log Detection
*********************************

YARA Rules for logs are applied as follows:

- For text logs, each line is passed to the YARA rules.
- For Windows Event Logs, each event is serialized as follows for the YARA rules:
  ``Key1: Value1  Key2: Value2  ...``
  where each key / value pair is an entry in EventData or UserData in the XML representation of the event.

Log (both text log and event log) scanning uses bulk scanning.
See :ref:`usage/custom-signatures:Bulk Scanning` for more details.

Remember that you have to use the keyword **log** in the file name in order to
initialize the YARA rule file as registry rule set (e.g. ``my_log_rule.yar``).

How to Create YARA Rules
^^^^^^^^^^^^^^^^^^^^^^^^

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
described in :ref:`usage/custom-signatures:Additional Attributes`.

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

See :ref:`usage/scan-modes:Modules` and :ref:`usage/scan-modes:Features`
for a list of all available components.

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

STIX IOCs
~~~~~~~~~

THOR can read and apply IOCs provided in STIXv2 JSON files.
They must have the ``.json`` extension for unencrypted STIXv2 files
and the ``.jsos`` extension for encrypted STIXv2 files.

TODO: Update

.. figure:: ../images/image32.png
   :alt: STIXv2 Initialization during startup

   STIXv2 Initialization during startup

The following observables are supported.

* ``file:name`` with

  * **=**
  * **!=**
  * **LIKE**
  * **MATCHES**

* ``file:parent_directory_ref.path`` with

  * **=**
  * **!=**
  * **LIKE**
  * **MATCHES**

* ``file:hashes.sha-256`` / ``file:hashes.sha256`` with
   
  * **=**
  * **!=**

* ``file:hashes.sha-1`` / ``file:hashes.sha1`` with

  * **=**
  * **!=**

* ``file:hashes.md-5`` / ``file:hashes.md5`` with

  * **=**
  * **!=**

* ``file:size`` with

  * **<**
  * **<=**
  * **>**
  * **>=**
  * **=**
  * **!=**

* ``file:created`` with

  * **<**
  * **<=**
  * **>**
  * **>=**
  * **=**
  * **!=**

* ``file:modified`` with

  * **<**
  * **<=**
  * **>**
  * **>=**
  * **=**
  * **!=**

* ``file:accessed`` with

  * **<**
  * **<=**
  * **>**
  * **>=**
  * **=**
  * **!=**

* ``win-registry-key:key`` with

  * **=**
  * **!=**
  * **LIKE**
  * **MATCHES**

* ``win-registry-key:values.name`` with

  * **=**
  * **!=**
  * **LIKE**
  * **MATCHES**

* ``win-registry-key:values.data with`` with

  * **=**
  * **!=**
  * **LIKE**
  * **MATCHES**

* ``win-registry-key:values.modified_time`` with

  * **<**
  * **<=**
  * **>**
  * **>=**
  * **=**
  * **!=**

STIX v1
^^^^^^^

STIX version 1 is not supported.
