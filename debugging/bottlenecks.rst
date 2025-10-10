.. Index:: Finding Bottlenecks

Finding Bottlenecks
-------------------

You may get the error message ``MESSAGE: Maximum runtime has exceeded, killing THOR``
or encounter very slow/never-ending scans.

This message will include the elements that THOR scanned when it terminated,
including the amount of time it took for them. This can help you to determine
why THOR took so long and if it was due to a specific element.

You can also check the statistics table in ``thor10.db`` on the problematic
endpoint after a scan to determine the last element or elements that took
a long time to process.

We recommend using: https://sqlitebrowser.org/

The THOR DB is located at: ``C:\ProgramData\thor\thor10.db``.

.. figure:: ../images/image13.png
   :alt: Find Bottlenecks
