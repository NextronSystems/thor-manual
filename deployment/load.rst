.. Index:: System Load Considerations

System Load Considerations
--------------------------

We recommend staging the THOR Run in order to avoid resource bottlenecks
(network or on VMware host systems). Especially during the THOR start,
program files and signatures get pulled over the network, which is about
30 MB per system. Additionally, the modules, which take only a few
seconds or minutes to complete, run first so that the load is higher
during the first 10 to 15 minutes of the scan.

It is therefore recommended to define sets of systems that will run at
the same time and let other systems start at intervals of an hour.

It is typically no problem to start a big set of physical machines at
the same time. But if you start a scan on numerous virtual guests or on
remote locations connected through slow WAN lines, you should define
smaller scan groups.