.. index:: Licensing

Licensing
=========

Before using THOR for the first time, read this section to understand
how licensing works.

THOR requires a valid license to run. After generating and downloading a
license file, place it in the THOR program folder. THOR scans the
program folder and all subfolders for valid license files (``*.lic``).
We recommend creating a folder named ``licenses`` within the THOR
directory to keep things organized. Alternatively, you can specify a
custom search path with ``--license-path <path>``. For details, refer to
:ref:`core/licensing:About License Files`. For automation purposes, THOR
also supports :ref:`core/licensing:license injection via environment`.

Generate a License
^^^^^^^^^^^^^^^^^^

You can generate a valid license in our
`customer portal <https://portal.nextron-systems.com/>`__.

Navigate to ``Contracts & Licenses`` > ``My Contracts`` and select the
appropriate contract type to generate a new license. Use either
``THOR Workstation`` or ``THOR Server & Workstation`` as the license
type.

The following overview shows which license type to use:

* THOR Workstation: host-based THOR scanner license for Windows
  workstations and macOS only. It cannot be used on Windows servers or
  Linux systems, regardless of their role. Usage on legacy systems such
  as Windows XP requires the ``legacy`` option.
* THOR Server & Workstation: host-based THOR scanner license for scans
  on workstations and servers running Windows, Linux, or macOS. Usage on
  legacy systems such as Windows 2003 or Windows 2008 before R2
  requires the ``legacy`` option.

.. figure:: ../images/portal_contract_overview.png
   :alt: Contract Overview in the Portal

   Contract Overview in the Portal

Click the green ``Plus`` icon for your contract and fill in all required
fields. After clicking ``Check Hostnames``, you can issue the license if
all hostnames are unique and valid.

.. figure:: ../images/portal_generate_license.png
   :alt: Generate a License in the Portal

   Generate a License in the Portal

To generate a license, use the hostname of the system on which THOR
will run. On Windows, use the ``computername`` as the hostname during
license creation:

.. code-block:: doscon

   C:\Users\nextron>echo %COMPUTERNAME%
   WIN11-TESTING

On Linux, use the ``hostname`` command:

.. code-block:: console

   nextron@unix:~$ hostname
   unix

On macOS, use the following command:

.. code-block:: console

   MacBook:~ nextron$ sysctl kern.hostname
   MacBook

Additional notes on hostname values:

* Use only the hostname part of an FQDN (**master1** from
  **master1.internal.net**)
* Letter casing does not matter (case-insensitive)
* We do not store hostnames in the portal

After you issue the license, your browser opens the ``Licenses`` section
of the portal. There you can see all licenses issued for the contract
you just used. You can download a single ``License``, a ``License
Bundle`` containing all selected licenses in one ZIP file, or a
``Software + License Bundle`` containing the correct THOR version
together with your license(s). To see licenses across all contracts,
remove the filter at the top labeled ``Contract: xyz``.

.. figure:: ../images/portal_licenses_overview.png
   :alt: Licenses Overview in the Portal

   Licenses Overview in the Portal

About License Files
^^^^^^^^^^^^^^^^^^^

THOR scans its program folder and all subfolders for valid ``.lic``
files and uses the first valid license it finds.

This behavior simplifies rollouts with the host-based license model.

You can generate licenses for many systems, store them in a subfolder
named ``licenses`` (for example ``thor-system1.lic``,
``this-system2.lic``, ``...``), and distribute the THOR program folder
with that subfolder to all licensed systems. On each system, you can
then simply run ``thor64.exe``. There is no limit to the number of
license files that can be placed in this folder.

This allows you to prepare one USB drive for all systems or provide a
network share with one THOR copy that already includes all required
licenses. Another use case is :ref:`deployment/thor-remote:Thor Remote`,
which requires a license for every remote system you plan to scan.

License Injection via Environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instead of using license files, you can provide a specific license
through THOR's execution environment. This is particularly useful for
automation, for example if THOR runs inside a container.

Use a valid license file and store its content as a base64-encoded
string in the ``THOR_LICENSE`` environment variable:

.. code-block:: console

   nextron@unix:~$ export THOR_LICENSE=$(base64 < /path/to/thor.lic)

