.. Index:: Memory Image Analysis

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
following command (see :ref:`scanning/special-scan-modes:lab scanning`
for more details and flags used in lab scan mode):

.. code-block:: console

    user@linux:~$ ./thor-linux-64 -a Filescan --deep -p /mnt/mem-dumps/procs/

The output of such a scan will look like this 

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

The match includes an offset, e.g. ``CHUNK_OFFSET: 0x600000``, and a
matching string, e.g. ``MATCHED_1: VzZXItQWdlbnQ6IE1vemlsbGEv`` which help
you to locate the correct section in the dump file using a hex editor
for further analysis.
