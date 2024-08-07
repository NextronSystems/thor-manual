
Use Cases
=========

This chapter contains use cases that users often asked for.

Disk Image Analysis
-------------------

.. hint:: 
  A lot of functions in this chapter require a **forensic lab**
  or **lab** license. This license is geared towards forensic
  experts. Forensic Lab Licenses are a special license type
  with more functionality.

THOR, as a scanner, does not mount disk images to a certain drive
on your forensic workstation. You have to use 3rd party tools for
that task. Please see :ref:`usage/use-cases:arsenal image mounter (aim)`
and :ref:`usage/use-cases:ftkimager` for Windows or :ref:`usage/use-cases:dissect`
for Linux to get an overview of potential tools to use. Other tools
should also work.

First, you mount the image to a certain drive/path with your preferred tool.
Afterwards you can use THOR in the lab scanning mode to analyze the
mounted image.

The following example shows a recommended set of parameters, scanning
a mounted image of a host named ``WKS0001`` on drive ``S:\`` of
your forensic Windows workstation. 

.. code-block:: doscon

  C:\thor>thor64.exe --lab --virtual-map S:C -j WKS0001 -p S:\

The following example shows the same parameters for a Linux forensic
workstation. The drive is mounted to ``/mnt/image/fs/sysvol/``.

.. code-block:: console

  nextron@unix:~/thor$ ./thor-linux-64 --lab --virtual-map /mnt/image/fs/sysvol/:C -j WKS0001 -p /mnt/image/fs/sysvol/ 

The ``--lab`` parameter will apply several internal flags (e.g. enables
intense mode to scan every file, enables multi-threading, disables
resource control, removes all limitations). The ``--virtual-map``
parameter maps every file found in elements of that image to the
original drive letter and allows the message enrichment to work
correctly. The ``-j HOSTNAME`` parameter can be used to write every
log line with the hostname of the original system and not with that
of the forensic workstation.

You find more information on the scan parameters in the chapter :ref:`usage/special-scan-modes:lab scanning`.

.. hint::
  This `blog post <https://thinkdfir.com/2021/06/03/you-want-me-to-deal-with-how-many-vmdks/>`__
  mentions different ways to use commercial or built-in tools to mount and scan VMDK images.

Arsenal Image Mounter (AIM)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

We recommend using `Arsenal Image Mounter <https://arsenalrecon.com/products/arsenal-image-mounter>`_.

In case you plan to use an automated setup in which you use scripts
to automatically process images, you could try to use the command-line
of AIM, please see the ``aim_cli.exe`` within the program folder for more help.

FTKImager
^^^^^^^^^

Alternatively, you can use the tool `FTKImager <https://www.exterro.com/digital-forensics-software/ftk-imager>`_
to mount your image.

.. note:: 
  We recommend using Arsenal Image Mounter to mount your images, since we observed better performance
  during our internal tests.

Dissect
^^^^^^^

Dissect is an incident response framework build from various parsers and implementations
of file formats. Tying this all together, Dissect allows you to work with tools named
``target-query`` and ``target-shell`` to quickly gain access to forensic artefacts,
such as Runkeys, Prefetch files, and Windows Event Logs, just to name a few!

You can find the tool here:
https://github.com/fox-it/dissect

For instructions on how to mount a disk image, you can find information here:
https://docs.dissect.tools/en/latest/tools/target-mount.html

Memory Image Analysis with Volatility
-------------------------------------

In this use case, we show a way to run a THOR scan on a full memory image
of a target system. 

In volatility, we first evaluate the right profile for a memory image.
You can use the ``imageinfo`` command or select one manually from the
list that is show when you run ``vol.py --info``.

.. code-block:: console

    user@linux:~$ vol.py -f win10-lab1.mem imageinfo

    Volatility Foundation Volatility Framework 2.6.1
    INFO     : volatility.debug    : Determining profile based on KDBG search...
              Suggested Profile(s) : Win10x64_19041
                         AS Layer1 : SkipDuplicatesAMD64PagedMemory (Kernel AS)
                         AS Layer2 : FileAddressSpace (/mnt/downloads/mem-dumps/win10-lab1.mem)
                          PAE type : No PAE
                               DTB : 0x1aa002L
                              KDBG : 0xf8005aa00b20L
              Number of Processors : 2
         Image Type (Service Pack) : 0
                    KPCR for CPU 0 : 0xfffff80055ec0000L
                    KPCR for CPU 1 : 0xffff8500313c0000L
                 KUSER_SHARED_DATA : 0xfffff78000000000L
               Image date and time : 2021-06-15 08:25:08 UTC+0000
         Image local date and time : 2021-06-15 10:25:08 +0200
    
We then create a directory that will store all our process memory images. 

.. code-block:: console

    user@linux:~$ mkdir procs

Now we can extract all process memory images and save them to the new directory. 

