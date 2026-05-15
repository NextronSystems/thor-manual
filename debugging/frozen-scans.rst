.. Index:: Frozen Scans

Most Frequent Causes of Frozen Scans
------------------------------------

If THOR stops or appears to pause without a traceback, panic message, or
other error output, one of the following causes is usually
responsible (in descending order of frequency):

1. An :ref:`debugging/frozen-scans:antivirus or edr suspends thor` (>98%)
2. A paused command-line window due to :ref:`debugging/frozen-scans:windows quick edit mode` (<1%)
3. :ref:`debugging/frozen-scans:constant high system load`, which causes THOR to wait for CPU time (<1%)
4. :ref:`debugging/frozen-scans:the perception of a stalled scan`, even though the scan is still running (<1%)

Antivirus or EDR suspends THOR
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In more than 98% of cases, an antivirus or EDR product is responsible
for a stalled process. McAfee AV/EDR is a particularly common source of
issues. This is often caused by the different places in which
exceptions must be defined and by the fact that some types of blocks do
not appear in any logs.

If a THOR scan stalls in one of these modules, antivirus or EDR
interaction is highly likely:

* Mutex
* Events
* NamedPipes
* ShimCache
* ProcessCheck

**Solution**: Review all available exclusions in your AV or EDR product
and add the THOR folder to the exclusion list.

Windows Quick Edit Mode
^^^^^^^^^^^^^^^^^^^^^^^

On modern Windows systems, the command-line window often has "Quick
Edit Mode" enabled by default. This can pause a running THOR scan
without producing an error message. In this situation, the process
resumes only after the user presses ``Enter``. Because the THOR
progress indicator does not change constantly, this can look like the
scan paused by itself.

See `this StackOverflow post <https://stackoverflow.com/questions/30418886/how-and-why-does-quickedit-mode-in-command-prompt-freeze-applications>`_ for more details.

**Solution**: Press ``Enter`` in the command-line window.

Constant High System Load
^^^^^^^^^^^^^^^^^^^^^^^^^

THOR automatically sets a low process priority. On systems that are
under constant high load, a scan can therefore slow down to a level
that appears to be paused.

**Solution**: You can avoid this behavior by using the
``--no-low-priority`` flag. Keep in mind that scans on systems with a
constant high CPU load will still take longer than on other systems and
may slow down other processes.

The Perception of a Stalled Scan
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Under certain circumstances, the scan may appear stalled even though it
is still running. You can always interrupt a scan using ``Ctrl+C``.
This opens the interrupt menu, where you can see the element that THOR
is currently processing. In the ``FileScan`` module, this is a file or
folder. In the ``EventLog`` module, it is an event with an ID. The time
spent on this element is also shown.

If THOR processes the same element for several hours, we recommend
checking that element, including its size, format, access rights, and
location.

**Solution**: Check the current progress using the interrupt menu
(``Ctrl+C``).
