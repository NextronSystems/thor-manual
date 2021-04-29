
Preparations
============

Add License File
----------------

Files that you have to place in the program folder:

* | THOR License File (\*.lic)
  | THOR checks the program folder and all sub folder for valid license
     files. You can specify a certain path with **--licensepath path**.
     See chapter 11 "License Files" for details.

Add Tools (optional)
--------------------

The EULA of the SysInternals tool “Handle” doesn’t allow us to ship the
tool with scanner package. You can download this tool, accept their EULA
and place it into the **./tools** sub folder to improve the scan
results.

This tool is still required due to limitations in the Golang standard
lib. We’ll remove this dependency in future versions.

Handle: https://docs.microsoft.com/en-us/sysinternals/downloads/handle

Verify Signatures (optional)
----------------------------

You can verify the executable files in the THOR package via:

* Their digital signature - issued by "Nextron Systems GmbH"
* thor-util’s “verify” feature
* This hash list https://www.nextron-systems.com/download/hashsums.txt

Consider Antivirus / EDR Exclusions
-----------------------------------

Since THOR accesses different process memories and probes for malicious
Mutex, Named Pipe and Event values, it is recommended to exclude THOR
from Antivirus / EDR scanning.

The Antivirus exclusion could also lead to a significant runtime
reduction, since access to processes memory and files does not get
intercepted anymore.
