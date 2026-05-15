.. Index:: IOC Formats

IOC Formats
===========

THOR checks the contents of the ``./custom-signatures`` subdirectories.
There is one subfolder for each signature type, for example YARA,
Sigma, or IOCs. Files must be placed in the correct subfolder to be
loaded.

For YARA rules and simple IOC files, string tags in the file name are
used to further distinguish signatures.

For example, a file named ``my-c2-iocs.txt`` is initialized as a simple
IOC file containing C2 server indicators.

Internally, the regex ``\Wc2\W`` is used to detect the tag. This means
that ``mysource-c2-iocs.txt`` and
``dec15-batch1-c2-indicators.txt`` are detected correctly, whereas
``filenameiocs.txt`` or ``myc2iocs.txt`` are not.

If you do not want to place your custom IOCs on potentially compromised
systems during an engagement, you can use ``thor-util`` to encrypt
custom signatures. This is described in detail in the `THOR Util manual
<https://thor-util-manual.nextron-systems.com>`__.

YAML IOC files
~~~~~~~~~~~~~~

YAML IOC files contain metadata, for example author, date, and
description, as well as the IOCs themselves. IOCs are grouped by IOC
type and can optionally include false positive conditions.

They must have the ``.yml`` extension or, if encrypted, the ``.yms``
extension.

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

Simple IOC files are essentially CSV-style files that contain IOCs and
comments. Simple IOC files must use the ``.txt`` extension. Encrypted
simple IOC files must use the ``.dat`` extension.

.. warning::
   Simple IOCs are deprecated and offer less flexibility than YAML
   IOCs. For new IOCs, we recommend using YAML IOCs.

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

Files with the string ``hash`` or ``hashes`` in their file name are
initialized as hash IOC sets.

Hash IOCs are specified one per line and may use one of two supported
formats:

.. code-block:: text

   hash;comment
   hash;score;comment

In the first format, the score defaults to ``100``.

The hash must be an MD5, SHA1, SHA256, or imphash.

The comment can be chosen freely and is printed as part of any match.

.. code-block:: text
   :caption: custom-hashes-iocs.txt
   :emphasize-lines: 2
   :linenos:

   0c2674c3a97c53082187d930efb645c2;DEEP PANDA Sakula Malware - http://goo.gl/R3e6eG
   f05b1ee9e2f6ab704b8919d5071becbce6f9d0f9d0ba32a460c41d5272134abe;50;Vulnerable Lenovo Diagnostics Driver - https://github.com/alfarom256/CVE-2022-3699/tree/main

File Names
----------

Filename IOCs are specified one per line and may use one of two
supported formats:

.. code-block:: text

   # Comment
   my-filename-regex;score

   # Comment
   my-filename-regex;score;my-fp-regex

Filename IOCs are case-insensitive if they do not use special regex
characters such as ``*``, ``.``, or ``[``. Otherwise, they are
case-sensitive by default, but can be made case-insensitive by using
``(?i)`` anywhere in the regex.

.. code-block:: text
   :caption: psexec-filename-iocs.txt
   :linenos:

   \\PsExec\.exe;60;\\SysInternals\\

Keywords
--------

Keyword IOCs use the following format:

.. code-block:: text

   my-keyword-ioc

Keyword IOC files contain plain-text strings that are matched against
THOR console output. Not all console output is used for these IOCs; see
:ref:`signatures/ioc-types:IOC types` for the full list.

Each line is treated as a case-sensitive string. A comment can be added
with a line starting with ``#`` and applies to all following IOCs until
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

Domain IOCs use one of the following formats:

.. code-block:: text

   # Description
   <domain/IP/CIDR>

   # Description
   <domain/IP/CIDR>;score

If no score is specified, the score defaults to ``100``.

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

Mutex or Event IOCs use the following format:

.. code-block:: text

   <mutex/event>;Description

The score is always set to ``70``.

.. code-block:: text
   :linenos:
   :caption: custom-mutex-iocs.txt

   Global\\mymaliciousmutex;Operation Fallout – RAT Mutex
   Global\\WMI_CONNECTION_RECV;Flame Event https://bit.ly/2KjUTuP
   Dwm-[a-f0-9]{4}-ApiPort-[a-f0-9]{4};Chinese campaign malware June 19

Named Pipes
-----------

Named Pipe IOCs use one of the following formats:

.. code-block:: text

   Named pipe;Description

   Named pipe;Score;description

If no score is present, it defaults to ``100``.

.. code-block:: text
   :caption: custom-named-pipes-iocs.txt
   :linenos:

   # Incident Response Engagement
   MyMaliciousNamedPipe;Malicious pipe used by known RAT
   MyInteresting[a-z]+Pipe;50;Interesting pipe we have seen in new malware
