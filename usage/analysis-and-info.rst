
Analysis and Info
=================

Log Analysis Manual
-------------------

The **./docs** folder of the THOR program directory contains a manual
named **THOR\_LogAnalysis.pdf** on how to process the events generated
by THOR.

VALHALLA Rule Lookup
--------------------

The new rule info pages allow you to get more information on a certain
rule. You can find all the meta data, as well as past rule matches and
previous antivirus verdicts. A second tab contains statistics. You can
also report false positives that you’ve encountered with that rule using
the button in the tab bar. 

Note that the rule info lookups in the web GUI are rate limited. If you
query rule infos too often, you get blocked.

The rule info pages can be access using this URL scheme: 

https://valhalla.nextron-systems.com/info/rule/RULE\_NAME

For example:

https://valhalla.nextron-systems.com/info/rule/HKTL_Empire_ShellCodeRDI_Dec19_1

.. figure:: ../images/image34.png
   :target: ../_images/image34.png
   :alt: Rule Info Page
   
   Rule Info Page

Rule List Output
----------------

By using the **--print-signatures** flag, you can get a list of all
initialized YARA and Sigma rules.

.. figure:: ../images/image35.png
   :target: ../_images/image35.png
   :alt: Rule List Output

   Rule List Output
