.. Index:: Syslog Output

Syslog Output
-------------

THOR can also send its scan output to one or multiple syslog targets.
In the below chapter we will show a few examples and how to configure
this option.

Target Definition
^^^^^^^^^^^^^^^^^

THOR version 10 comes with a very flexible remote log target definition. You
can define as many targets as you like and give them different ports,
protocols and formats.

For example, if you want to send the THOR log entries to a Syslog server
and an ArcSight SIEM at the same time, you just have to define two log
targets with different formats.

.. code-block:: doscon
   
   C:\nextron\thor>thor64.exe -s syslog1.server.net -s arsight.server.net:514:CEF

THOR supports two different definitions:

+----------+-----+--------+-----+--------+-----+------------+
| System   | :   | Port   | :   | Format | :   | Protocol   |
+----------+-----+--------+-----+--------+-----+------------+

Or: 

+----------+-----+--------+
| URL      | :   | Format |
+----------+-----+--------+

In the latter case, no protocol is specified as the URL's protocol (HTTP or HTTPS) is used.

Available formats
~~~~~~~~~~~~~~~~~

The available formats are:

.. list-table::
   :header-rows: 1
   :widths: 40, 60

   * - Option
     - Format
   * - DEFAULT
     - standard THOR log format
   * - CEF
     - Common Event Format (ArcSight)
   * - JSON
     - Raw JSON
   * - SYSLOGJSON
     - encoded and escaped single line JSON
   * - SYSLOGKV
     - syslog messages that contain strict key/value pairs

If not specified, the DEFAULT type is used.

Protocols
~~~~~~~~~

The protocols that can be specified are:

- UDP
- TCP
- TCPTLS

The default protocol is UDP.

Examples
~~~~~~~~

Sending Syslog to a target on a port that differs from the default port
514/udp looks like this:

.. code-block:: none

   --remote-log 10.0.0.4:2514

Sending logs to a receiving server using an SSL/TLS encrypted TCP
connection:

.. code-block:: none

   --remote-log 10.0.0.4:6514:DEFAULT:TCPTLS

Sending JSON logs to an HTTP webhook:

.. code-block:: none

   --remote-log https://my-webhook.internal:6514/receive:JSON

Sending JSON formatted messages to a certain UDP port:

.. code-block:: none 

   --remote-log 10.0.0.4:5444:JSON:UDP

Common Event Format (CEF)
^^^^^^^^^^^^^^^^^^^^^^^^^

THOR supports the CEF format for easy integration into ArcSight SIEM
systems. The CEF mapping is applied to a log line if the syslog target
has the CEF format set, e.g.:

.. code-block:: doscon

   C:\nextron\thor>thor.exe -s syslog1.server.local:514:CEF

Local Syslog
^^^^^^^^^^^^

If your Linux system is already configured to forward syslog messages,
you might just want to write to your local syslog and use the existing
system configuration to forward the events. This can be achieved by
using the ``--local-syslog`` flag.

THOR logs to the ``local0`` facility, which is not being written to a
file by default on every Linux distribution. By default Debian derivatives
log it to ``/var/log/syslog``; Others such as Red Hat do not. To enable
writing ``local0`` messages to a file a syslog configuration for
rsyslog (e.g. ``/etc/rsyslog.conf``) could look like:

.. code-block:: none

    # THOR --local-syslog destination
    local0.*        -/var/log/thor

Do not forget to restart the syslog daemon (e.g. ``systemctl restart rsyslog.service``).

You then either add that file in your syslog forwarding configuration
or write to a file that is already forwarded instead.
