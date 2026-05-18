.. Index:: Missing Alerts

Most Frequent Causes of Missing Alerts
--------------------------------------

Below are some of the most common reasons why expected alerts may be
missing.

THOR did not scan a file because of file size restrictions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Solution**: Use the ``--file-size-limit`` parameter or set it permanently
in the config file ``./config/thor.yml``.

.. code-block:: doscon

   C:\thor>thor64.exe --file-size-limit 100MB

.. literalinclude:: ../examples/thor.yaml
   :caption: Default thor.yaml
   :language: yaml
   :linenos:
   :emphasize-lines: 3

THOR did not scan a file because deeper inspection was skipped
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This usually happens when both of the following are true:

* The file's magic header is not in the list of interesting magic
  headers (see ``./signatures/misc/file-type-signatures.cfg``).
* The file does not have a relevant file extension.

Relevant file extensions include:

.. code-block:: none

   .asp, .vbs, .ps, .ps1, .rar, .tmp, .bas, .bat, .chm, .cmd, .com, .cpl, .crt, .dll,
   .exe, .hta, .js, .lnk, .msc, .ocx, .pcd, .pif, .pot, .pdf, .reg, .scr, .sct, .sys,
   .url, .vb, .vbe, .vbs, .wsc, .wsf, .wsh, .ct, .t, .input, .war, .jsp, .php, .asp,
   .aspx, .doc, .docx, .pdf, .xls, .xlsx, .ppt, .pptx, .tmp, .log, .dump, .pwd, .w,
   .txt, .conf, .cfg, .conf, .config, .psd1, .psm1, .ps1xml, .clixml, .psc1, .pssc,
   .pl, .www, .rdp, .jar, .docm, .ace, .job, .temp, .plg, .asm

**Solution**: Add a custom meta rule with the ``DEEPSCAN`` tag.
See :ref:`signatures/yara:Deepscan Rules` for details.

.. code-block:: yara
   :caption: custom-meta-rule.yar

   rule MyCustomInspection : DEEPSCAN {
      meta:
         description = "Selects .myo files for the scan"
         score = 0
      condition:
         extension == ".myo"
   }

THOR does not initialize custom rules with the correct type
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users who prepare custom IOCs or YARA rules often forget to include the
correct keyword in the filename of the IOC or YARA rule file.

The correct use of keywords is described in the chapters :ref:`signatures/ioc-formats:Simple IOC files (deprecated)`
for IOCs and :ref:`signatures/yara:YARA Rules` for YARA rules.

A wrong or missing keyword can lead to situations in which a file
contains YARA rules meant for log files, but its filename does not
contain the keyword ``log``.

You can verify correct initialization in the command-line output or log
file.

.. code-block:: none

   Info Adding rule set from my-log-rules.yar as 'log' type

Using the keyword ``c2`` in a filename for C2 IOCs should result in a
line like the following:

.. code-block:: none

   Info Reading iocs from /tmp/thor10/custom-signatures/iocs/my-c2-iocs.txt as 'domains' type
