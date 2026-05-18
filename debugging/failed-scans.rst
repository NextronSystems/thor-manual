.. Index:: Failed Scans

Most Frequent Causes of Failed Scans
------------------------------------

The following are the most frequent causes of failed scans.

External Processes Terminating THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If THOR terminates without a traceback, panic message, or error message
in the log file, an external process most likely terminated it.

The following four sources are usually responsible (in descending order
of frequency):

1. Antivirus or EDR killed the THOR process
2. A user killed the THOR process
3. A management solution terminated the THOR process after detecting high CPU load
4. Attackers killed the THOR process

.. note::
   A process termination that always happens at the same element is a
   sign for an Antivirus or EDR detection.

Insufficient Free Memory
^^^^^^^^^^^^^^^^^^^^^^^^

If the system you are scanning runs out of free memory, you will see
the following message in the scan log:

.. code-block:: none

   fatal error: out of memory

Probable causes:

1. Other processes consume a lot of memory
2. THOR needs a lot of memory to scan certain elements
3. You've set ulimit values that are too restrictive
4. You are using the wrong THOR version for your architecture
5. You enabled a feature that consumes a lot of memory (for example ``--mft-analysis`` or ``--deep``)

If THOR detects that free memory is running low, it checks the top three
memory-consuming processes on the system and includes them in the log
message before exiting the scan.

You can try running THOR in Soft Mode (``--soft``), which disables
modules and features that require a lot of memory.

Using the 32-bit THOR binary ``thor.exe`` on a 64-bit system can cause
scans to abort with the error message shown above. The 32-bit binary
cannot address as much memory as the 64-bit version. Always make sure
to use the correct THOR binary for the respective architecture.

Several ``ulimits`` can cause THOR to terminate if they are too
restrictive, including:

* locked-in-memory size
* address space
* number of open file descriptors
* maximum data size

If you are certain that the machine has sufficient RAM, check the
current limits with ``ulimit -a`` and rerun the scan with increased
limits if necessary.

The `limits.conf man page <https://www.man7.org/linux/man-pages/man5/limits.conf.5.html>`_
provides a full overview of these limits and explains how to modify
them persistently.
