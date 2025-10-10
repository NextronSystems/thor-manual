.. Index:: Resource Control

Resource Control
----------------

THOR's internal resource control feature puts the system's stability and
the responsiveness of running services first.

Resource control is active by default. You can deactivate it using
**--no-resource-check**.

Be advised that due to Resource Control, the THOR scan may terminate its
completion. The scan gets terminated under the following conditions:

1. If the available physical memory drops below 50MB (can be customized with ``--memory-limit``)

2. | If more than 60 MB of log data have been written (disk / syslog) (can be customized with ``--log-size-limit``)
   | In this case, THOR switches in the "reduced-logging" mode in which it only transmits "Notices, Warnings and Alerts" and after another 4 MB of log data THOR terminates itself in order to prevent log flooding due to a high number of false positives.

If the scan terminates repeatedly you should check what causes the
performance issues or choose times with less workload (e.g. weekends,
night). To debug such states, you can check the last warning that THOR
generates before exiting the scan. It includes the top memory consumers
that could have caused the memory exhaustion.

.. figure:: ../images/image25.png
   :alt: Resource Control Scan Termination

   Resource Control Scan Termination

.. warning:: 
  Deactivating Resource Control on systems with exhausted
  resources can put the system's stability at risk.

Automatic Soft Mode
^^^^^^^^^^^^^^^^^^^

Soft mode is automatically activated on systems with low hardware
resources.

If any of the following conditions is fulfilled, THOR activates soft mode:

* Less than 2 CPU cores
* Less than 1024 MB of RAM

In Soft mode several checks and features that could risk system's
stability or could provoke an Antivirus or HIDS to intervene with the
scanner are disabled. See :ref:`scanning/scan-modes:scan modes` for a complete
overview.