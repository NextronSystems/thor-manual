Custom Signatures
=================

THOR checks the contents of the ``./custom-signatures`` folder and
processes every file in this folder. The file extension determines the type
of signature (e.g. a simple IOC file, a YARA rule or a Sigma rule).
For some signature types, string tags in the file names are used to
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

Simple IOCs
-----------

Simple IOC files are basically CSV files that include the IOC and
comments. Simple IOC files must have the extension ``.txt``.
encrypted simple IOC files must have the extension ``.dat``.

The following tags for simple IOCs are currently supported:

* "**c2**" or "**domains**"
  
  * for IP addresses and hostnames

* "**filename**" or "**filenames**"

  * for filenames

* "**hash**" or "**hashes**"

  * for MD5, SHA1 or SHA256 hashes or (since THOR 10.7.6) Imphashs

* "**keyword**" or "**keywords**"

  * for string-based keywords

* "**trusted-hash**" or "**trusted-hashes**"
  or "**falsepositive-hash**" or "**falsepositive-hashes**"

  * for hashes that you trust

* "**handles**"

  * for malicious Mutex / Events

* "**pipes**" or "**pipe**"

  * for Named Pipes

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

.. hint::
   You can find IOC examples in the directory ``custom-signatures/iocs/templates``
   of THOR. This should help you to create your own simple IOC files.

.. _Simple IOCs Modules:

For a list of Features/Modules which are used by the different :ref:`usage/custom-signatures:simple iocs`,
please see the table below.

.. csv-table::
   :file: ../csv/thor_feature_iocs.csv
   :delim: ;
   :header-rows: 1

Hashes
^^^^^^

Files with the string ``hash`` or ``hashes`` in their filename
get initialized as hash IOC sets. Either you are assigning a custom score
to your hashes, or you do not assign a score at all, in which case the
match will default to a score of 100.

The first column contains your MD5, SHA1 or SHA256 hash or (since THOR 10.7.6) an Imphash.
The second column contains your comment, if you do not use any scoring. If you choose to use
your own scoring (example below on line 2), the score goes into the second
column and the comment into the third. Columns are separated by a semicolon
and hashes are applied case-insensitively. Scoring and comments are optional.

.. code-block:: text
   :caption: custom-hashes-iocs.txt
   :emphasize-lines: 2
   :linenos:

   0c2674c3a97c53082187d930efb645c2;DEEP PANDA Sakula Malware - http://goo.gl/R3e6eG
   f05b1ee9e2f6ab704b8919d5071becbce6f9d0f9d0ba32a460c41d5272134abe;50;Vulnerable Lenovo Diagnostics Driver - https://github.com/alfarom256/CVE-2022-3699/tree/main

File Name IOCs
^^^^^^^^^^^^^^

Filename IOC files allow you to define IOCs based on filename and filepath
using regular expressions. You can add or reduce the total score of a file
element during the scan with a positive (e.g. "40") or negative score (e.g. "-30").

While this can also be used to define false positives, or reduce the
score of well-known files and locations, it gives you all the
flexibility to add scores according to your needs.

