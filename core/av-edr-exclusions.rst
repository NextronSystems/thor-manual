.. Index:: Antivirus & EDR Exclusions

Antivirus & EDR Exclusion
-------------------------

Since THOR accesses different process memories and probes for malicious
Mutex, Named Pipes and Event values, it is recommended to exclude THOR
from Antivirus / EDR scanning.

The Antivirus exclusion could also lead to a significant runtime
reduction, since access to processes memory and files will not get
intercepted anymore.

.. note::
   We have seen massive runtime changes with Windows Defender since April 2021 (+50-100%).
   It is highly recommended to exclude THOR from scanning when using Windows Defender.

The quickest way to add an exclusion on a single system is with the following command
(change the path in ``-ExclusionProcess`` accordingly).

Windows command line:

.. code-block:: doscon

   C:\Users\nextron>powershell -ep bypass -Command "Add-MpPreference -ExclusionProcess 'c:\temp\thor\thor64.exe'"

PowerShell:

.. code-block:: ps1con

   PS C:\Users\nextron>Add-MpPreference -ExclusionProcess 'c:\temp\thor\thor64.exe'

For more information, visit `https://docs.microsoft.com <https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-process-opened-file-exclusions-microsoft-defender-antivirus?view=o365-worldwide>`__.

A Note on SentinelOne
^^^^^^^^^^^^^^^^^^^^^

The process memory of systems running SentinelOne is polluted with suspicious strings.
The most prevalent false positive is related to the keyword "ReflectiveLoader",
but any other rule can match as well.

It is unclear what SentinelOne does to the process memory of many system processes.
We cannot exclude these signatures from the scan. Be aware that the results from
the "ProcessCheck" module on a system running SentinelOne can contain many false positives.

A Note on McAfee
^^^^^^^^^^^^^^^^

It is not an easy task to define exclusions for THOR in all the different services
when running McAfee products. You have to exclude the process in different sections
(AV, EDR, On-Access). We've compiled a list of exclusions for our ASGARD customers,
which you can find `here <https://asgard-manual.nextron-systems.com/en/latest/requirements/av_edr.html#mcafee-edr-exclusions>`__.
