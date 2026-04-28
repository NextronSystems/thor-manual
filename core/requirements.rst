.. Index:: Requirements

.. role:: raw-html-m2r(raw)
   :format: html

Requirements
============

THOR runs on supported Windows, Linux, macOS, and AIX systems without
additional runtime requirements. Everything required to run THOR is
included in the program package.

For full scan coverage, we recommend running THOR with administrative
privileges: ``LOCAL_SYSTEM`` on Windows and ``root`` on Linux, macOS, and
AIX.

Operating Systems
-----------------

The following operating systems and versions are the **minimum
requirements** to run THOR. Newer releases within these platform families
are generally expected to work as well.

.. list-table::
  :widths: 30, 30, 40
  :header-rows: 1

  * - Linux
    - Windows
    - macOS
  * - RHEL/CentOS 7
    - Windows 10 x86/x64
    - macOS 11 (Big Sur)
  * - SuSE SLES 12.2
    - Windows Server 2016
    -
  * - Ubuntu 16 LTS
    -
    -
  * - Debian 9
    -
    -

Legacy Systems
^^^^^^^^^^^^^^

THOR Legacy is available for the systems listed below.

.. list-table::
  :widths: 65, 35
  :header-rows: 1

  * - OS
    - Architecture
  * - Windows Server 2012
    - x86 and x64
  * - Windows Server 2008 R2
    - x86 and x64
  * - Windows Server 2008
    - x86 and x64
  * - Windows 8
    - x86 and x64
  * - Windows 7
    - x86 and x64
  * - Windows XP
    - x86 and x64
  * - CentOS 6
    - x86 and x64

.. note::
   THOR Legacy packages are available for all systems listed above. We
   continue to provide updated signature packages and, in some cases,
   updated program versions for these legacy releases. Support is limited:
   these versions run on our test systems, but we cannot guarantee
   successful operation on every legacy installation. Compatibility depends
   on factors such as service packs, installed KB updates, drivers, and
   third-party software. Contact us for details on how to download and use
   THOR Legacy.

THOR for AIX
^^^^^^^^^^^^

We provide native THOR scanner packages for IBM AIX.

THOR for AIX supports IBM AIX 7.2 and 7.3. Build and test environments
currently available to us include AIX 7.2 TL5 SP11 and AIX 7.3 TL3 SP0.

Older AIX versions are not supported. If you would like to validate
compatibility in your environment, please contact us for a test license.

Unsupported
^^^^^^^^^^^

* VMware ESX - see https://knowledge.broadcom.com/external/article?legacyId=1036544
* Operating systems or architectures for which no native THOR package is
  available
* Appliance or embedded environments that cannot run a native THOR package

If you need to perform an analysis on unsupported operating systems or architectures, contact us
for a solution using `THOR Thunderstorm <https://www.nextron-systems.com/thor-thunderstorm/>`__
and `Thunderstorm collectors <https://github.com/NextronSystems/thunderstorm-collector>`__.

We also have production deployments with customers that rely on file
collection from:

* SPARC Solaris
* RHEL Linux 4
* Citrix Netscaler
* ICS environments with Windows XP embedded systems
* VMware ESX (see this `blog post <https://www.nextron-systems.com/2021/06/07/analyze-vmware-esx-systems-with-thor-thunderstorm/>`__)

Update Servers
--------------

An active internet connection is required only if you want to update THOR
and its signature sets. The system performing the update must be able to
reach our update servers.

For a detailed and up-to-date list of our update and licensing
servers, please visit https://www.nextron-systems.com/hosts/.

.. hint::
  THOR does not require an active internet connection to scan a system.
  Internet access is only required to update THOR and its signature sets.
  We also offer licensing options for environments without internet access.
  Contact us if you need an offline licensing setup.
