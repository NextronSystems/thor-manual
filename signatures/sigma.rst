.. Index:: Sigma Rules

Sigma Rules
===========

Sigma is a generic rule format for detections on structured data. Sigma is for
log data, what Snort is for network packets and YARA is for files.

THOR ships with the public Sigma rule set, which
is maintained by the community at `<https://github.com/SigmaHQ/sigma>`_,
as well as additional Nextron internal rules.

THOR applies Sigma rules to all objects it encounters. This is most relevant
for Windows Eventlogs and log files on disk (``.log``).

By default only the results of Sigma rules of level critical and high are shown.
If called with the ``--deep`` flag, medium level rules are applied as well.

Custom Sigma rules must have the ``.yml`` extension for unencrypted sigma rules
and the ``.yms`` extension for encrypted sigma rules.

.. figure:: ../images/image31.png
   :alt: Example Sigma match on Windows Eventlog

   Example Sigma match on Windows Eventlog

Scores
^^^^^^

The :ref:`score<signatures/scores:Scoring>` of a Sigma match is based on the Sigma rule's level:

 - Level low translates to score 40
 - Level medium translates to score 50
 - Level high translates to score 70
 - Level critical translates to score 100

Sigma matching on THOR output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sigma rules can also be written to match on THOR content.
These rules need to have a log source with `product: THOR`
and `service: object-type`.

The available object types that can be matched on can be listed with
``--describe-object-type all``. All objects of a specific type can also be
printed by using ``--log-object specificobjecttype``. This can be helpful
to determine available fields for matching.

Writing Custom Sigma Rules for THOR Object Types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

THOR v11 allows you to write Sigma rules that match on **any object type** THOR produces,
not just Windows Event Logs. This means you can detect suspicious processes, persistence
mechanisms, fileless malware, and much more using the open Sigma standard.

This feature is available in both **THOR** and **THOR Lite**.

Discovering Object Types
************************

Use these command-line flags to explore available object types:

.. list-table::
   :header-rows: 1
   :widths: 40, 60

   * - Flag
     - Purpose
   * - ``--describe-object-type all``
     - List all object types with their JSON schemas
   * - ``--describe-object-type "<type>"``
     - View schema for a specific object type
   * - ``--log-object "<type>"``
     - Log all objects of a type during a scan
   * - ``--log-object "<type>:<limit>"``
     - Log objects with a limit (e.g., ``"process:50"``)

Example: View the process object schema:

.. code-block:: console

   $ ./thor-linux-64 --describe-object-type "process"

Example: Log process objects during a scan:

.. code-block:: console

   $ ./thor-linux-64 --module ProcessCheck --log-object "process:10"

Object Type Reference
*********************

THOR includes 90 object types. Here are the most commonly used for detection rules:

**Process and Memory:**
   ``process``, ``process connection``, ``process handle``, ``thread``

**Persistence Mechanisms:**
   ``autorun entry``, ``cron job``, ``scheduled task``, ``at job``,
   ``Windows service``, ``systemd service``, ``init.d service``,
   ``WMI startup command``

**File System Artifacts:**
   ``file``, ``MFT entry``, ``jump list entry``, ``prefetch info``,
   ``shim cache entry``

**Registry:**
   ``registry key``, ``registry value``

**Users and Authentication:**
   ``Windows user``, ``Unix user``, ``authorized_keys entry``,
   ``logged in user``, ``LSA session``

**Network:**
   ``DNS cache entry``, ``firewall rule``, ``hosts file entry``,
   ``network session``, ``network share``

**Security and Kernel:**
   ``Linux kernel module``, ``eBPF program``, ``mutex``, ``named pipe``,
   ``antivirus exclusion``

**Logs and Events:**
   ``eventlog entry``, ``log line``, ``journal log entry``, ``audit log entry``

**Execution History:**
   ``AmCache entry``, ``shim cache``, ``web page visit``, ``web download``

Logsource Format
****************

To target a THOR object type, use this logsource configuration:

.. code-block:: yaml

   logsource:
       product: THOR
       service: <Object Type Name>

The ``service`` field must match the object type name exactly (e.g., ``Linux kernel module``,
``AmCache entry``, ``cron job``).

Field Naming Convention
***********************

Fields from the JSON schema are converted to **UPPERCASE** in Sigma rules:

.. list-table::
   :header-rows: 1
   :widths: 50, 50

   * - JSON Schema Field
     - Sigma Field
   * - ``included_in_kernel``
     - ``INCLUDED_IN_KERNEL``
   * - ``command``
     - ``COMMAND``
   * - ``service_name``
     - ``SERVICE_NAME``

To match null/empty fields:

.. code-block:: yaml

   detection:
       selection:
           FILE: null

Detection Examples
******************

**Example 1: Execution of Known Malicious Hash via Amcache**