.. code-block:: console

    user@linux:~$ vol.py -f win10-lab1.mem --profile=Win10x64_19041 memdump -D procs/

    Volatility Foundation Volatility Framework 2.6.1
    ************************************************************************
    Writing System [     4] to 4.dmp
    ************************************************************************
    Writing Registry [    92] to 92.dmp
    ************************************************************************
    Writing smss.exe [   348] to 348.dmp
    ************************************************************************
    Writing csrss.exe [   440] to 440.dmp
    ************************************************************************
    Writing wininit.exe [   512] to 512.dmp
    ************************************************************************
    Writing csrss.exe [   520] to 520.dmp
    ************************************************************************
    Writing winlogon.exe [   608] to 608.dmp
    ************************************************************************
    Writing services.exe [   624] to 624.dmp
    ************************************************************************
    Writing lsass.exe [   656] to 656.dmp
    ************************************************************************
    Writing fontdrvhost.ex [   748] to 748.dmp

We recommend saving that output for mapping purposes, since THOR will only
report the file names upon a YARA rule match, e.g. ``748.dmp``, and not
the name of the executable ``fontdrvhost.exe``.

Using THOR, we can now scan the extracted process memory images.

.. code-block:: console 

    user@linux:~$ ./thor-linux-64 --lab -p /mnt/mem-dumps/procs/

Without a valid lab license, we can simulate that behaviour using the
following command (see :ref:`usage/special-scan-modes:lab scanning`
for more details and flags used in lab scan mode):

.. code-block:: console

    user@linux:~$ ./thor-linux-64 -a Filescan --intense -p /mnt/mem-dumps/procs/

The output of such a scan will look like this 

.. code-block:: none

    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 286 MB
    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 343 MB
    Alert YARA Score Rule Match
      TARGET: /mnt/mem-dumps/procs/3812.dmp
      TYPE: file
      NAME: SUSP_Encoded_UA_Mozilla
      SCORE: 50
      DESCRIPTION: Detects encoded keyword - User-Agent: Mozilla/
      SIGTYPE: internal
      CHUNK_OFFSET: 366000000
      TAGS: SUSP, T1027
      MATCHING_STRINGS: Str1: "VzZXItQWdlbnQ6IE1vemlsbGEv" in "dDBRMD0NClVzZXItQWdlbnQ6IE1vemlsbGEvNS4wIChjb2" at 0x1672eacc
      MODIFIED: Tue Jun 15 11:38:13 2021
      CHANGED: Tue Jun 15 11:38:13 2021
      TARGET_SIZE: 610324480
    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 400 MB
    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 457 MB

The match includes an offset, e.g. ``CHUNK_OFFSET: 366000000``, and a
matching string, e.g. ``Str1: "VzZXItQWdlbnQ6IE1vemlsbGEv"`` which help
you to locate the correct section in the dump file using a hex editor
for further analysis.

Scanning a Fileserver
---------------------

The recommendation for scanning a fileserver is running THOR directly on the
system. If that is not possible, because the operating system of the fileserver
is not supported by THOR, we recommend a dedicated system to perform a filescan
on the shares. The system should have at least 2 CPU cores and 2 GB of RAM.

The recommended flags to run THOR are:

.. code-block:: doscon

   C:\temp\thor>thor64.exe --module Filescan --alldrives --path X: --path Y: --path Z:

.. note:: 
    The ``--alldrives`` flag is only available with a lab license

If needed or desired, the scan can be adapted using the following flags.
In general, the following options are not recommended but can help in special scenarios.

* ``--resume``

  * If a previous scan failed (e.g. because of a exceeded max. runtime)
    the scan can be resumed, if the same flags (and additional the resume
    flag) are used to start the scan.

* ``--max_runtime 0``

  * Default is 7 days. Change this value if your scans need more time.

* ``--path \\fileserver01\shareA``

  * If permissions allow anonymous access, the shares can be accessed
    using the UNC path and do not need to be mounted.

* ``--nosoft``

  * If your scanning system has too little system resources, the softmode
    is automatically enabled. This flag prevents that.

* ``--lookback 8 --global-lookback``

  * Only scans files that were modified within the last 8 days. Apply Lookback to all modules that support it (not only Eventlog). Faster scan
    time but vulnerable to timestomping attacks.

* ``--diff``

  * Only scans new files or files that were modified since the last scan.
    Faster scan time but vulnerable to timestomping attacks. THOR DB is
    needed for diff, so cannot be used in combination with ``--nothordb``.

* ``--max_file_size ?????``
 
  * Maximum file size In bytes. The default is 20 MB. If you need to scan bigger files,
    you might need to increase the maximum file size.

* ``--no<feature>``

  * Disable features like scanning eventlog files (``--noevtx``), if your share contains
    files that trigger special feature checks of THOR, that are not desired. Please see
    :ref:`usage/scan-modes:scan module names` and :ref:`usage/scan-modes:feature names`
    for a list of module/feature names and the respective command line argument to disable
    them.

* ``--allfiles``

  * Scan all files, independent of file extensions or magic headers.
    Use ``--max_file_size_intense`` instead of ``--max_file_size``. (Caution: This will
    increase the scan time drastically!)

If the share is not accessible anonymously, you need to mount the shares using valid
user credentials. This has to be done before the scan and access granted to the user running the THOR scan.
If you use ASGARD to launch THOR the user performing the scan is ``NT AUTHORITY\SYSTEM``.

The usage of diff and lookback are generally not recommended, but can be used if your fileshare scan does not finish in the timeframe you desire.
Another option is to use multiple dedicated systems to run scans on the fileserver shares in parallel.

