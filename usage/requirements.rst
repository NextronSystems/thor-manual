.. role:: raw-html-m2r(raw)
   :format: html

Requirements
============

THOR runs on supported Windows, Linux, macOS, and AIX systems without
additional runtime requirements. Everything needed is already included
in the program package.

For full scan coverage, run THOR with administrative privileges:
``LOCAL_SYSTEM`` on Windows and ``root`` on Linux, macOS, and AIX
systems.

Operating Systems
-----------------

The following operating systems and versions are the **minimum
requirements** to run THOR. Newer versions are also expected to work.

.. list-table:: 
  :widths: 23 31 23 23
  :header-rows: 1

  * - Linux
    - Windows
    - macOS
    - IBM AIX
  * - RHEL/CentOS 6
    - Windows 7 x86/x64
    - macOS 10.14 (Mojave)
    - 7.2 (PowerPC 8)
  * - SuSE SLES 11 SP1
    - Windows Server 2008 R2
    - macOS 11 (Intel)
    - 
  * - Ubuntu 16 LTS
    - 
    - macOS 11 (ARM, Apple M1)
    - 
  * - Debian 9
    - 
    -
    -

.. hint::
   A minimum Linux kernel version of ``2.6.32`` is required to run THOR.
   Linux operating systems older than those listed above might still
   work, but we no longer test them, so support cannot be guaranteed.
   In any case, verify the kernel version before running THOR.

Legacy Systems
^^^^^^^^^^^^^^

These versions can be scanned with a valid ``THOR Legacy`` license and
a dedicated ``THOR Legacy`` version. These systems receive only limited
support. If you encounter problems on these outdated platforms, we may
not be able to provide a fix. Contact us for details on how to obtain
and use ``THOR Legacy``.

.. list-table:: 
  :widths: 50, 25, 25
  :header-rows: 1

  * - OS
    - Architecture
    - Status
  * - Windows Server 2008
    - x86 and x64
    - Limited support
  * - Windows Server 2003 SP2
    - x86 and x64
    - Limited support
  * - Windows Server 2003 SP1
    - x86 and x64
    - Limited support
  * - Windows Server 2003
    - x86 and x64
    - Limited support
  * - Windows XP SP3
    - x86 and x64
    - Limited support
  * - Windows XP SP2
    - x86 and x64
    - Limited support

Unsupported
^^^^^^^^^^^

* VMware ESX - see `Broadcom knowledge base article 1036544 <https://knowledge.broadcom.com/external/article?legacyId=1036544>`__
* Other unsupported platforms and architectures may require a different collection and analysis approach

If you need to analyze unsupported operating systems or architectures,
contact us for a solution using `THOR Thunderstorm <https://www.nextron-systems.com/thor-thunderstorm/>`__
and `Thunderstorm collectors <https://github.com/NextronSystems/thunderstorm-collector>`__.

Some of our customers have a productive setup which uses Thunderstorm
to collect/analyze files from the following systems:

* SPARC Solaris 
* RHEL Linux 4
* Citrix Netscaler
* VMWare ESX (see this `blog post <https://www.nextron-systems.com/2021/06/07/analyze-vmware-esx-systems-with-thor-thunderstorm/>`__)

Update Servers
--------------

To download the latest updates for THOR and our signatures, you need an
active internet connection. The endpoint performing the update must be
able to reach our update servers.

For a detailed and up to date list of our update and licensing
servers, please visit `our knowledge base <https://knowledge.nextron-systems.com/general/hosts-ip-addresses>`__.

.. hint::
  You do not need an active internet connection to scan an endpoint.
  Internet access is only required to update THOR and the signature
  databases. Special license arrangements are available for
  circumstances in which the licensed system does not have internet
  access and another system must be used to download updates.
