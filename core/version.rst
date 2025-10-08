.. Index:: Which version to use

Which version to use?
=====================

The different THOR versions offered can be a bit confusing in the beginning.
To avoid more confusion down the line, you should read the below information.

Which THOR Variant?
-------------------

We offer THOR in different variants.

* :ref:`core/version:thor`
* :ref:`core/version:thor techpreview`
* :ref:`core/version:thor legacy` (limited support and compatibility)

.. figure:: ../images/techpreview.png
   :alt: THOR Default and TechPreview Differences

   THOR Default and TechPreview Focus

THOR
^^^^

The default version of THOR is the most stable version, intensively tested and
without any broadly tested performance and detection tweaks.

The default version should be used for:

* Scan sweeps on hundreds or thousands of systems
* Continuous compromise assessments on hundreds or thousands of systems
* Systems with high requirements on stability

THOR TechPreview
^^^^^^^^^^^^^^^^

The TechPreview version is focused on detection and speed. This
`blog post <https://www.nextron-systems.com/2020/08/31/introduction-thor-techpreview/>`__
contains more information on the differences.

The TechPreview version should be used for:

* Digital forensic lab scanning
* Dropzone mode scanning
* Image scanning
* THOR Thunderstorm setups
* Single system live forensics on systems that don't have the highest priority on stability

You can find the information on how to get the TechPreview version in
the `THOR Util manual <https://thor-util-manual.nextron-systems.com/en/latest/usage/download-packages.html#thor-techpreview-version>`__.

THOR Legacy
^^^^^^^^^^^

THOR Legacy is a stripped-down version that includes all modules that can be used
on outdated operating systems. This
`blog post <https://www.nextron-systems.com/2020/12/17/thor-10-legacy-for-windows-xp-and-windows-2003/>`__
contains more information on the legacy version.

The legacy version lacks:

* Diagnostic features of THOR Util
* UPX unpacking
* ADS scanning
* Module: Process scanning
* Module: Eventlog scanning
* Module: THOR Thunderstorm
* Module: ETW Watcher
* Module: Task scheduler
* HTML report generation

.. note::
   We only offer limited support for this version, since we cannot guarantee a successful
   stable scan on platforms that have already been deprecated.

To use THOR Legacy, you need a special license. Contact sales to get more information regarding
Legacy licenses.

To download THOR Legacy, you can either download it directly from
our portal (recommended; continue at step 5), or follow these steps:

1. Download a normal THOR package (non-legacy)
2. Use thor-util to download THOR Legacy:

   ``thor-util.exe download --legacy -t thor10-win``

3. You will get a zip file with the following name:

   ``thor-win-10.6.20_<date>-<time>.zip``

4. The content of this zip file should be as follows:

   .. figure:: ../images/thor_legacy_content.png
      :alt: THOR Legacy content

5. You can now transfer this package to your Legacy system. Please do an upgrade
   before you start using this:

   ``thor-legacy-util.exe upgrade``

   ``thor-legacy-util.exe update``

6. Place your Legacy license inside this folder and start using THOR Legacy

Which Architecture?
-------------------

You will find a 32 and 64-bit version of the executable in the program folder. Never run
the 32-bit version of THOR named ``thor.exe`` on a 64-bit system. The 32-bit version has some
limitations that the 64-bit version doesn't have (memory usage, sees different folders
on disk and registry versions).

Make sure to run the correct binary for your target architecture.

What Command Line Flags?
------------------------

THOR was built to be production ready. That means 99% of the time you
do not need to specify any extra flags. Our recommended way to use THOR
is **without any additional command line flags**.

However, special circumstances can lead to different requirements and
thus a different set of command line flags. See chapter
:ref:`scanning/using-thor:using thor` for often used flags.

