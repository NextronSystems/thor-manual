.. Index:: IOC Types

.. this is for the formatting of the IOC types table
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

IOC Types
=========

IOCs are indicators of compromise that are applied during a scan.
They are categorized based on their :ref:`signatures/ioc-types:IOC types`, and can be specified
as either :ref:`signatures/ioc-formats:YAML IOC files` or  :ref:`signatures/ioc-formats:Simple IOC files`.

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

THOR supports different types of IOCs. An IOC's type determines on which data it is
applied during the scan, see below.

Hashes
------

Hash IOC must be MD5, SHA1, SHA256, or PE import hashes. They are applied to: 

 - the hashes of all files that THOR scans
 - Hashes in the Amcache that THOR finds

File Names
----------

Filename IOC files allow you to define IOCs based on filename and filepath.

This can also be used to define false positives, or reduce the
score of well-known files and locations, by using negative scores.

Filename IOCs are applied to _all_ fields of all objects that THOR encounters.

Keywords
--------

.. warning::
   Keyword IOCs are deprecated. If you use keyword IOCs, consider switching to
   either keyword YARA rules or Sigma rules.

Keyword IOCs are applied to all objects; more specifically, to text formatted objects
as they are printed when using ``--log-object``.

One use case would be to have different strings which you encountered in Scheduled Tasks
within Windows.

Domains
-------

Domain IOCs (also called C2 IOCs) specify remote servers which are known to be malicious.
This can include:

 - Domain names
 - FQDNs
 - Single IPs
 - IP address ranges in CIDR notation

These IOCs are applied to:
 - DNS cache entries
 - Web page visits and downloads
 - Firewall rules
 - Hosts file entries
 - the connections of examined processes
 - Auditlog / Journald / Windows Eventlog entries
 - Log lines

With ``--c2-memory-analysis``, they are also applied to process memory.

Mutexes or Events
-----------------

Mutex or Event IOCs are applied to:

 - encountered mutexes / events
 - process handles

You can decide if you want to set a scope by using ``Global\\``
or ``BaseNamedObjects\\`` as a prefix. If you decide to use none, your expression
will be applied to any scope.

Unlike most other IOCs, which check for "contains", plain text mutex or event IOCs are applied as "equals".

Named Pipes
-----------

Named Pipe IOCs are applied to Windows Named Pipes. The ``\\\\.\\pipe\\``
prefix should not be part of the IOC.

Unlike most other IOCs, which check for "contains", plain text named pipe IOCs are applied as "equals".