.. index:: Licensing

Licensing
=========

Before you begin to use THOR for the first time, you should read through
this section to get a better understanding of what is needed to use THOR.

THOR needs a valid license to run. After you generated and downloaded a
license file, place it inside the THOR program folder. THOR checks the
program folder and all sub folders for valid license files (``*.lic``).
We recommend to create a folder called ``licenses`` within THOR's program
directory to keep organized. Alternatively, you can specify a path to
search in with ``--license-path <path>``. For details, refer to
:ref:`core/licensing:About License Files`. For automation purposes, THOR
also supports :ref:`core/licensing:license injection via environment`.

Generate a License
^^^^^^^^^^^^^^^^^^

You can generate a valid license in our `customer portal <https://portal.nextron-systems.com/>`__.

Navigate to ``Contracts & Licenses`` > ``My Contracts`` and choose the
correct Contract Type to generate a new license. You can use ``THOR Workstation``
or ``THOR Server & Workstation`` as the License Type.

Here is an Overview of which type of license you need to use:

* THOR Workstation

  - Host-based THOR scanner license for Windows workstations and macOS only.
    Not usable on Windows servers or Linux systems, regardless of their
    actual usage (e.g. Linux Desktop systems). Usage on legacy systems,
    such as Windows XP, requires the ``legacy`` option.

* THOR Server & Workstation

  - Host-based THOR scanner license for scans on all end systems, workstations,
    servers, Windows, Linux, and macOS. Usage on legacy systems, like Windows
    2003 or Windows 2008 before R2, requires the ``legacy`` option.

.. figure:: ../images/portal_contract_overview.png
   :alt: Contract Overview in the Portal

   Contract Overview in the Portal

Click on the green ``Plus`` icon of your contract and fill all the mandatory
fields. After clicking on ``Check Hostnames``, you can issue the license
if all the hostnames are unique and valid.

.. figure:: ../images/portal_generate_license.png
   :alt: Generate a License in the Portal

   Generate a License in the Portal

For the license generation, it is necessary to use the hostname of the system
which will run THOR. On a Windows system, you should use the ``computername``
as hostname during license creation:

.. code-block:: doscon

   C:\Users\nextron>echo %COMPUTERNAME%
   WIN11-TESTING

On Linux use the ``hostname`` command:

.. code-block:: console

   nextron@unix:~$ hostname
   unix

On macOS use the following command:

.. code-block:: console

   MacBook:~ nextron$ sysctl kern.hostname
   MacBook

Some more remarks regarding the hostname values:

* Use only the hostname of a FQDN (**master1** of **master1.internal.net**)
* The casing of the letters doesn't matter (case-insensitive)
* We do not store the hostnames anywhere in our portal

After you issued your license, your browser will forward you to the ``Licenses``
section of the portal. You will be able to see all the issued licenses for the contract
you just used earlier. You can either download a single ``License``, a ``License Bundle``,
which contains all the selected licenses in one zip file, or a ``Software + License
Bundle``, which contains the correct THOR version plus your license(s).
If you want to see all your issued licenses for all of your contracts, you can remove the
filter on the top which says ``Contract: xyz``.

.. figure:: ../images/portal_licenses_overview.png
   :alt: Licenses Overview in the Portal

   Licenses Overview in the Portal

About License Files
^^^^^^^^^^^^^^^^^^^

THOR processes its program folder and all sub folders in search for a
valid license file with a ``.lic`` extension, and picks the first
valid license it can find.

This change has been made to facilitate the rollout using the new host
based license model.

You can now generate licenses for a big set of systems, store all the
licenses (e.g. ``thor-system1.lic``, ``this-system2.lic``, ``...``)
in a sub folder called ``licenses`` and transfer the THOR program folder with
the ``licenses`` sub folder to all the different systems, for which you have
generated licenses and just run the ``thor64.exe`` executable. There is no
limit on how many license files are placed in this folder.

You can use this to create one thumb drive for all your systems, or have a
network share with one version of THOR with all your licenses included.
Another use case might be the usage of :ref:`deployment/thor-remote:Thor Remote`,
which requires a license for all remote systems you plan on scanning.

License Injection via Environment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Instead of dealing with license files, you can provide a specific license via
the execution environment of THOR. This is particularly useful for automation
purposes, e.g., if THOR is run in a nested environment like a container.

Use a valid license file to store its content as a base64-encoded string in the
environment variable ``THOR_LICENSE``:

