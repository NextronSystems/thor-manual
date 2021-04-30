
Before You Start
================

Add License File
----------------

Place a valid license file into the program folder:

* | THOR License File (\*.lic)
  | THOR checks the program folder and all sub folder for valid license
     files. You can specify a certain path with **--licensepath path**.
     See chapter 11 "License Files" for details.

About License Files
^^^^^^^^^^^^^^^^^^^

THOR processes the program folder and all sub folders in search for a
valid license file with a "**\*.lic**" extension and picks the first
valid license he can find.

This change has been made to facilitate the rollout using the new host
based license model.

You can now generate licenses for a big set of systems, store all the
licenses as "**thor-system1.lic**", "**this-system2.lic**" and so on in
a sub folder "**./licenses**" and transfer the THOR program folder with
the "licenses" sub folder to all the different system for which you have
generated licenses and just run the "**thor.exe**" executable.
     

Upgrade THOR and Update The Signatures 
--------------------------------------

Run the following command to update THOR and its signatures: 

.. code:: batch 
   
   thor-util upgrade

It is **important** that you update THOR after a download from the csutomer 
portal since the packages do not contain the newest signature files. 
(caused by internal integrity check processes)

Note: The upgrade requires a valid license for the host that performs the update. 
If you don't want to use a license for that host, ask us for a **silent license** 
that can be used for all kinds of tersting purposes and also allows to update THOR
and its signatures.  

Antivirus / EDR Exclusions
--------------------------

Since THOR accesses different process memories and probes for malicious
Mutex, Named Pipe and Event values, it is recommended to exclude THOR
from Antivirus / EDR scanning.

The Antivirus exclusion could also lead to a significant runtime
reduction, since access to processes memory and files does not get
intercepted anymore.

Note: We see massive runtime changes with Windows Defender since April 2021 (+50-100%). 
It is highly recommended to exclude THOR from scanning when using Windows Defender. 

The quickest way to add an exclusion on a single system is:

Windows command line:

.. code:: batch 

   powershell -ep bypass -Command "Add-MpPreference -ExclusionProcess 'c:\temp\thor\thor64.exe'"

PowerShell:

.. code:: powershell 

   Add-MpPreference -ExclusionProcess 'c:\temp\thor\thor64.exe'

For more information visit `this link <https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-process-opened-file-exclusions-microsoft-defender-antivirus?view=o365-worldwide>`__. 

Choose The Right THOR Variant 
-----------------------------

We offer THOR in different variants. 

* THOR 
* THOR TechPreview
* THOR Legacy (limited support, availability)

.. figure:: ../images/techpreview.png
   :target: ../_images/techpreview.png
   :alt: THOR Default and TechPreview Differences

   THOR Default and TechPreview Focus

THOR
^^^^

The default version of THOR is the most stable version, intensively tested and without any broadly tested performance and detection tweaks.

The default version should be used for: 

* Scan sweeps on many hundreds or thousands of systems
* Continous compromise assessments on hundreds or thousands of systems 
* Systems with high requirements on stability

THOR TechPreview 
^^^^^^^^^^^^^^^^

The TechPreview version is focussed on detection and speed. This `blog post <https://www.nextron-systems.com/2020/08/31/introduction-thor-techpreview/>`__ contains more information on the differences. 

The TechPreview version should be used for: 

* Digital forensic lab scanning
* Dropzone mode scanning 
* Image scanning 
* THOR Thunderstorm setups
* Single system live forensics on systems that don't have highest priority on stability 

THOR Legacy 
^^^^^^^^^^^

THOR Legacy is a stripped down version that includes all modules that can be used on outdated operating systems. This `blog post <https://www.nextron-systems.com/2020/12/17/thor-10-legacy-for-windows-xp-and-windows-2003/>`__ contains more information on the legacy version.

The legacy version lacks: 

* Module: Eventlog scanning 
* Feature: Deeper process inspection (process hollowing, doppelgänging, etc.)

The legacy version is not offered in our customer portal. We share it with our customers on request. 

We only offer limited support for this version, since we cannot guarantee a successful stable scan on platforms that have already been deprecated.

Verify Signatures (optional)
----------------------------

You can verify the executable files in the THOR package via:

* Their digital signature - issued by "Nextron Systems GmbH"
* thor-util’s “verify” feature

Find more information on THOR Util in its dedicated `online manual <https://thor-util-manual.nextron-systems.com>`__. 

Note: THOR Util automatically verifies the signatures of the contained 
binaries in an update package and exits if one or more signatures cannot
be verified. You don't have to check them manually unless you distrust 
the THOR Util itself. In this case, you can use the public key published
on our web page.
