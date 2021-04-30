
Scoring System
==============

The scoring system is one of THOR's most prominent features. Both YARA
signatures and filename IOCs contain a score field. The score is an
integer value that can be negative to reduce the score on elements that
are prone to false positives.

Only YARA rules and Filename IOCs support a user defined score. But
since you are able to write YARA rules for almost every module, the
scoring system is very flexible.

The total score of an element determines the level/severity of the
resulting log message.

+---------+-----------+----------------------------------------+
| Score   | Level     | Condition                              |
+=========+===========+========================================+
| 40      | Notice    |                                        |
+---------+-----------+----------------------------------------+
| 60      | Warning   |                                        |
+---------+-----------+----------------------------------------+
| 100     | Alert     | At least 1 sub score of 75 or higher   |
+---------+-----------+----------------------------------------+

Scoring per Signature Type Match
--------------------------------

+--------------------------+----------------------------------------------------------------------------------+
| Type                     | Score                                                                            |
+==========================+==================================================================================+
| YARA match               | Defined in the meta data of the YARA rule as integer value (e.g. "score = 50")   |
+--------------------------+----------------------------------------------------------------------------------+
| Filename IOC match       | Defined in the 2\ :sup:`nd` field of the CSV (e.g. "\\\\evil.exe;80")            |
+--------------------------+----------------------------------------------------------------------------------+
| Keyword IOC match  	   | "warning" level messages, see 14.3 "Default Scores"                              |
+--------------------------+----------------------------------------------------------------------------------+
| C2 IOC match             | "warning" and "alert" level massages, see 14.3 "Default Scores"                  |
+--------------------------+----------------------------------------------------------------------------------+

Accumulated Score by Module
---------------------------

+---------------------+-------------------+------------------------------------------------------------------------------------------------+
| | Module            | | Cumulated       | | Scoring                                                                                      |
|		      | | Score		  |												   |
+=====================+===================+================================================================================================+
| | Filescan          | Yes               | | Score is a sum of the scores of all "REASON"s (YARA matches, 				   |
| | Archive Scan      |			  | | filename IOCs, other anomalies) 								   |                   
| | DeepDive          | 	          | | Note 1: Only positive scores are shown by default                                            |              
| | Prefetch          |                   | | Note 2: Only the top 2 reasons are shown by default (use     				   |
| | WER		      |			  | | –allreasons to show all positive scores)						           |
+---------------------+-------------------+------------------------------------------------------------------------------------------------+
| | All Other         | No                | | Individual score of each signature match (YARA, filename IOC, 			  	   |
| | Modules           |			  | | keywords, C2)                  								   |
|                     |                   | | Note 1: This means that multiple matches for a single element are 			   |
|		      |			  | | possible								             	    	   |
+---------------------+-------------------+------------------------------------------------------------------------------------------------+

Default Scores
--------------

If no score is set in an "alert" or "warning" message, THOR
automatically appends a score that corresponds to the message level:
Warning = 70, Alert = 100.

Exception: High total score with low sub scores
-----------------------------------------------

"Alerts" on file system elements are only generated if one of the sub
scores is at least 75.

Before that change, multiple low scoring reasons had led to a score
higher 100 and caused an "Alert" level message although not a single
hard match was included in the "Reasons". A wrong extension, e.g.
"**.txt**" for an executable, which is often used by employees to hand
executables through tight mail filters, and a suspicious location, e.g.
"**C:\\Temp\\funprog.txt**" caused an "Alert" level message.

Since version 8.27.2, one of the sub scores that pushes the total score
over 100 has to be 75 or higher. (internally calculated as "alert\_level
- 25" because the user can adjust the alert level via the "**--alert**"
parameter)

Exception: Filename IOC Matches
-------------------------------

The "Filename IOC Check" is a sub check of the "String Check", which is
applied to many elements, like Eventlog messages or Registry keys.

The function "checkString()" receives a string as input and returns
possible matches.

The string is checked in multiple sub-checks against different signature
lists. The most important sub-checks are "checkKeyword()" and
"checkFilename()".

While the "checkKeyword()" sub-check returns each individual match, the
"checkFilename()" sub check accumulates the score of all matches and
returns a single total score. It is possible that many different
filename signatures have matched on that string but only one match with
a total score is reported. This is an exception to the usual behavior 
where only the "FileScan" module accumulates scores.

Filename IOC Matching in String Check Example
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Imagine the following filename IOC signatures:

+----------------------------+
| | \\\\nmap.exe;70	     |
| | \\\\bin\\\\nmap.exe;-30  |
+----------------------------+

and the following Keyword signature:

+---------+
|nmap.exe |
+---------+

The "checkString()" function receives the following string from the
Eventlog scan module (here: a Sysmon Eventlog entry):

+-----------------------------------------------------------------------------------------------+
| | Process Create:										|		
| | UtcTime: 2018-01-10 10:22:25.277								|
| | ProcessGuid: {c1b49677-e961-5a55-0000-0010bbc80702}						|
| | ProcessId: 3912										|
| | Image: C:\\Program Files\\Nmap\\bin\\nmap.exe						|
| | CommandLine: nmap.exe									|
| | CurrentDirectory: C:\\Windows\\system32\\							|
| | User: PROMETHEUS\\user1									|
| | LogonGuid: {c1b49677-1d72-5a53-0000-0020d4232500}						|	
| | LogonId: 0x2523d4										|
| | TerminalSessionId: 1									|
| | IntegrityLevel: High									|
| | Hashes: SHA1=F5DC12D658402900A2B01AF2F018D113619B96B8,					|
| |         MD5=9FEA051A9585F2A303D55745B4BF63AA						|
| | ParentProcessGuid: {c1b49677-1d74-5a53-0000-001057452500}					|
| | ParentProcessId: 1036									|
| | ParentImage: C:\\Windows\\explorer.exe							|
| | ParentCommandLine: C:\\Windows\\Explorer.EXE						|
+-----------------------------------------------------------------------------------------------+

The "checkString()" function would create two messages: 1 "warning" for
the keyword signature and 1 "notice" of the filename IOC signatures.

The keyword IOC matches in the "checkKeyword()" sub-check and
"checkString()" returns a match, that generates a "Warning" level
message that automatically receives a score of 75 (see chapter 14.3).

The filename IOCs would both match on the string in the
"checkFilename()" sub-check and both score would be summed up to a total
score of 40 (70 + (-30) = 40), which would generate a "Notice".
