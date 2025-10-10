.. Index:: Diagnostics Pack

Diagnostics Pack
----------------

THOR Util comes with the functionality to collect a diagnostics pack for
THOR scans. This is helpful if a scan is taking more time as expected
or if THOR exits unexpectedly. More details can be found in the
`diagnostics section of THOR Util <https://thor-util-manual.nextron-systems.com/en/latest/usage/diagnostics.html>`_.

Diagnostics packs should be created while the THOR scan is still running (e.g.
while THOR is taking an unusually high amount of RAM, taking a long time on a
single element, etc.).

To create a diagnostics pack, run:

.. code-block:: doscon
   
   C:\thor>thor-util.exe diagnostics

It will connect to the running THOR, query different information (e.g. about
allocated memory, threads, etc.) and gather them in a single ZIP.