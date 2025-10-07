.. Index:: Frozen Scans

Most Frequent Causes of Frozen Scans
------------------------------------

Whenever THOR stops or pauses without any traceback or panic message
and no error messages, usually the following sources are responsible
(descending order, by frequency):

1. An :ref:`debugging/frozen-scans:antivirus or edr suspends thor` (>98%)
2. A "paused" command line window due to :ref:`debugging/frozen-scans:windows quick edit mode` (<1%)
3. A :ref:`debugging/frozen-scans:constant high system load` that causes THOR to stay back and wait for an idling CPU (<1%)
4. :ref:`debugging/frozen-scans:the perception of a stalled scan`, which is actually running (<1%)

Antivirus or EDR suspends THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In more than 98% of the cases, an Antivirus or EDR is responsible for a
stalled process. Especially McAfee AV/EDR is a well-known source of issues. This
is caused by the different dialogues in which exceptions have to be defined and
the fact certain kinds of blocks cannot be found in any logs.

If a THOR scans stalls in one of these modules, an Antivirus or EDR interaction is highly likely:

* Mutex
* Events
* NamedPipes
* ShimCache
* ProcessCheck

**Solution**: Review all possible exclusions in your AV / EDR and add the THOR folder to the exclusion list

Windows Quick Edit Mode
^^^^^^^^^^^^^^^^^^^^^^^

Since Windows 10, the Windows command line window has the so-called "Quick Edit Mode"
enabled by default. This mode causes a behavior that can lead to a paused THOR scan
process. Whenever a user switches the active windows from the cmd.exe to a different
application, e.g. Windows Explorer, and clicks back into the command line window, the
running process automatically gets suspended. A user has to press "Enter" to resume
the suspended process. As the progress indicator of THOR isn't always changing, this
could lead to the impression that the scan paused by itself.

See `this StackOverflow post <https://stackoverflow.com/questions/30418886/how-and-why-does-quickedit-mode-in-command-prompt-freeze-applications>`_ for more details.

**Solution**: Press "Enter" in the command line window

Constant High System Load
^^^^^^^^^^^^^^^^^^^^^^^^^

Since THOR automatically sets a low process priority a scan can slow down to a level
that appears to be paused or suspended on systems that are under a constant high load.

**Solution**: You can avoid this behavior by using the ``--no-low-priority`` flag. Be aware
that scans on a system with a constant high CPU load take longer than on other systems
and could slow down the processes that would otherwise take all the CPU capacity.

The Perception of a Stalled Scan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Under certain circumstances the scan may appear stalled but is still running.
You can always interrupt a scan using CTRL+C that brings THOR into the interrupt
menu in which you can see the currently scanned element. In case of the "FileScan"
module, this is a file or folder. In case of the "EventLog" module, this is an
event with an ID. The amount of time spent on this element is also printed.

If THOR processes the same element for several hours, we recommend checking
that element (size, format, access rights, location).

**Solution**: Check progress using the interrupt menu (CTRL+C)