.. code-block:: console

   nextron@unix:~$ export THOR_LICENSE=$(base64 < /path/to/thor.lic)

Then run THOR as usual.

ASGARD Management Center
^^^^^^^^^^^^^^^^^^^^^^^^

The ASGARD Management Center has built in licensing functionality,
which is used to license your assets (an asset is an endpoint with our
ASGARD Agent installed). It can also be used to generate and download
licenses for standalone THOR instances.

In the ASGARD Management Center you are able to configure a download
token to limit the download of THOR packages and licenses to clients
with knowledge of this token. The token is a protection that no one
without knowledge of that token can intentionally exceed your license
quota limit or retrieve a THOR package without authorization.

The download token can be configured in the ``Downloads`` section of you ASGARD server.

.. figure:: ../images/download-token.png
   :alt: Downloads > Download Token Configuration

   Downloads > Download Token Configuration

You can retrieve an appropriate THOR license at the scan start using the built-in
``--asgard-host`` and ``--asgard-token`` parameters.

.. code-block:: doscon 

   C:\temp\thor>thor64.exe --asgard-host my-asgard.internal --asgard-token OCU92GW1CyOJLzaHkGrim1v2O0_ZkHPu0A

If everything works as expected, you'll see an INFO level message in the output that looks like:

.. code-block:: none 

   Info: Init License file found LICENSE: my-asgard.internal OWNER: my-company ASGARD: ACME Inc TYPE: Workstation STARTS: 2021/06/18 EXPIRES: 2022/06/18 SCANNER: All Scanners VALID: true REASON:

You can also script the license retrieval from a local ASGARD server by using the API. The help
box in ASGARD's ``Licensing > Generate License`` section shows curl requests that can be used
to retrieve licenses from your ASGARD server.

.. figure:: ../images/asgard-license-gen.png
   :alt: Licensing > Generate Licenses

   Licensing > Generate Licenses

All you need is: 

* Hostname 
* System Type (``server`` or ``workstation``)

.. hint:: 
   Linux is always using the ``server`` license type

.. hint::
   For more information regarding API endpoints within the ASGARD Management Center,
   please consult the built in API Documentation in said product.

Check the ASGARD helper scripts section in
`our Github repo <https://github.com/NextronSystems/nextron-helper-scripts/tree/master/asgard>`__
for more scripts and snippets.

Customer Portal
^^^^^^^^^^^^^^^

To retrieve a licenses from the customer portal, you need a portal key. The portal key
(API key) can be configured in the ``My Settings > API Key`` section of the
`customer portal <https://portal.nextron-systems.com>`__.

.. important::
   API functionality needs to be activated by Nextron. Please contact support/sales
   to activate the API functionality.

.. figure:: ../images/portal_api_key.png
   :alt: Settings > API Key

   Settings > API Key

You can retrieve an appropriate THOR license at the scan start using the built-in
``--portal-api-key`` and ``--portal-contracts`` parameters. The ``--portal-contracts``
parameter is optional. It can be used to take licenses from a specific contract in
case you have more than one and want to use a specific one. If none is set, THOR
will automatically retrieve licenses from a contract of the right type. (e.g.
retrieve workstation license from the first still valid contract that has
workstation licenses available)

.. figure:: ../images/portal_contract_ids.png
   :alt: Contracts IDs in Customer Portal

   Contract IDs in Customer Portal

You can then use the parameters as shown in the following examples:

.. code-block:: doscon 

   C:\temp\thor>thor64.exe --portal-api-key IY5Y36thrt7h1775tt1ygfuYIadmGzZJmVk32lXcud4

.. code-block:: doscon 

   C:\temp\thor>thor64.exe --portal-api-key IY5Y36thrt7h1775tt1ygfuYIadmGzZJmVk32lXcud4 --portal-contracts 3,5

If everything works as expected, you'll see an **INFO** level message in the output that looks like: 

.. code-block:: none 

   Info License file found LICENSE: portal.nextron-systems.com OWNER: ACME Inc TYPE: Workstation STARTS: 2021/06/23 EXPIRES: 2021/06/30 SCANNER: All Scanners VALID: true REASON:

You can specify a proxy by setting the ``HTTP_PROXY`` and ``HTTPS_PROXY`` environment variables, e.g. to ``my-proxy.internal:3000``.

Username and password can be specified as part of the proxy URL as ``http://username:password@host:port/``.

.. hint::
   If you want to automate license generation and retrieval via the Portal
   any other way, please use the built in API Documentation in the Portal.