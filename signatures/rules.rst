.. Index:: Custom Rules

.. this is for the formatting of the Rules Modules table
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

Custom Rules
============

There are different types of rules you can use to write your own custom
rules.

.. _Rules Modules:

For a list of Features/Modules which are used by :ref:`signatures/sigma:sigma rules`,
:ref:`signatures/yara:generic yara rules` and
:ref:`signatures/yara:specific yara rules`, please see the table below.

.. csv-table::
   :file: ../csv/thor_feature_rules.csv
   :delim: ;
   :header-rows: 1

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

See :ref:`scanning/modules:modules` and :ref:`scanning/features:features`
for a list of all available components.