Then run THOR as usual.

ASGARD Management Center
^^^^^^^^^^^^^^^^^^^^^^^^

The ASGARD Management Center includes built-in licensing functionality.
It is used to license your assets (an asset is an endpoint with our
ASGARD Agent installed). It can also generate and download licenses for
standalone THOR instances.

In the ASGARD Management Center, you can configure a download token to
restrict THOR package and license downloads to clients that know this
token. This helps prevent unauthorized package retrieval and unintended
overuse of your license quota.

The download token can be configured in the ``Downloads`` section of
your ASGARD server.

.. figure:: ../images/download-token.png
   :alt: Downloads > Download Token Configuration

   Downloads > Download Token Configuration

THOR can retrieve an appropriate license at scan start using the
built-in ``--asgard-host`` and ``--asgard-token`` parameters.

.. code-block:: doscon

   C:\temp\thor>thor64.exe --asgard-host my-asgard.internal --asgard-token OCU92GW1CyOJLzaHkGrim1v2O0_ZkHPu0A

If everything works as expected, you will see an INFO-level message in
the output similar to the following:

.. code-block:: none

   Info: Init License file found LICENSE: my-asgard.internal OWNER: my-company ASGARD: ACME Inc TYPE: Workstation STARTS: 2021/06/18 EXPIRES: 2022/06/18 SCANNER: All Scanners VALID: true REASON:

You can also automate license retrieval from a local ASGARD server by
using the API. The help box in ASGARD's ``Licensing > Generate
License`` section shows example ``curl`` requests that can be used to
retrieve licenses from your ASGARD server.

.. figure:: ../images/asgard-license-gen.png
   :alt: Licensing > Generate Licenses

   Licensing > Generate Licenses

You only need:

* Hostname
* System Type (``server`` or ``workstation``)

.. hint::
   Linux always uses the ``server`` license type.

.. hint::
   For more information about API endpoints in the ASGARD Management
   Center, consult the built-in API documentation in the product.

Check the ASGARD helper scripts section in
`our GitHub repo <https://github.com/NextronSystems/nextron-helper-scripts/tree/master/asgard>`__
for more scripts and snippets.

Customer Portal
^^^^^^^^^^^^^^^

To retrieve a license from the customer portal, you need a portal key.
The portal key (API key) can be configured in the
``My Settings > API Key`` section of the
`customer portal <https://portal.nextron-systems.com>`__.

.. important::
   API functionality must be activated by Nextron. Please contact
   support or sales to enable it.

.. figure:: ../images/portal_api_key.png
   :alt: Settings > API Key

   Settings > API Key

THOR can retrieve an appropriate license at scan start using the
built-in ``--portal-api-key`` and ``--portal-contracts`` parameters.
The ``--portal-contracts`` parameter is optional. Use it if you want
THOR to retrieve licenses from specific contracts. If it is not set,
THOR automatically retrieves a license from the first valid contract of
the required type with available licenses.

.. figure:: ../images/portal_contract_ids.png
   :alt: Contracts IDs in Customer Portal

   Contract IDs in Customer Portal

You can then use the parameters as shown in the following examples:

.. code-block:: doscon

   C:\temp\thor>thor64.exe --portal-api-key IY5Y36thrt7h1775tt1ygfuYIadmGzZJmVk32lXcud4

.. code-block:: doscon

   C:\temp\thor>thor64.exe --portal-api-key IY5Y36thrt7h1775tt1ygfuYIadmGzZJmVk32lXcud4 --portal-contracts 3,5

If everything works as expected, you will see an **INFO**-level message
in the output similar to the following:

.. code-block:: none

   Info License file found LICENSE: portal.nextron-systems.com OWNER: ACME Inc TYPE: Workstation STARTS: 2021/06/23 EXPIRES: 2021/06/30 SCANNER: All Scanners VALID: true REASON:

You can specify a proxy by setting the ``HTTP_PROXY`` and
``HTTPS_PROXY`` environment variables, for example to
``my-proxy.internal:3000``.

Username and password can be specified as part of the proxy URL as ``http://username:password@host:port/``.

.. hint::
   For other automation approaches, use the built-in API documentation
   in the portal.
