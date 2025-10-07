.. Index:: Failed Scans

Most Frequent Causes of Failed Scans
------------------------------------

The following examples are the most frequent causes of a failed scan.

External Processes Terminating THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Whenever THOR dies without any traceback or panic message and no error
message in the log file, an external process terminated the THOR process.

Usually the four following sources are responsible (descending order, by frequency):

1. Antivirus or EDR killed the THOR process
2. A user killed the THOR process
3. A management solution that noticed a high CPU load caused by the THOR process killed it
4. Attackers killed the THOR process

.. note::
   A process termination that always happens at the same element is a
   sign for an Antivirus or EDR detection.

Insufficient Free Memory
^^^^^^^^^^^^^^^^^^^^^^^^

If the system you are trying to scan runs out of free memory, you will
encounter the following message in your scan log:

.. code-block:: none

   fatal error: out of memory

Probable causes:

1. Other processes consume a lot of memory
2. THOR's scanning of certain elements requires a lot of memory
3. You've set ulimit values that are too restrictive
4. You are using the wrong THOR version for your architecture
5. You've activated a feature that consumes a lot of memory (e.g. ``--mft`` or ``--deep``)

Whenever THOR recognizes a low amount of free memory, it checks the
top three memory consumers on the system and includes them in the log message,
before exiting the scan.

You could try running THOR in Soft Mode (``--soft``), which will deactivate
modules and features that require a lot of memory.

Using the 32bit binary of THOR named ``thor.exe`` on a 64bit system
can lead to interrupted scans with the above error message. The 32bit binary
is not able to address as much memory as the 64bit version. Always make
sure to use the correct THOR version for the respective architecture.

Several ``ulimits`` might cause THOR to terminate if they are too restrictive, including:

* locked-in-memory size
* address space
* number of open file descriptors
* maximum data size

If you are certain your machine has sufficient RAM, check your ulimits with ``ulimit -a``
and try to rerun the scan with increased limits, if necessary.
The `man page <https://www.man7.org/linux/man-pages/man5/limits.conf.5.html>`_ for the ulimits
configuration size gives a full overview over the limits and how to persistently modify them.
