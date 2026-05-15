.. Index:: Diagnostics Pack

Diagnostics Pack
================

THOR Util can collect a diagnostics pack for THOR scans. This is useful
if a scan is taking longer than expected or if THOR exits unexpectedly.
More details can be found in the `diagnostics section of THOR Util
<https://thor-util-manual.nextron-systems.com/en/latest/usage/diagnostics.html>`_.

Diagnostics packs should be created while the THOR scan is still
running, for example when THOR is using an unusually high amount of RAM
or spending a long time on a single element.

To create a diagnostics pack, run:

.. code-block:: doscon
   
   C:\thor>thor-util.exe diagnostics

The tool connects to the running THOR process, collects diagnostic
information such as allocated memory and thread state, and writes
everything to a single ZIP archive.
