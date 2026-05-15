.. Index:: Features

.. raw:: html

   <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
   <script>
   $(document).ready(function() {
   $('table p:contains("Supported")').not(':contains("Not")').parent().addClass('enabled');
   $('table p:contains("Not Supported")').parent().addClass('disabled');
   $('table p:contains("Reduced")').parent().addClass('reduced');
   $('table p:contains("Enabled")').parent().addClass('enabled');
   $('table p:contains("Disabled")').parent().addClass('disabled');
   });
   </script>
   <style>
   .enabled {text-align: center;}
   .reduced {background-color:#cccccc !important; text-align: center;}
   .disabled {background-color:#888888 !important; text-align: center;}
   </style>

Features
========

Features are invoked by :ref:`scanning/modules:modules` or by other
features and provide additional processing or details for an item. For
example, the ``File System Scan`` may find a ``.zip`` file during a
scan and invoke the ``Archive Scan`` feature. The ``Archive Scan``
feature then extracts the ZIP archive and scans the contained files with
``File System Scan``.

.. hint:: 
  See :ref:`scanning/features:archive scan` below for a list
  of supported archive formats.

Another example is the ``Eventlog Analysis`` module, which may invoke
the ``Sigma Scan`` feature for selected Event Log entries.

By default, all features are enabled unless noted otherwise below.
Features can be disabled with
``--exclude-component <feature-name>``.

.. csv-table::
  :file: ../csv/feature-naming.csv
  :widths: 33, 33, 33
  :delim: ;
  :header-rows: 1

Feature Scan Mode Overview
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/feature-scan-mode-overview.csv
  :widths: 20, 20, 20, 20, 20
  :delim: ;
  :header-rows: 1

.. [2] Disabled on Domain Controllers
.. [3] Only supported on Windows
.. [4] Only supported on Windows and Linux

Feature caller list
^^^^^^^^^^^^^^^^^^^

When features are invoked, they receive specific objects to work on.
Some features may also extract new objects from those inputs. The
following table gives an overview of all features and the objects they
consume and produce.

For a list of all object types, see the `THOR Log definition <https://github.com/NextronSystems/jsonlog>`__.

.. csv-table::
  :file: ../csv/feature-caller-list.csv
  :widths: 30, 35, 35
  :delim: ;
  :header-rows: 1

.. [5] Dependent on object type, different Sigma rulesets are applied; see :ref:`signatures/sigma:Sigma Rules`
.. [6] Dependent on object type, different YARA rulesets are applied; see :ref:`signatures/yara:YARA Rules`

Feature selectors
^^^^^^^^^^^^^^^^^
Some THOR features are triggered by YARA rules.

When a meta or generic YARA rule with a specific tag matches a file, the
corresponding feature is started and parses that file.

The standard signatures already contain a number of rules with these
tags. However, if a relevant artifact is not matched, you can add
additional custom signatures with the same tags.

.. csv-table::
  :file: ../csv/feature-selector-list.csv
  :widths: 40, 40, 50
  :delim: ;
  :header-rows: 1

Archive Scan
^^^^^^^^^^^^

The ``Archive`` feature supports the following archive types:

- ZIP
- RAR
- TAR
- GZIP
- 7ZIP
- CAB
- BZIP2

When scanning a file inside one of these archive types, THOR appends
the internal path to the archive path for reporting and scan purposes,
for example for filename IOCs or YARA rules. For example, an archive
``C:\temp\test.zip`` containing a file ``path/in/zip.txt`` is reported
with the simulated path ``C:\temp\test.zip\path\in\zip.txt``.
