
Evidence Collection
===================

File Collection (Bifrost)
-------------------------

Bifrost v1 with Script-Based Server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The **./tools** folder in the program directory contains a simple Python
based file collection server named Bifrost. The script is named
**bifrost-server.py**.

You can run that script on any internal system with a Python script
interpreter installed. By default, it uses port 1400/tcp for incoming
connections but you can use any port you like.

Usage is:

usage: bifrost-server.py [-h] [-d out-dir] [-i ip] [-p port]

Bifrost

optional arguments:

* -h, --help show this help message and exit
* -d out-dir Quarantine directory
* -i ip IP address to bind to
* -p port Port to bind to (tcp, default 1400)

You can run the server script with:

.. code:: bash
   
   python ./bifrost-server.py

In order to send suspicious file to that server, you have to set some
command line flags when running THOR, e.g.

.. code:: batch
   
   thor64.exe --bifrostServer myserver

A more complex statement setting a minimum score and custom port would
look like this:

.. code:: batch
   
   thor64.exe --bifrostServer myserver --bifrost-port 8080 --bifrostLevel 80

THOR will then try to submit all samples with score equal or higher than
80 to a Bifrost service running on myserver port 8080/tcp.

Bifrost v2 with ASGARD
^^^^^^^^^^^^^^^^^^^^^^

Bifrost v2 cannot be used standalone yet. The required API Key is set by
ASGARD v2 during initialization and is unknown to a THOR user.

You can activate the quarantine function via Bifrost v2 when creating a
single or group scan via the ASGARD management interface.

.. figure:: ../images/image21.png
   :target: ../_images/image21.png
   :alt: Configure Quarantine via Bifrost in New Scan Dialogue

   Configure Quarantine via Bifrost in New Scan Dialogue

.. figure:: ../images/image22.png
   :target: ../_images/image22.png
   :alt: Collected File Evidence in ASGARD v2

   Collected File Evidence in ASGARD v2

Process Memory Dumps (--dump-procs)
-----------------------------------

Since THOR version 10.5 it supports process dumping to backup volatile
malware information.

THOR on Windows creates a process dump of any process that is considered
malicious. Maliciousness is determined as anything that triggers a
warning or an alert.

Activate process memory dumping with "**--dump-procs**".

This process dump can then be analyzed with standard tools later on to
examine the found malware.

.. figure:: ../images/image23.png
   :target: ../_images/image23.png
   :alt: Process dumping

   Process dumping

.. figure:: ../images/image24.png
   :target: ../_images/image24.png
   :alt: Process dumps on disk

   Process dumps on disk

To prevent flooding the disk fully in case many dumps are created, old
dumps of a process are overwritten if a new dump is generated. Also,
THOR will not generate dumps by default if less than 5 GB disk space is
available. This can be overwritten to always or never dump malicious
processes.

Also note that THOR will never dump lsass.exe to prevent these dumps
from potentially being used to extract passwords by any attackers.

