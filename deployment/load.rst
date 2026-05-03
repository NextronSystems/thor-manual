.. Index:: System Load Considerations

System Load Considerations
==========================

We recommend staggering THOR scans to avoid resource bottlenecks,
especially on shared network links or VMware host systems. At the start
of a scan, each system retrieves program files and signatures over the
network, which amounts to roughly 30 MB per system. In addition, the
modules that complete within seconds or a few minutes run first, so
system and network load are usually highest during the first 10 to 15
minutes of the scan.

We therefore recommend grouping systems into scan waves and starting
additional groups at intervals of about one hour.

Starting a large number of physical systems at the same time is usually
not a problem. If you scan many virtual machines or remote locations
connected over slow WAN links, use smaller scan groups.