.. code-block:: yaml

   title: Execution of Known Malicious Hash via Amcache
   level: critical
   logsource:
       product: THOR
       service: AmCache entry
   detection:
       selection:
           SHA1: DEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF
       filter:
           PATH|endswith: \benign.exe
       condition: selection and not filter
   falsepositives:
       - Known good files matching the hash
   level: critical

**Example 2: Linux Kernel Module Without File (Rootkit Detection)**

.. code-block:: yaml

   title: Kernel Module Without File
   status: experimental
   description: Detects dynamically loaded kernel modules without associated files
   logsource:
       product: THOR
       service: Linux kernel module
   detection:
       selection:
           FILE: null
           INCLUDED_IN_KERNEL: false
       condition: selection
   falsepositives:
       - Custom kernels with manually loaded modules
   level: medium

**Example 3: Suspicious Process with Encoded PowerShell**

.. code-block:: yaml

   title: Process with Encoded PowerShell Execution
   logsource:
       product: THOR
       service: process
   detection:
       selection:
           COMMAND|contains:
               - ' -enc '
               - ' -EncodedCommand '
           NAME|endswith:
               - 'powershell.exe'
               - 'pwsh.exe'
       condition: selection
   level: high

**Example 4: Suspicious Cron Job (Linux Persistence)**

.. code-block:: yaml

   title: Cron Job with Suspicious Download Command
   logsource:
       product: THOR
       service: cron job
   detection:
       selection_download:
           COMMAND|contains:
               - 'wget '
               - 'curl '
       selection_pipe:
           COMMAND|contains:
               - '| bash'
               - '| sh'
       condition: selection_download and selection_pipe
   level: medium

**Example 5: Autorun Entry from Suspicious Location**

.. code-block:: yaml

   title: Autorun Entry from Suspicious Location
   logsource:
       product: THOR
       service: autorun entry
   detection:
       selection_path:
           LAUNCH_STRING|contains:
               - '\AppData\Roaming\'
               - '\Users\Public\'
               - '\Temp\'
       selection_script:
           LAUNCH_STRING|contains:
               - '.vbs'
               - '.hta'
               - 'powershell'
       condition: selection_path and selection_script
   level: high

**Example 6: Windows Service with Suspicious Binary Path**

.. code-block:: yaml

   title: Windows Service from Temp Directory
   logsource:
       product: THOR
       service: Windows service
   detection:
       selection:
           IMAGE|contains:
               - '\Temp\'
               - '\Users\Public\'
               - '\AppData\'
       condition: selection
   level: high

Scanning Logfiles with Sigma
****************************

Perform a scan with the Sigma rules on the different local Windows
Eventlogs (``-a Eventlog``):

.. code-block:: doscon

   C:\thor>thor64.exe -a Eventlog

Perform a scan with the Sigma rules on logs of Linux systems:

.. code-block:: console

   $ ./thor-linux-64 -a Filescan -p /var/log

Deploying Custom Sigma Rules
****************************

1. Save your rule as a ``.yml`` file
2. Copy to the THOR custom signatures folder:

   .. code-block:: console

      $ cp my-rule.yml /path/to/thor/custom-signatures/sigma/

3. For encrypted rules, use the ``.yms`` extension
4. Verify rules loaded with ``--list-signatures``:

   .. code-block:: console

      $ ./thor-linux-64 --list-signatures | grep "my-rule"

Testing Your Rules
******************

Examine real objects before writing rules:

.. code-block:: console

   $ ./thor-linux-64 --module ProcessCheck --log-object "process:10" --console-json

Adjust the Sigma threshold to see lower-level matches:

.. code-block:: console

   $ ./thor-linux-64 --sigma-threshold medium

Quick Reference
***************

.. list-table::
   :header-rows: 1
   :widths: 25, 25, 50

   * - Use Case
     - Object Type
     - Key Fields
   * - Process monitoring
     - ``process``
     - COMMAND, NAME, OWNER, PID
   * - Linux persistence
     - ``cron job``
     - COMMAND, USER, SCHEDULE
   * - Windows persistence
     - ``scheduled task``
     - COMMANDS, USER, RUN_LEVEL
   * - Autoruns
     - ``autorun entry``
     - LAUNCH_STRING, LOCATION
   * - Services (Windows)
     - ``Windows service``
     - SERVICE_NAME, IMAGE
   * - Services (Linux)
     - ``systemd service``
     - COMMAND, RUN_AS_USER
   * - Kernel rootkits
     - ``Linux kernel module``
     - FILE, INCLUDED_IN_KERNEL
   * - File hashes
     - ``file``
     - MD5, SHA1, SHA256, PATH
   * - Execution history
     - ``AmCache entry``
     - SHA1, PATH, PRODUCT
