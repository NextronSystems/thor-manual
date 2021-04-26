.. role:: raw-html-m2r(raw)
   :format: html

Syslog
======

Target Definition
-----------------

THOR version 10 comes with a very flexible Syslog target definition. You
can define as many targets as you like and give them different ports,
protocols and formats.

For example, if you want to send the THOR log entries to a Syslog server
and an ArcSight SIEM at the same time, you just have to define two log
targets with different formats.

.. code:: batch
   
   thor.exe -s syslog1.server.net -s arsight.server.net:514:CEF

The definition consists of 4 elements:

+----------+-----+--------+-----+--------+-----+------------+
| System   | :   | Port   | :   | Type   | :   | Protocol   |
+----------+-----+--------+-----+--------+-----+------------+

The available options for each element are:

.. code:: bash

   (target ip):(target port):(DEFAULT/CEF/JSON/SYSLOGJSON/SYSLOGKV):(UDP/TCP/TCPTLS)

The available type field values require an explication:

* DEFAULT: standard THOR log format
* CEF: Common Event Format (ArcSight)
* JSON: Raw JSON
* SYSLOGJSON: encoded and escaped single line JSON
* SYSLOGKV: syslog messages that contain strict key/value pairs

There are default values, which do not have to be defined explicitly:

.. code:: bash

   (your target system ip):514:DEFAULT:UDP

Sending Syslog to a target on a port that differs from the default port
514/udp looks like this:

.. code:: bash

   -s 10.0.0.4:2514

Sending Syslog to a receiving server using an SSL/TLS encrypted TCP
connection:

.. code:: bash

   -s 10.0.0.4:6514:DEFAULT:TCPTLS

When changing the protocol from UDP to TCP, all preceding fields have to
be set:

.. code:: bash

   -s 10.0.0.4:514:DEFAULT:TCP

You can define as many targets as you like.

Common Event Format (CEF)
-------------------------

THOR supports the CEF format for easy integration into ArcSight SIEM
systems. The CEF mapping is applied to a log line if the syslog target
has the CEF format set, e.g.:

.. code:: batch

   thor.exe -s syslog1.server.local:514:CEF

All details on the definition of syslog targets can be found in chapter
16.1.
