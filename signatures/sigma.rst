.. Index:: Sigma Rules

Sigma Rules
~~~~~~~~~~~

Sigma is a generic rule format for detections on structured data. Sigma is for
log data, what Snort is for network packets and YARA is for files.

THOR ships with the public Sigma rule set, which
is maintained by the community at `<https://github.com/SigmaHQ/sigma>`_,
as well as additional Nextron internal rules.

THOR applies Sigma rules to all objects it encounters. This is most relevant
for Windows Eventlogs and log files on disk (``.log``).

By default only the results of Sigma rules of level critical and high are shown.
If called with the ``--intense`` flag, medium level rules are applied as well.

Custom Sigma rules must have the ``.yml`` extension for unencrypted sigma rules
and the ``.yms`` extension for encrypted sigma rules.

.. figure:: ../images/image31.png
   :alt: Example Sigma match on Windows Eventlog

   Example Sigma match on Windows Eventlog

Sigma matching on THOR output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sigma rules can also be written to match on THOR content.
These rules need to have a logsource with `product: THOR`
and `service: object-type`.

The available object types that can be matched on can be listed with
``--describe-object-type all``. All objects of a specific type can also be
printed by using ``--log-object-type specificobjecttype``. This can be helpful
to determine available fields for matching.

Sigma Examples
^^^^^^^^^^^^^^

Scanning Logfiles with Sigma
****************************

Perform a scan with the Sigma rules on the different local Windows
Eventlogs (``-a Eventlog``)

.. code-block:: doscon

   C:\tools\thor>thor64.exe -a Eventlog

Perform a scan with the Sigma rules on logs of Linux systems (-a
LogScan) only

.. code-block:: doscon

   C:\tools\thor>thor64 -a Filesystem -p /var/log

Matching on Amcache with a custom Sigma rule
********************************************

.. code-block:: yaml

  title: Detecting execution of malicious hash via Amcache
  level: critical
  logsource:
    product: THOR
    service: AmCache entry
  detection:
    hash:
      SHA1: DEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF
    filter:
      PATH|endswith: \benign.exe
    detection: hash and not filter

