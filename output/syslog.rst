.. Index:: Syslog Output

Remote Log Output
-----------------

THOR can also send its scan output to one or multiple remote targets.
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
   
   C:\nextron\thor>thor64.exe -s syslog1.server.net -s arcsight.server.net:514:CEF

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
     - THOR text log format
   * - CEF
     - Common Event Format (ArcSight)
   * - JSON
     - Raw JSON
   * - SYSLOGJSON
     - encoded and escaped single line JSON
   * - SYSLOGKV
     - syslog messages that contain strict key/value pairs

If not specified, the DEFAULT type is used.


DEFAULT
"""""""

This format uses the old THOR 10 text log, as output by ``--text``, prefixed with a `<priority>` string for syslog compatibility.

Example:

``<190>Oct  8 11:37:54 arch/127.0.0.1 THOR: Info: MODULE: Startup MESSAGE: Thor Version: 10.8.0 SCANID: S-KybbdhFvHhc``

Common Event Format (CEF)
"""""""""""""""""""""""""

CEF is a format introduced by ArcSight for information exchange. 
See the `whitepaper <https://community.opentext.com/cfs-file/__key/telligent-evolution-components-attachments/00-224-01-00-00-15-93-98/CEF-White-Paper-071709.pdf>`__ about it for details.

The level logged to this format can be specified with the ``--syslog-cef-level`` flag.

Example:

``Oct  8 11:45:05 arch CEF:0|Nextron Systems GmbH|THOR|10|611c94|Thor Version: 10.8.0|3|sproc=Startup msg=Thor Version: 10.8.0``

JSON
""""

This is the standard JSON log format as used in the ``--json`` log.

Example:

``{"type":"THOR message","meta":{"time":"2025-10-08T13:47:09.410735961+02:00","level":"Info","module":"Startup","scan_id":"S-YQ9tIENkusM","event_id":"","hostname":"arch"},"message":"Thor Version: 10.8.0","fields":{},"log_version":"v3.0.0"}``


SYSLOGJSON
""""""""""

This is the same as the JSON format above; however, it is prefixed with a syslog compatible header.

Example:

``<190>Oct  8 11:48:37 maxarch/127.0.0.1 THOR: {"type":"THOR message","meta":{"time":"2025-10-08T13:48:37.297583483+02:00","level":"Info","module":"Startup","scan_id":"S-KG8o5HhgmIk","event_id":"","hostname":"arch"},"message":"Thor Version: 10.8.0","fields":{},"log_version":"v3.0.0"}``

SYSLOGKV
""""""""

This is similar to the DEFAULT format, but instead of `KEY: value` pairs, `KEY='value'` formatting is used.

Example:

``<190>Oct  8 11:49:52 arch/127.0.0.1 THOR: Info: MODULE='Startup' MESSAGE='Thor Version: 10.8.0' SCANID='S-maU4LPgIAFM'``

Protocols
~~~~~~~~~

The protocols that can be specified are:

- UDP
- TCP
- TCPTLS

The default protocol is UDP.

TCPTLS will by default use the system root certificates to verify the server it connects to.
This behaviour can be adjusted with the ``--ca`` and ``--insecure`` flags.

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
