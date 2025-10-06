.. Index:: Features

Features
--------

Features are invoked by :ref:`scanning/modules:modules` or other features and provide
further ``Details`` about an item. For example, the ``File System Scan``
might find a ``.zip`` file during a scan and invoke the ``Archive Scan``
feature. The ``Archive Scan`` feature in return will extract the zip file
and scan all the files in it with the ``File System Scan``.

Another example would be the ``Eventlog Analysis`` Module, which might invoke
the ``Sigma Scan`` feature on certain eventlog entries.

.. hint:: 
  Please see chapter :ref:`other/other-topics:archive scan` for a list
  of supported archive formats.

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

The following table gives an overview of THOR's features and
how they are called by the different modules and other features.

.. csv-table::
  :file: ../csv/feature-caller-list.csv
  :widths: 30, 35, 35
  :delim: ;
  :header-rows: 1

.. [5] Dependent on object type, different Sigma rulesets are applied; see :ref:`signatures/sigma:Sigma Rules`
.. [6] Dependent on object type, different YARA rulesets are applied; see :ref:`signatures/yara:YARA Rules`

Feature selectors
^^^^^^^^^^^^^^^^^
Some features in THOR are triggered by YARA rules.

When a (meta or generic) YARA rule with a specific tag matches on a file, the
corresponding feature is started and parses the file.

The standard signatures contain a number of rules with these tags. However, if these rules
do not match on an artifact, but should,
you can add additional rules with these tags as custom signatures.

.. csv-table::
  :file: ../csv/feature-selector-list.csv
  :widths: 40, 40, 50
  :delim: ;
  :header-rows: 1
