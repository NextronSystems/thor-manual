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
  :widths: 30 35 35
  :header-rows: 1

  * - Linux
    - Windows
    - macOS
  * - RHEL/CentOS 6
    - Windows 7 x86/x64
    - macOS 10.14 (Mojave)
  * - SuSE SLES 11 SP1
    - Windows Server 2008 R2
    - macOS 11 (Intel)
  * - Ubuntu 16 LTS
    - 
    - macOS 11 (ARM, Apple M1)
  * - Debian 9
    - 
    -

.. hint::
   A minimum Linux kernel version of ``2.6.32`` is required to run THOR.
   Linux operating systems older than those listed above might still
   work, but we no longer test them, so support cannot be guaranteed.
   In any case, verify the kernel version before running THOR.

For AIX platforms and compatibility details, see `THOR for AIX`_.

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

THOR for AIX
^^^^^^^^^^^^

We provide native THOR scanner packages for IBM AIX. Our current platform
focus is AIX 7.2 and 7.3. Older AIX versions are outside this scope.

The native scanner requires POWER8 or newer processor capabilities;
POWER7 is not supported, even if it runs AIX 7.2. This reflects the
`Go ppc64 processor requirements
<https://go.dev/wiki/MinimumRequirements#ppc64-big-endian>`__.

**Test platform and available environments**

THOR for AIX is tested on AIX 7.3 with IBM POWER9 in IBM Cloud. The
following IBM Cloud environments are currently available for build and
test activities:

.. list-table::
   :widths: 20, 35, 45
   :header-rows: 1

   * - AIX version
     - Technology Level / Service Pack
     - OS level (``oslevel -s``)
   * - 7.2
     - TL5 SP11
     - ``7200-05-11-2546``
   * - 7.3
     - TL3 SP0
     - ``7300-03-00-2446``

These entries describe available environments. They are not a complete
test matrix or minimum TL/SP requirements for every THOR release.

**Binary compatibility**

The scanner is primarily written in Go and includes native C components.
Binary compatibility therefore also depends on the build environment,
compiler toolchain and runtime libraries.

`IBM's AIX binary compatibility guidance
<https://www.ibm.com/docs/en/aix/7.3.0?topic=aix-binary-compatibility>`__
describes running applications built on older AIX releases or Technology
Levels on newer levels. The reverse should not be assumed: a package
built on a newer level may depend on libraries or symbols that are
unavailable on an older system. This guidance does not replace validation
of a specific THOR package in the target environment.

**Build and support strategy under evaluation**

We are evaluating a strategy of building on a defined minimum AIX level
and validating compatibility on newer levels, while keeping the number
of binary variants low. No final policy has been defined for:

* the build baseline, compiler toolchain and runtime dependency model;
* the regular TL/SP test matrix;
* the minimum supported AIX level for each THOR version;
* whether one binary can cover AIX 7.2 and 7.3 or separate variants are
  required.

**POWER7 and other systems without native scanner support**

For POWER7 systems, use `THOR Thunderstorm
<https://www.nextron-systems.com/thor-thunderstorm/>`__ to analyze files
collected from the AIX host. Use a collection script or another file
transfer method compatible with the target system. The Go-based
Thunderstorm collector also requires POWER8 or newer processor
capabilities and is not a workaround for POWER7. See the
`Thunderstorm collection scripts
<https://github.com/NextronSystems/thunderstorm-collector/tree/master/scripts>`__
for available script variants; validate their dependencies on the target
AIX system.

Alternatively, use THOR with a Forensic Lab License to scan exported
files or a filesystem made accessible on a supported analysis host. The
license does not enable a native scanner to run on unsupported hardware.
Both approaches analyze the supplied files and do not include live
process or other volatile system checks on the AIX host.

Contact us to confirm compatibility with your AIX level and THOR version,
or to request a test license for validation in your environment.

.. note::
   This section describes the THOR scanner. For ASGARD agent deployments,
   contact support to confirm the agent's AIX requirements separately.

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
