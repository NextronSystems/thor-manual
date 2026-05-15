.. Index:: Modules

Modules
=======

Modules are standalone jobs that THOR executes one after another. Each
module performs a specific task. For example, the ``File System Scan``
module scans the file system, while ``User Account Check`` inspects the
system for user accounts. Modules can invoke one or more
:ref:`scanning/features:features`, which are described in the following
chapter.

By default, all modules listed below run during a THOR scan except the
``MFT`` module; see :ref:`scanning/special-scan-modes:MFT Analysis`.
Enabled modules can be controlled with the following flags:

.. list-table::
   :header-rows: 1
   :widths: 35, 50

   * - Flag
     - Description
   * - ``--module``
     - Enable only the specified module(s)
   * - ``--exclude-component``
     - Disable the specified module(s)

Available Modules
^^^^^^^^^^^^^^^^^

.. csv-table::
  :file: ../csv/scan-module-naming.csv
  :widths: 33, 33, 33
  :delim: ;
  :header-rows: 1

OS Module Overview
^^^^^^^^^^^^^^^^^^
 
Not all modules are available on every platform. For example,
``RegistryChecks`` is available only on Windows. The following table
shows which modules are available on each operating system.

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

.. csv-table::
  :file: ../csv/os-module-overview.csv
  :widths: 25, 25, 25, 25
  :delim: ;
  :header-rows: 1

Scan Mode Overview
^^^^^^^^^^^^^^^^^^

The following table shows which modules are active in the different scan
modes. For operating system compatibility, see
:ref:`scanning/modules:os module overview`.

- Normal: THOR without any flags regarding modules or features
- Fast: THOR scan with ``--fast``
- Soft: THOR scan with ``--soft``
- Deep: THOR scan with ``--deep``

.. csv-table::
  :file: ../csv/scan-mode-overview.csv
  :widths: 28, 18, 18, 18, 18
  :delim: ;
  :header-rows: 1

.. [1] Disabled on Domain Controllers
