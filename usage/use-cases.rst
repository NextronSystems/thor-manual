
Use Cases
=========

This chapter contains use cases that users often asked for.

Disk Image Analysis with FTKImager
----------------------------------

THOR, as a scanner, does not mount disk images to a certain driver on your forensic workstation. You have to use 3rd party tools for that task. We recommend using `FTKImager <https://accessdata.com/product-download#digital-forever>`__.

In case you plan to use an automated setup in which you use scripts to automatically process images, you could try to use the old `command line versions of FTKimager <https://accessdata.com/product-download#past-versions>`__.

So, first you mount the image to a certain drive and then use THOR in lab scanning mode to analyze the mounted image. To benefit from all features of this mode, you have to acquire and use a so-called **forensic lab** or **lab** license.

The following example shows a recommended set of parameters, scanning a mounted image of a host named ``WKS0001`` on drive ``S:\`` of your forensic Windows workstation. 

.. code:: batch

    thor64.exe --lab --virtual-map S:C -j WKS0001 -p S:\

The ``--lab`` parameter will apply several internal flags (e.g. enables intense mode scanning every file, enables multi-threading, disables resource control, removes all limitations). The ``--virtual-map`` parameter maps every file found in elements of that image to the original drive letter and allows the message enrichment to work correctly. The ``-j HOSTNAME`` parameter can be used to write every log line with the hostname of the original system and not with that of the forensic workstation.

You find more information on the scan parameters in the chapter :doc:`Special Scan Modes <./special-scan-modes>`.

This `blog post <https://thinkdfir.com/2021/06/03/you-want-me-to-deal-with-how-many-vmdks/>`__ mentions different ways to use commercial or built-in tools to mount and scan VMDK images. 

Memory Image Analysis with Volatility
-------------------------------------

In this use case, we show a way to run a THOR scan on a full memory image of a target system. 

In volatility, we first evaluate the right profile for a memory image. You can use the ``imageinfo`` command or select one manually from the list that is show when you run ``vol.py --info``.

.. code:: sh

    vol.py -f win10-lab1.mem imageinfo

    Volatility Foundation Volatility Framework 2.6.1
    INFO    : volatility.debug    : Determining profile based on KDBG search...
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

.. code:: sh

    mkdir procs

Now we can extract all process memory images and save them to the new directory. 

.. code:: sh

    vol.py -f win10-lab1.mem --profile=Win10x64_19041 memdump -D procs/

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

We recommend saving that output for mapping purposes, since THOR will only report the file names upon a YARA rule match, e.g. ``748.dmp``, and not the name of the executable ``fontdrvhost.exe``.

Using THOR we can now scan the extracted process memory images.

.. code:: sh 

    ./thor-linux-64 ---lab -p /mnt/mem-dumps/procs/

Without a valid lab license, we can simulate that behaviour using the following command (see :doc:`chapter Special Scan Modes <./special-scan-modes>` for more details and flags used in lab scan mode):

.. code:: sh 

    ./thor-linux-64 -a Filescan --intense -p /mnt/mem-dumps/procs/

The output of such a scan will look like this 

.. code-block:: sh

    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 286 MB
    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 343 MB
    Alert YARA Score Rule Match TARGET: /mnt/mem-dumps/procs/3812.dmp TYPE: file NAME: SUSP_Encoded_UA_Mozilla SCORE: 50 DESCRIPTION: Detects encoded keyword - User-Agent: Mozilla/ SIGTYPE: internal CHUNK_OFFSET: 366000000 TAGS: SUSP, T1027 MATCHING_STRINGS: Str1: "VzZXItQWdlbnQ6IE1vemlsbGEv" in "dDBRMD0NClVzZXItQWdlbnQ6IE1vemlsbGEvNS4wIChjb2" at 0x1672eacc MODIFIED: Tue Jun 15 11:38:13 2021 CHANGED: Tue Jun 15 11:38:13 2021 TARGET_SIZE: 610324480
    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 400 MB
    [?%] Worker 01: /mnt/mem-dumps/procs/3812.dmp          [_______________________________]Progress: 457 MB

The match includes an offset, e.g. ``CHUNK_OFFSET: 366000000``, and a matching string, e.g. ``Str1: "VzZXItQWdlbnQ6IE1vemlsbGEv"`` which help you to locate the correct section in the dump file using a hex editor for further analysis.
