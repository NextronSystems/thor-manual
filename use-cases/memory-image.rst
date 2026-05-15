.. Index:: Memory Image Analysis

Memory Image Analysis with Volatility
=====================================

This use case shows one way to run a THOR scan on a full memory image
of a target system.

In Volatility, the first step is to determine the correct profile for
the memory image. You can use the ``imageinfo`` command or select one
manually from the list shown by ``vol.py --info``.

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
    
Next, create a directory that will store the extracted process memory
images.

.. code-block:: console

    user@linux:~$ mkdir procs

You can then extract all process memory images and save them to the new
directory.

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

We recommend saving this output for mapping purposes, because THOR
reports only the dump file name on a YARA match, for example
``748.dmp``, and not the original executable name such as
``fontdrvhost.exe``.

You can now scan the extracted process memory images with THOR.

.. code-block:: console 

    user@linux:~$ ./thor-linux-64 --lab -p /mnt/mem-dumps/procs/

Without a valid lab license, you can simulate this behavior with the
following command. See
:ref:`scanning/special-scan-modes:lab scanning` for more details about
lab scan mode and the flags it enables.

.. code-block:: console

    user@linux:~$ ./thor-linux-64 -a Filescan --deep -p /mnt/mem-dumps/procs/

The output of such a scan looks similar to the following example:

.. code-block:: none

    Info Scanning /tmp/tmp.pxOragOcjV/powershell.DMP RECURSIVE
    Info Scanning target (default mode) TARGET: /tmp/tmp.pxOragOcjV/powershell.DMP TYPE: file
    Notice Notable file chunk found CHUNK_OFFSET: 0x600000 CHUNK_END: 0x1200000 SCORE: 50
    REASON_1: YARA rule SUSP_Encoded_UA_Mozilla / Detects encoded keyword - User-Agent: Mozilla/ SUBSCORE_1: 50 REF_1: Internal Research - Permutator SIGTYPE_1: internal
    SIGCLASS_1: YARA Rule RULEDATE_1: 2025-06-02 TAGS_1: SUSP, T1027 RULENAME_1: SUSP_Encoded_UA_Mozilla DESCRIPTION_1: Detects encoded keyword - User-Agent: Mozilla/
    AUTHOR_1: Florian Roth ID_1:
    MATCHED_1: VzZXItQWdlbnQ6IE1vemlsbGEv in "\x00\x00\x00\x00\x00V\x00z\x00Z\x00X\x00I\x00t\x00Q\x00W\x00d\x00l\x00b\x00n\x00Q\x006\x00I\x00E\x001\x00v\x00e\x00m\x00l\x00s\x00b\x00G\x00E\x00v\x00\x0d\x00\x0a\x00" at 0xace2a2 in CONTENT
    REASONS_COUNT: 1
    ORIGIN_FILE: /tmp/tmp.pxOragOcjV/powershell.DMP ORIGIN_EXTENSION: .DMP ORIGIN_TYPE: MDMP ORIGIN_MODIFIED: Mon Oct  6 14:22:37.349 2025
    ORIGIN_ACCESSED: Mon Oct  6 14:22:35.775 2025 ORIGIN_CHANGED: Mon Oct  6 14:22:37.349 2025
    ORIGIN_CREATED: Mon Oct  6 14:22:35.775 2025
    ORIGIN_SIZE: 248972314 ORIGIN_OWNER: max ORIGIN_GROUP: max ORIGIN_PERMISSIONS: rw-------

The match includes an offset, for example
``CHUNK_OFFSET: 0x600000``, and a matching string, for example
``MATCHED_1: VzZXItQWdlbnQ6IE1vemlsbGEv``. These values help you locate
the relevant section in the dump file with a hex editor for further
analysis.
