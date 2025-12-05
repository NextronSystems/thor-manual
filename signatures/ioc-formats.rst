.. Index:: IOC Formats

IOC Formats
===========

THOR checks the contents of the ``./custom-signatures`` sub-directories;
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
`THOR Util manual <https://thor-util-manual.nextron-systems.com>`_

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
      files:
         value: \my_malicious_filename.txt
         type: plain # Can be plain or regex. Defaults to plain if not specified.
         case_sensitive: true
         score: 70
         false_positives:
            value: \legitimate_usage\
            # Could use type or case_sensitive, just like the value above
      # Other IOC formats which are supported (in addition to hashes and files above) are:
      # - c2s
      # - named_pipes
      # - mutexes
      # - events

Simple IOC files (deprecated)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Simple IOC files are basically CSV files that include the IOC and
comments. Simple IOC files must have the extension ``.txt``.
encrypted simple IOC files must have the extension ``.dat``.

.. warning::
   Simple IOCs are deprecated and provide less flexibility than YAML IOCs. When writing new
   IOCs, we recommend using YAML IOCs.

The following tags for simple IOCs are currently supported:

* "**c2**" or "**domains**"
  
  * for :ref:`signatures/ioc-types:Domains`

* "**filename**" or "**filenames**"

  * for :ref:`signatures/ioc-types:File Names`

* "**hash**" or "**hashes**"

  * :ref:`signatures/ioc-types:Hashes`

* "**keyword**" or "**keywords**"

  * for :ref:`signatures/ioc-types:Keywords (deprecated)`

* "**trusted-hash**" or "**trusted-hashes**"
  or "**falsepositive-hash**" or "**falsepositive-hashes**"

  * for :ref:`signatures/ioc-types:Hashes` that you trust (implicitly gets score -100)

* "**handles**"

  * for :ref:`signatures/ioc-types:Mutexes or Events`

* "**pipes**" or "**pipe**"

  * for :ref:`signatures/ioc-types:Named Pipes`

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
------

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
----------

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
--------

Keyword IOCs are specified in the following format:

.. code-block:: text

   my-keyword-ioc

The keyword-based IOC files contain plaintext strings that are matched
against the console output of THOR. Not all console output is being used for those
IOCs, you can find the full list here: :ref:`signatures/ioc-types:IOC types`.

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
-------

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
-----------------

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
-----------

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

