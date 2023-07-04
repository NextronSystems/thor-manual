.. role:: raw-html-m2r(raw)
   :format: html

Requirements
============

THOR runs in any Windows, Linux and macOS environment without any
further requirements. Everything needed is already included in the
program package.

To use the full potential of THOR, you should execute it with administrative
privileges - ``LOCAL_SYSTEM`` on Windows and ``root`` on Linux/macOS
systems.

Operating Systems
-----------------

The following operating systems and their versions are the **minimum
requirements** to run THOR. Any newer version will also work with THOR.

.. list-table:: 
  :widths: 30, 30, 40
  :header-rows: 1

  * - Linux
    - Windows
    - macOS
  * - RHEL/CentOS 6
    - Windows 7 x86/x64
    - macOS 10.14 (Mojave)
  * - SuSE SLES 11
    - Windows Server 2008 R2
    - macOS 11 (Intel)
  * - Ubuntu 16 LTS
    - 
    - macOS 11 (ARM, Apple M1)
  * - Debian 9
    - 
    - 

Limited Support
^^^^^^^^^^^^^^^

These versions are scannable with THOR Legacy. The legacy version
of THOR is usually running on those systems, but if you encounter
any problems, we will not be able to fix them. Contact us for
details on how to download and use THOR Legacy.

.. list-table:: 
  :widths: 30, 30, 40
  :header-rows: 1

  * - OS
    - Architecture
    - Support
  * - Windows XP SP2
    - x86 and x64
    - no
  * - Windows XP SP3
    - x86 and x64
    - no
  * - Windows Server 2003
    - x86 and x64
    - no
  * - Windows Server 2003 SP1
    - x86 and x64
    - no
  * - Windows Server 2003 SP2
    - x86 and x64
    - no
  * - Windows Server 2008
    - x86 and x64
    - yes

THOR for AIX
^^^^^^^^^^^^

We offer a special version for AIX. Currently only a small number of versions
are supported. We are extensively testing THOR on AIX 7.2 with Power7/Power8. 
THOR for AIX will not run on older versions of AIX. If you are running a newer
version and are interested in THOR for AIX, we can always provide a test license
to verify if everything is working as expected.

Unsupported
^^^^^^^^^^^

* VMWare ESX - `https://kb.vmware.com/s/article/1036544 <https://kb.vmware.com/s/article/1036544>`__
* many others 

If you need to perform an analysis on unsupported operating systems or architectures, contact us
for a solution using `THOR Thunderstorm <https://www.nextron-systems.com/thor-thunderstorm/>`__
and `Thunderstorm collectors <https://github.com/NextronSystems/thunderstorm-collector>`__.

We have productive setups with our customers involving the file collection from: 

* SPARC Solaris 
* RHEL Linux 4
* Citrix Netscaler
* ICS environments with Windows XP embedded systems (planned)
* VMWare ESX (see this `blog post <https://www.nextron-systems.com/2021/06/07/analyze-vmware-esx-systems-with-thor-thunderstorm/>`__)

Update Servers
--------------

To download the newest updates for THOR and our signatures, you need an active internet connection.
The endpoint performing the update needs to reach our update servers to do this.

For a detailed and up to date list of our update and licensing
servers, please visit https://www.nextron-systems.com/hosts/.

.. hint::
  You do not need an active internet connection to scan an endpoint. This is only needed
  if you want to update to the latest THOR and signature versions. There are special
  licenses for special circumstances, for example when the licensed system does not
  have internet access.
