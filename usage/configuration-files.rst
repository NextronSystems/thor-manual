.. role:: raw-html-m2r(raw)
   :format: html

Configuration Files
===================

Scan Templates
--------------

THOR 10 accepts config files (called “templates”) in YAML format. They
reflect all command options to make them flexible and their use as
comfortable as possible.

This means that every parameter set via command line can be provided in
the form of a config file. You can even combine several of these config
files in a single scan run.

Default Template
^^^^^^^^^^^^^^^^

By default, THOR only applies the file named **thor.yml** in the
**./config** sub folder. Other config files can be applied using the
**-t** command line parameter.

Apply Custom Scan Templates
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following command line provides a custom scan template named
**mythor.yml**.

.. code:: batch
   
   thor.exe -t mythor.yml

Example Templates
^^^^^^^^^^^^^^^^^

The default config **thor.yml** in the **./config** folder has the
following content.

Content of THOR's Default Config 'thor.yml':

+------------------------------------------------------------------------------+
| # This is the default config for THOR                                        |
|                                                                              |
| # Terminate THOR if he runs longer than 72 hours                             |
|                                                                              |
| max\_runtime: 72                                                             |
|                                                                              |
| # Minimum score to report is 40                                              |
|                                                                              |
| min: 40                                                                      |
|                                                                              |
| # Skip files bigger than 12000000 bytes                                      |
|                                                                              |
| max\_file\_size: 12000000                                                    |
|                                                                              |
| # Skip files bigger than 30000000 bytes in intense mode (--lab, --intense)   |
|                                                                              |
| max\_file\_size\_intense: 30000000                                           |
|                                                                              |
| # Limit THOR's CPU usage to 95%                                              |
|                                                                              |
| cpulimit: 95                                                                 |
|                                                                              |
| # The minimum amount of free physical memory to proceed (in MB)              |
|                                                                              |
| minmem: 50                                                                   |
|                                                                              |
| # Truncate THOR's field values after 2048 characters                         |
|                                                                              |
| truncate: 2048                                                               |
+------------------------------------------------------------------------------+

Content of Config File ‘mythor.yml':

+----------------------------+
| resume: true               |
|   			     |
| cpulimit: 40               |
|			     |
| intense: true              |
|		             |
| max\_file\_size: 7500000   |
|			     |
| syslog:                    |
|			     |
| - foo.nextron              |
|			     |
| - bar.nextron:514:TCP      |
+----------------------------+

The default scan template is always applied first. Custom templates can
then overwrite settings in the default template. In the example above,
the **cpulimit** and **max\_file\_size** parameters are overwritten by
the custom template.

As you can see in the example file, you have to use the long form of the
command line parameter (e.g. **syslog**) and not the short form (e.g.
**s**) in the template files. The long forms can be looked up in the
command line help using **--help**.

.. figure:: ../images/image20.png
   :target: ../_images/image20.png
   :alt: Lookup command line parameter long forms using -help

   Lookup command line parameter long forms using –help

Maximum File Size
-----------------

The default maximum file size for deeper investigations (hash
calculation, YARA scanning) is 12 MB and preset in the config file
"**./config/thor.yml**". The maximum file size for the
"**intense**" scan mode is 30 MB.

You can adjust the values in the "**thor.yml**". This file does not
get overwritten by an update.

Special scan features like the EVTX or Memory Dump scan ignore these
limits.

Chunk Size in DeepDive
^^^^^^^^^^^^^^^^^^^^^^

The chunk size in DeepDive module is set to the maximum file size value.
Remember that DeepDive uses overlapping chunks of that size for YARA
rule scanning.

Example:

If the maximum file size is set to a default of 12 MB, DeepDive use the
following chunks in its scan to apply the YARA rule set:

| Chunk 1: Offset 0 – 12
| Chunk 2: Offset 6 – 18
| Chunk 3: Offset 12 – 24
| Chunk 4: Offset 18 – 30

