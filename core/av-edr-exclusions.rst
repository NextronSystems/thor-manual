.. Index:: Antivirus & EDR Exclusions

Antivirus & EDR Exclusions
==========================

Because THOR accesses process memory and probes for suspicious mutexes,
named pipes, and event values, we recommend excluding THOR from
antivirus and EDR scanning.

Adding such exclusions can also significantly reduce runtime, because
access to process memory and files is no longer intercepted.

.. note::
   We have seen major runtime increases with Windows Defender since
   April 2021 (+50-100%). When using Windows Defender, we strongly
   recommend excluding THOR from scanning.

The quickest way to add an exclusion on a single system is to use the
following command. Adjust the path in ``-ExclusionProcess`` as needed.

Windows command line:

.. code-block:: doscon

   C:\Users\nextron>powershell -ep bypass -Command "Add-MpPreference -ExclusionProcess 'c:\temp\thor\thor64.exe'"

PowerShell:

.. code-block:: ps1con

   PS C:\Users\nextron>Add-MpPreference -ExclusionProcess 'c:\temp\thor\thor64.exe'

For more information, see
`the Microsoft documentation <https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-process-opened-file-exclusions-microsoft-defender-antivirus?view=o365-worldwide>`__.

A Note on SentinelOne
^^^^^^^^^^^^^^^^^^^^^

On systems running SentinelOne, process memory may contain suspicious
strings introduced by the product itself. The most common false positive
is related to the keyword ``ReflectiveLoader``, but other rules may also
match.

It is unclear how SentinelOne modifies the memory of many system
processes. We cannot generally exclude these signatures from the scan.
Be aware that results from the ``ProcessCheck`` module on a system
running SentinelOne may contain many false positives.

McAfee EDR Exclusions
^^^^^^^^^^^^^^^^^^^^^

McAfee requires exclusions in multiple locations. In addition to the
general recommendation, customers with McAfee EDR need to set the following
exclusions.

McAfee On-Access Scan
"""""""""""""""""""""

.. list-table::
  :header-rows: 1
  :stub-columns: 1
  :widths: 25, 75

  * -
    - McAfee On-Access Scan Exclusions
  * - **Low Risk**
    - thor.exe
  * -
    - thor64.exe
  * - Access Protection
    - thor.exe
  * -
    - thor64.exe
