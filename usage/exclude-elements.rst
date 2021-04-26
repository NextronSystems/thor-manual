.. role:: raw-html-m2r(raw)
   :format: html

Exclude Elements
================

Files and Directories
---------------------

You may use the file "**directory-excludes.cfg**" to exclude directories
and files(! The name of the config file is misleading) from the scan.

THOR will not scan the contents of these directories but it will still
perform some basic checks on file names in these directories. This
"**directory-excludes.cfg**" config is meant to avoid scanning
sensitive files like databases or directories with a lot of content. If
you want to suppress false positives that are generated in these
directories, please see the following chapter and how to suppress them
by using "**false\_positive\_filters.cfg**".

The exclusion file contains regular expressions that are applied to each
scanned element. Each element consists of the file path and file name
(e.g. C:\\IBM\\temp\_tools\\custom.exe). If one of the defined
expressions matches, the element is excluded. Exclusions can be defined
for a full element name, at the beginning at the end or somewhere in the
element name.

As the configured exclusions are treated as regular expressions, special
characters must be masqueraded by backslash. This applies at least for:
**[]\\^$.\|?\*+()-**

+-------------------------------------------------------------+---------------------------------------+
| Element to exclude                                          | Possible solution                     |
+=============================================================+=======================================+
| C:\\IBM\\temp\_tools\\custom.exe                            | C:\\\\IBM\\\\temp\_tools\\\\          |
+-------------------------------------------------------------+---------------------------------------+
| Log folder of the tool "hpsm" regardless on the partition   | \\\\HPSM\\\\log\\\\                   |
+-------------------------------------------------------------+---------------------------------------+
| Every file with the extension .nsf                          | \\.nsf$                               |
+-------------------------------------------------------------+---------------------------------------+
| THOR custom signatures                                      | \\\\THOR\\\\custom\\-signatures\\\\   |
+-------------------------------------------------------------+---------------------------------------+

Eventlogs
---------

Eventlog sources can be excluded as whole in
"**eventlog-excludes.cfg**". The file holds one expression per line
and applies them as regular expression on the name of the Eventlog.
(e.g. “Microsoft-Windows-Windows Defender/Operational“)

+--------------------------------------------------+----------------------+
| Element to exclude                               | Possible solution    |
+==================================================+======================+
| Windows PowerShell                               | Windows PowerShell   |
+--------------------------------------------------+----------------------+
| Microsoft-Windows-Windows Defender/Operational   | Windows Defender     |
+--------------------------------------------------+----------------------+

Registry
--------

Registry paths/keys can be excluded in “\ **registry-excludes.cfg**\ ”.
The file holds one expression per line and applies them as regular
expression on each registry key. (e.g. “Software\\WOW6432Node“). Don’t
include the root of the key, e.g. HKLM.

+---------------------------------------+--------------------------------------------------+
| Element to exclude                    | Possible solution                                |
+=======================================+==================================================+
| | HKEY\_LOCAL\_MACHINE\\Software\\ ⏎  | Symantec Endpoint ⏎ Protection\\AV\\Exclusions   |
| | Wow6432Node\\Symantec\\Symantec     |                                                  |
| | Endpoint Protection\\AV\\Exclusions |                                                  |
+---------------------------------------+--------------------------------------------------+

False Positives
---------------

The false positive filters work like the directory/file excludes. A
regular expression is applied to the full content of the "**MESSAGE:**"
value.

E.g. if you want to Exclude all messages that contain the string
"**Trojan\_Buzus\_dev**" you just add this string to the
"**false\_positive\_filters.cfg**" file. The file works with regular
expressions so you could also define something like
"**chinese\_(charcode\|keyboard)**".

Filter Verification
-------------------

If you are unsure about the filters you just set, we recommend a test
run on a certain directory that matches the criteria.

You can start a short test run on a certain directory with:

.. code:: batch
   
   thor.exe --lab -p C:\\TestDir

Personal Information
--------------------

THOR features an option named **--brd** that allows to filter the output
messages and replace all known locations and fields that can contain
user names or user ids with the value "**ANONYMIZED\_BY\_THOR**".

What it does is:

* Replace all "USER" and "OWNER" field values of all modules with the anonymized string value
* Replaced the subfolder names of "**C:\\Users**" and "**C:\\Documents and Settings**" with the anonymized string value

There is no guarantee that all user IDs will be removed by the filter,
as they may appear in the most unexpected locations, but in most cases
this approach is sufficient to comply with data protection requirements.
