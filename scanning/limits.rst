.. Index:: Limits

CPU Limit
---------

Since the ``--cpu-limit`` behavior can cause some confusion, we will
explain the functionality of it a bit more in detail here.

This argument will take an integer (default 95; minimum 15), which
represents the maximum CPU load at which THOR will be actively scanning.
The value can be seen as percentage of the systems maximum CPU load.

This can be helpful to reduce the load on server systems with real-time
services, or to reduce the noise produced by fans in laptops.
      
The specified value instructs THOR to pause (all scanning), if the load
of the systems CPU is higher than the ``cpu-limit``. One example would be,
if a user is doing something CPU intensive, and THOR is running at the same
time, THOR will pause and wait until the CPU load drops below the limit
before continuing.

To illustrate this a bit, please see the table below:

.. list-table:: --cpu-limit 40
   :header-rows: 1

   * - Total CPU load of system
     - THOR status
   * - 20 %
     - running
   * - 80 % (user is running CPU intensive tools)
     - paused/idle
   * - 30 %
     - running

.. hint::
   A tool like ``top`` might show values greater than 100% for a running THOR
   process. Please see ``Irix Mode`` in the man page of
   ``top``: https://man7.org/linux/man-pages/man1/top.1.html

File Size Limit
---------------

The default file size limit for deeper investigations (hash
calculation and YARA scanning) is 30 MB. The file size limit for the
``--deep`` scan mode is 200 MB.

You can adjust the values in ``./config/thor.yml``. This file does not
get overwritten by an update or upgrade.

Special scan features like the EVTX or Memory Dump scan ignore these
limits. See :ref:`scanning/scan-modes:scan modes` for a full list of features
and how they interact with the file size limit.

Chunk Size in DeepDive
^^^^^^^^^^^^^^^^^^^^^^

The chunk size in DeepDive module is set to the value defined as 
``--chunk-size``. DeepDive uses overlapping chunks of this size for 
YARA rule scanning.

Example: If the chunk size is set to a default of 12 MB, DeepDive use the
following chunks in its scan to apply the YARA rule set:

.. code-block:: 

   Chunk 1: Offset 0 – 12
   Chunk 2: Offset 6 – 18
   Chunk 3: Offset 12 – 24
   Chunk 4: Offset 18 – 30

