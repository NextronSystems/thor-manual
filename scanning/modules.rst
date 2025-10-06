.. Index:: Modules

Modules
-------

Modules are standalone jobs, which are being executed one after the other by THOR.
Those modules are invoking one job, for example the ``File System Scan`` module will
scan your file system, or the ``User Account Check`` will scan your system for user
accounts. Modules can invoke one or multiple :ref:`scanning/features:features`,
which we will explain further down in this section.

OS Module Overview
^^^^^^^^^^^^^^^^^^
 
.. raw:: html

        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
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

.. csv-table::
  :file: ../csv/os-module-overview.csv
  :widths: 25, 25, 25, 25
  :delim: ;
  :header-rows: 1

.. hint:: 
  For a list of module names and how to turn them off, please
  see :ref:`scanning/modules:scan module names`

Scan Mode Overview
^^^^^^^^^^^^^^^^^^

The table below shows you which modules will be active
with the different scan modes. For OS compatibility, see
:ref:`scanning/modules:os module overview`.

- Normal: THOR without any flags regarding modules or features
- Fast: THOR scan with ``--fast`` flag
- Soft: THOR scan with ``--soft`` flag
- Deep: THOR scan with ``--deep`` flag

.. csv-table::
  :file: ../csv/scan-mode-overview.csv
  :widths: 28, 18, 18, 18, 18
  :delim: ;
  :header-rows: 1

.. [1] Disabled on Domain Controllers

Scan Module Names
^^^^^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/scan-module-naming.csv
  :widths: 33, 33, 33
  :delim: ;
  :header-rows: 1