Filename IOCs are case insensitive if they don't use any special regex
characters (such as ``*``, ``.``, ``[``, ...). Otherwise, they are case
sensitive by default, but can be set as case insensitive by using ``(?i)``
anywhere in the regex.

.. code-block:: text
   :caption: custom-filename-iocs.txt
   :linenos:

   # Ncat Example
   \\bin\\nc\.exe;-20
   
If you know that administrators in your organization use ``PsExec.exe``
in a folder named ``Sysinternals``, but any other location should be
reported as suspicious you could define the following statements:

.. code-block:: text
   :caption: psexec-filename-ioc.txt
   :linenos:

   # PsExec
   \\PsExec\.exe;60
   \\SysInternals\\PsExec\.exe;-60

This following example represents the 3\ :sup:`rd` generation filename
IOC format introduced with THOR version 8.30 and SPARK version 1.5,
which is now the recommended form to define such signatures.

It contains three fields:

* Column 1: Regex
* Column 2: Score
* Column 3: False Positive Regex

The False Positive Regex statement is only evaluated if the Regex
statement in column 1 matched.

.. code-block:: text

   \\PsExec\.exe;60;\\SysInternals\\

We use this new format internally to describe abnormal locations of
system files like

.. code-block:: text

   ([C-Zc-z]:\\|\\\\).{1,40}\\svchost\.exe;65;(?i)(HKCR\\Applications|System32|system32|SYSTEM32|winsxs|WinSxS|SysWOW64|SysWow64|syswow64|SYSNATIVE|Sysnative|dllcache|WINXP|WINDOWS|i386|%system32%)\\

You could also score down directories with many false positives reported
as "Notices" or "Warnings" like this:

.. code-block:: text

   \\directory_with_many_false_positives\\;-30

Keyword IOCs
^^^^^^^^^^^^

The keyword-based IOC files contain plaintext strings that are matched
against the console output of THOR. Not all console output is being used for those
IOCs, you can find the full list here: `Simple IOCs Modules`_.

One use case would be to have different strings which you encountered in Scheduled Tasks
within Windows. Usually THOR will output all the Scheduled Tasks as ``Info``,
so this can help to look for specific things throughout the whole THOR scan.

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

C2 IOCs
^^^^^^^

C2 IOC files specify remote servers which are known to be malicious.
This can include:

 - Domain names
 - FQDNs
 - Single IPs
 - IP address ranges in CIDR notation

These IOCs are applied to the connections of examined processes
and can optionally be used to search process memory.

Each IOC must be placed on a single line.
A comment can be specified with a line starting with a ``#``
and applies to all following IOCs until another comment is encountered.
A score for the IOC can optionally be specified after the IOC,
separated by a ``;``, it defaults to 100 if none is specified.

.. code-block:: text
   :caption: custom-c2-domains.txt
   :linenos:

   # Case 44 C2 Server
   mastermind.eu
   googleaccountservices.com
   89.22.123.12
   someotherdomain.biz;80

Mutex or Event Values
^^^^^^^^^^^^^^^^^^^^^

Custom mutex or event values can be provided in a file that contains the
“handles” keyword in its filename. The entries can be string or regular
expression values. The entries are applied to the processes handles as
”equals” if no unescaped special regex characters are used, otherwise
they are applied as "contains" (though a regex can, of course, specify
its match position by using ``^`` and/or ``$``).

You can decide if you want to set a scope by using ``Global\\``
or ``BaseNamedObjects\\`` as a prefix. If you decide to use none, your expression
will be applied to any scope. Mutex and event IOCs are case sensitive.

.. code-block:: text
   :linenos:
   :caption: custom-mutex-iocs.txt

   Global\\mymaliciousmutex;Operation Fallout – RAT Mutex
   Global\\WMI_CONNECTION_RECV;Flame Event https://bit.ly/2KjUTuP
   Dwm-[a-f0-9]{4}-ApiPort-[a-f0-9]{4};Chinese campaign malware June 19

Named Pipes
^^^^^^^^^^^

Custom named pipe values can be provided in a file that contains the
"pipes" keyword in its filename. The entries should be regular
expressions that match the malicious named pipes. The ``\\\\.\\pipe\\``
prefix should not be part of the entry.
The IOCs are applied to the pipes as
"equals" if no unescaped special regex characters are used, otherwise
they are applied as "contains" (though a regex can, of course, specify
its match position by using ``^`` and/or ``$``).

Optionally, a score can be added as 2nd field. If none is present, it
defaults to 100. Named Pipe IOCs are case insensitive.

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
^^^^^^^^^^^

Sigma is a generic rule format for detections on log data. Sigma is for
log data, what Snort is for network packets and YARA is for files.

THOR ships with the public Sigma rule set, which
is maintained by the community at `<https://github.com/SigmaHQ/sigma>`_,
as well as additional Nextron internal rules.

THOR applies Sigma rules to Windows Eventlogs and log files on disk
(``.log``). In addition, Sigma rules are used for internal matching against objects
which THOR encounters.

.. note::
  To activate Sigma scanning before THOR 10.7, you have to use the ``--sigma``
  command line option or perform an ``--intense`` scan. Sigma scanning is not
  activated by default in these versions.

By default only the results of Sigma rules of level critical and high are shown.
If called with the ``--intense`` flag, medium level rules are applied as well.

Custom Sigma rules must have the ``.yml`` extension for unencrypted sigma rules
and the ``.yms`` extension for encrypted sigma rules.

.. figure:: ../images/image31.png
   :alt: Example Sigma match on Windows Eventlog

   Example Sigma match on Windows Eventlog

Sigma Examples
~~~~~~~~~~~~~~

Scanning Logfiles with Sigma
****************************

Perform a scan with the Sigma rules on the different local Windows
Eventlogs (``-a Eventlog``)

.. code-block:: doscon

   C:\tools\thor>thor64.exe -a Eventlog --sigma

Perform a scan with the Sigma rules on logs of Linux systems (-a
LogScan) only

.. code-block:: doscon

   C:\tools\thor>thor64 -a Filesystem -p /var/log –sigma

YARA Rules
^^^^^^^^^^

THOR allows you include your own custom YARA rules.
YARA rules must have the **.yar** extension for plain text YARA rules
and the **.yas** extension for encrypted YARA rules. (the rules can be encrypted using THOR Util)

Custom YARA rules have to be saved to the ``.\custom-signatures\yara`` folder. In order to apply only custom YARA rules and IOCs, use the ``--customonly`` flag. 

There are two custom YARA rule types that you can define in THOR:

- Generic Rules
- Specific Rules

Generic YARA Rules
~~~~~~~~~~~~~~~~~~

All YARA rules which do not contain any specific tag (see :ref:`usage/custom-signatures:Specific YARA Rules`)
are considered generic YARA rules.

The generic YARA rules are applied to the following elements:

* | Files
  | THOR applies the Yara rules to all files that are smaller than the size limit set in the **thor.yml** and matches specific rules. :ref:`usage/custom-signatures:Additional Attributes` are available.
* | Process Memory
  | THOR scans the process memory of all processes with a working set memory size up to a certain limit. This limit can be altered by the "**--max_process_size**" parameter.
* | Data Chunks
  | The rules are applied to the data chunks read during the DeepDive scan. DeepDive only reports and restores chunks if the score level of the rule is high enough to cause at least a warning.

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
~~~~~~~~~~~~~~~~~~~

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
  | Rules are applied to all string checks in many different modules.
* | Metadata Checks (since THOR 10.6)
  | Tag: **'meta'**
  | Rules are applied to all files without exception, including directories, symlinks and the like, but can only access the THOR specific external variables (see :ref:`usage/custom-signatures:Additional Attributes`) and the first 2048 bytes of the file.
  | Since THOR 10.6.8: If a metadata rule has the special tag DEEPSCAN, THOR will perform a YARA scan on the full file with the default rule set (see :ref:`usage/custom-signatures:Generic YARA Rules`).
  | Since THOR 10.7: Symlinks now have their target as the content.

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
    - Eventlog, Logscan, EVTX
    - general-**log**-strings.yar
  * - process
    - ProcessCheck (only on process memory)
    - case-a23-**process**-rules.yar
  * - keyword
    - Mutex, Named Pipes, Eventlog, MFT, ProcessCheck (on all process handles), ProcessHandles, ServiceCheck, AtJobs, LogScan, AmCache, SHIMCache, Registry
    - misp-3345-**keyword**-extract.yar
  * - meta
    - Filescan
    - **meta**-rules.yar

THOR YARA Rules for Registry Detection
**************************************

THOR allows checking a complete registry path key/value pairs with Yara
rules. To accomplish this, THOR composes a string from the key/value pairs
of a registry key path and formats them as shown in the following
screenshot.

.. figure:: ../images/image33.png
   :alt: Composed strings from registry key/value pairs

   Composed strings from registry key/value pairs

The composed format is:

| **KEYPATH;KEY;VALUE\\n**
| **KEYPATH;KEY;VALUE\\n**
| **KEYPATH;KEY;VALUE\\n**

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
~~~~~~~~~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~

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
~~~~~~~~~~~~~~~~~~~~~

We compiled a set of guidelines to improve the performance of YARA
rules. By following these guidelines you avoid rules that cause many CPU
cycles and hamper the scan process.

https://gist.github.com/Neo23x0/e3d4e316d7441d9143c7

STIX IOCs
---------

THOR can read and apply IOCs provided in STIXv2 JSON files.
They must have the ``.json`` extension for unencrypted STIXv2 files
and the ``.jsos`` extension for encrypted STIXv2 files.

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

Enhance YARA Rules with THOR Specific Attributes
------------------------------------------------

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
^^^^^

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
^^^^^^^^^^^^^^^^^^^^^

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

* **group** (available since THOR 10.6.8)

  * The file group
  * Example: ``root`` on Linux
  * This variable is empty on Windows

* **filemode** (available since THOR 10.6)

  * file mode for this file (see https://man7.org/linux/man-pages/man7/inode.7.html, "The file type and mode").
  * On Windows, this variable will be an artificial approximation of a file mode since Windows is not POSIX compliant.

* **filesize**

  * The value contains the file size in bytes. It is provided directly by YARA and is not specific to THOR.

* **osversion** (available since THOR 10.6.15)

  * The Windows build number (0 on non-Windows systems)

* **unpack_parent** (available since THOR 10.7.9)

  * The file's origin (e.g. "ZIP" if it was contained in a ZIP file)

* **unpack_source** (available since THOR 10.7.9)

  * The file's origins, separated by ">" (e.g. "EMAIL>ZIP" if it was contained in a ZIP file that was an email attachment)

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

THOR scans registry and log entries in bulks since each YARA invocation has a
relatively high overhead. This means that during the scan, the following happens:

- THOR gathers entries that need to be scanned.
- When sufficiently many entries are gathered, all of them are combined (separated
  by line breaks) and passed to YARA.
- If any YARA rule matches, each entry is scanned separately with YARA to determine
  whether any YARA rule matches for this specific entry.

One potential caveat of this is that false positive strings may prevent a rule from
ever applying.

For example, consider this rule:

.. code-block:: yara
   :linenos:

   rule FakeMicrosoftStartupEntry {
        strings:
             $s1 = "Microsoft\\SomeRegistryKey;ShouldBeUsedOnlyByMicrosoft;"
             $fp = "Windows\\System32"
        condition:
             $s1 and not $fp
   }

This rule is meant to match if the specified registry key contains some DLL that is not
in ``C:\Windows\System32``. However, the false positive string may inadvertently match on
other entries in the bulk, like here:

.. code-block::

   Path\to\Microsoft\SomeRegistryKey;ShouldBeUsedOnlyByMicrosoft;C:\evil.exe
   ...
   Path\to\SomeOtherRegistryKey;Entry;C:\Windows\System32\explorer.exe
   ...

Because the rule does not apply to the bulk, THOR never scans the single elements and
does not report any match. Therefore, be very careful with false positive strings with log
or registry YARA rules.

A possible workaround for this issue is to define the false positive strings in ways that
they can't match anywhere else, e.g. like this:

.. code-block:: yara

   rule FakeMicrosoftStartupEntry {
        strings:
             $s1 = "Microsoft\\SomeRegistryKey;ShouldBeUsedOnlyByMicrosoft;"
             $fp = /Microsoft\\SomeRegistryKey;ShouldBeUsedOnlyByMicrosoft;[^\n]{0,40}Windows\\System32/
        condition:
             $s1 and not $fp
   }

Restrict Yara Rule Matches
^^^^^^^^^^^^^^^^^^^^^^^^^^

On top of the keyword based initialization you can restrict Yara rules
to match on certain objects only. It is sometimes necessary to restrict
rules that e.g. cause many false positives on process memory to file
object detection only. Use the meta attribute "type" to define if the
rule should apply to file objects or process memory only.

Apply rule in-memory only:

.. code-block:: yara
   :linenos:

   rule Malware_in_memory {
        meta:
             author = "Florian Roth"
             description = "Think Tank Campaign"
             type = "memory"
        strings:
             $s1 = "evilstring-inmemory-only"
        condition:
             1 of them
   }

Apply rule on file objects only:

.. code-block:: yara
   :linenos:

   rule Malware_in_fileobject {
        meta:
             description = "Think Tank Campaign"
             type = "file"
        strings:
             $s1 = "evilstring-infile-only"
        condition:
             1 of them
   }

You can also decide if a rule should not match in "DeepDive" module by
setting the "nodeepdive" attribute to "1".

Avoid DeepDive application:

.. code-block:: yara
   :linenos:

   rule Malware_avoid_DeepDive {
        meta:
             description = "Think Tank Campaign"
             nodeepdive = 1
        strings:
             $s1 = "evilstring-not-deepdive"
        condition:
             1 of them
   }

If you have problems with false positives caused by the specific YARA
rules, try using the "limit" modifier in the meta data section of your
YARA rule. Using the "limit" attribute, you can limit the scope of your
rules to a certain module. (Important: Use the module name as stated in
the log messages of the module, e.g. "ServiceCheck" and not "services")

E.g. if you have defined a malicious 'Mutex' named '\_evtx\_' in a rule
and saved it to a file named "mutex-keyword.yar", the string "\_evtx\_"
will be reported in all other modules to which the keyword rules are
applied – e.g. during the Eventlog scan.

You can limit the scope of your rule by setting 'limit = "Mutex"' in the
meta data section of the YARA rule.

Limits detection to the "Mutex" module:

.. code-block:: yara
   :linenos:

   rule Malicious_Mutex_Evtx {
        meta:
             description = "Detects malicious mutex EVTX"
             limit = "Mutex"
        strings:
             $s1 = "_evtx_"
        condition:
             1 of them
   }

Notes:

* the internal check in THOR against the module name is case-insensitive
* this "limit" parameter only applies to specific YARA rules (legacy reasons – will be normalized in a future THOR version)

False Positive Yara Rules
^^^^^^^^^^^^^^^^^^^^^^^^^

Yara rules that have the "falsepositive" flag set will cause a score
reduction on the respective element by the value defined in the "score"
attribute. Do not use a negative score value in YARA rules.

False Positive Rule:

.. code-block:: yara
   :linenos:

   rule FalsePositive_AVSig1 {
        meta:
             description = "Match on McAfee Signature Files"
             falsepositive = 1
             score = 50
        strings:
             $s1 = "%%%McAfee-Signature%%%"
        condition:
             1 of them
   }
