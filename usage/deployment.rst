Deployment
==========

This chapter lists different ways to deploy THOR in an environment. Most
of these methods are OS specific.

Licensing
---------

In almost any method of deployment, the provision of valid licenses for the scanners on the endpoints is a core issue.
Every license is limited to a certain host name. The only exception are the rare and relatively expensive "Incident Response" licenses.

In all other cases, a valid license has to be generated before a scan run.

There are numerous options to retrieve a valid license for a host.

With ASGARD:

* use an ASGARD Agent
* download THOR package with license from ASGARD's ``Downloads`` section
* generate licenses in ASGARD's web GUI under ``Licensing > Generate Licenses``
* use THOR's ``--asgard`` and ``--asgard-token`` parameters to retrieve a license
* use ASGARD's API to retrieve a license manually

Without ASGARD: 

* generate a license in the web GUI of the `customer portal <https://portal.nextron-systems.com>`__
* use THOR's ``--portal-key`` and ``--portal-contracts`` parameters to retrieve a license from the customer portal
* use the Customer Portal's API to retrieve a license manually

Some of the options are described in more detail in the following two chapters.

Retrieve Valid License From ASGARD
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use THOR's ``--asgard`` and ``--asgard-token`` parameters
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

In ASGARD 2.5+ you're able to configure a download token to limit the download of
THOR packages and licenses to clients with knowledge of this token. The token is
a protection that no one without knowledge of that token can intentionally exceed
your license quota limit or retrieve a THOR package without authorization.

The download token can be configured in the ``Downloads`` section of you ASGARD server.

.. figure:: ../images/download-token.png
   :alt: Downloads > Download Token Configuration

   Downloads > Download Token Configuration

You can retrieve an appropriate THOR license at the scan start using the built-in ``--asgard`` and ``--asgard-token`` parameters.

.. code-block:: doscon 

   C:\temp\thor>thor64.exe --asgard my-asgard.internal

.. code-block:: doscon 

   C:\temp\thor>thor64.exe --asgard my-asgard.internal --asgard-token OCU92GW1CyOJLzaHkGrim1v2O0_ZkHPu0A

If everything works as expected, you'll see an INFO level message in the output that looks like: 

.. code-block:: batch 

   Info: Init License file found LICENSE: my-asgard.internal OWNER: Master ASGARD: ACME Inc TYPE: Workstation STARTS: 2021/06/18 EXPIRES: 2022/06/18 SCANNER: All Scanners VALID: true REASON:

Use ASGARD's API to retrieve a license manually
"""""""""""""""""""""""""""""""""""""""""""""""

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

If there is uncertainty it's recommended to generate ``server`` type licenses which are
more expensive but run on both system types.

For example: To retrieve a valid license for the servers named ``SRV001`` and ``SRV002``
you can use the following command:

.. code-block:: console 

   nextron@unix:~$ curl -XPOST "https://my-asgard.internal:8443/api/v0/licensing/issue?token=OJCBaTq4VGLjrCes2k4ACCQOzg0AxAoz01" -o licenses.zip -d "type=server" -d "hostnames=SRV001" -d "hostnames=SRV002" ... -d "hostnames=hostnameN"

If you can't use curl and want to retrieve a license as part of a bigger PowerShell script,
you can use the following code snippet to help you with the retrieval.

.. literalinclude:: ../examples/asgard-license-gen.ps1
   :language: powershell
   :linenos:

Check the ASGARD helper scripts section in
`our Github repo <https://github.com/NextronSystems/nextron-helper-scripts/tree/master/asgard>`__
for more scripts and snippets.

Retrieve Valid License From Customer Portal
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use THOR's ``--portal-key`` and ``--portal-contracts`` parameters to retrieve a license
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

To retrieve a licenses from the customer portal, you need a portal key. The portal key
(API key) can be configured in the ``My Settings > API Key`` section of the
`customer portal <https://portal.nextron-systems.com>`__.

.. figure:: ../images/portal-api-key.png
   :alt: My Settings > API Key

   My Settings > API Key

You can retrieve an appropriate THOR license at the scan start using the built-in
``--portal-key`` and ``--portal-contracts`` parameters. The ``--portal-contracts``
parameter is optional. It can be used to take licenses from a specific contract in
case you have more than one and want to use a specific one. If none is set, THOR
will automatically retrieve licenses from a contract of the right type. (e.g.
retrieve workstation license from the first still valid contract that has
workstation licenses available)

.. figure:: ../images/portal-ids.png
   :alt: Contracts IDs in Customer Portal

   Contract IDs in Customer Portal

You can then use the parameters as shown in the following examples:

.. code-block:: doscon 

   C:\temp\thor>thor64.exe --portal-key IY5Y36thrt7h1775tt1ygfuYIadmGzZJmVk32lXcud4

.. code-block:: doscon 

   C:\temp\thor>thor64.exe --portal-key IY5Y36thrt7h1775tt1ygfuYIadmGzZJmVk32lXcud4 --portal-contracts 3,5

If everything works as expected, you'll see an **INFO** level message in the output that looks like: 

.. code-block:: none 

   Info License file found LICENSE: portal.nextron-systems.com OWNER: ACME Inc TYPE: Workstation STARTS: 2021/06/23 EXPIRES: 2021/06/30 SCANNER: All Scanners VALID: true REASON:

You can specify a proxy by setting the ``HTTP_PROXY`` and ``HTTPS_PROXY`` environment variables, e.g. to ``my-proxy.internal:3000``.

Username and password can be specified as part of the proxy URL as ``http://username:password@host:port/``.

Use the Customer Portal's API to retrieve a license manually
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

This is a bit more complicated as we've decided long ago that our customer portal will
never contain personal or otherwise relatable information and this includes any kind
of hostnames - not even in memory. Therefore it's necessary to generate a HMAC SHA1
hash of the lowercased hostname on the client side and include only the hash in the
request to our customer portal.

This command generates a HMAC SHA1 of the current host you're working on. If you'd
like to generate a license for a different host, simply replace the first part
of the command with ``echo -n "mycustomname"``.

.. code-block:: console

   nextron@unix:~$ echo -n "$(hostname -s)" | tr '[:upper:]' '[:lower:]' | openssl dgst -binary -sha1 -mac hmac -macopt hexkey:b190dd4a98456999b6d9c7e4e1ac1f231b978c3e7652898d7db2fcdede34613dbc7909c9fc8b3177bb904871b8b7fc7a30cb1582ce9b0089397836dcc209e2d6 | base64 | tr '/+' '_-' | tr -d '='

The values needed for a successful request are: 

* ``$CONTRACT`` = contract id (set to ``0`` for automatic selection)
* ``$TYPE`` = [server/client]
* ``$HASH`` = the hash generated from the hostname in the previous step
* ``$APIKEY`` = the API from the ``User Settings`` section in the customer portal

.. code-block:: console 

   nextron@unix:~$ curl -XPOST https://portal.nextron-systems.com/api/public/contracts/issue/$CONTRACT/$TYPE/$HASH?download=1 -H "Authorization: $APIKEY" -o license.lic

A valid license is an encrypted blob of at least 800 bytes. You can check the content of the license for possible error message that came back from the server using ``xxd``.

.. code-block:: console 

   nextron@unix:~$ xxd license.lic

If you find a ``Error: HTTP-401`` in the file, than you've most likely used an invalid API key.

Network Share (Windows)
-----------------------

THOR is a lightweight tool that can be deployed in many different ways.
It does not require installation and leaves only a few temporary files
on the target system.

A lightweight deployment option provides the THOR program folder on a
read-only network share and makes it accessible from all systems within
the network. Systems in DMZ networks can be scanned manually by
transferring a THOR program package to the system and run it from the
command line. The locally written log files have the same format as the
Syslog messages sent to remote SIEM systems and can be mixed without any
problem.

We often recommend triggering the scan via "Scheduled Task" distributed
to the systems via GPO or PsExec. The servers access the file share at a
given time, pull THOR into memory and start the scan process. You can
either mount the network share and run THOR from there or access it
directly via its UNC path (e.g. ``\\server\share\thor.exe`` or ``\\server\share\thor64.exe``).

.. figure:: ../images/image4.png
   :alt: Deployment via Network Share

   Deployment via Network Share

Place THOR on a Network Share
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A good way to run THOR on multiple systems is by defining a "Scheduled
Task" using your Windows domain's group policy functionality.

The preferred way to run THOR on a remote system is by providing a
network share on which the extracted THOR package resides. You can use
this directory as the output directory but it is recommended to create
another share with write permissions especially for the HTML and TXT
result files. The share that holds the THOR program folder should be
read-only. The various output files must be disabled or defined in
different locations in order to avoid write-access errors.

The necessary steps are:

1. Create a network share and extract the THOR package into the root of
   the share, i.e. ``\\fileserver\thor\``
2. Find the "thor\_remote.bat" batch file, which can be found in the
   "tools" sub folder, place it directly in the root of the program
   folder and adjust it to your needs.

   -  set the network share UNC path

   -  set the parameters for the THOR run (see :ref:`usage/scan:scan`)

You should then test the setting like this:

1. Connect to a remote system (Remote Desktop), which you would like to
   scan
2. Start a command line "as Administrator" (right click > Run as Administrator)
3. Run the following command, which is going to mount a network drive,
   run THOR and disconnect the previously mounted drive:
   ``\\fileserver\thor\thor_remote.bat``

After a successful test run, you decide on how to invoke the script on
the network drive. The following chapters list different options.

Create a Scheduled Task via GPO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In a Windows Domain environment, you can create a Scheduled Task and
distribute this Scheduled Task via GPO. This Scheduled Task would invoke
the batch file on the network share and runs THOR. Make sure that the
respective user account has the rights to mount the configured network
share.

| You can find more information here:
| https://technet.microsoft.com/en-us/library/cc725745.aspx

Create a Scheduled Task via PsExec
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This method uses Sysinternals PsExec and a list of target systems to
connect and create a Scheduled Task via the command line. This could
look like the following example:

.. code-block:: doscon
   
   C:\temp\thor>psexec \\server1 -u domain/admin -p pass schtasks /create /tn "THOR Run" /tr "\\server\share\thor_remote.bat" /sc ONCE /st 08:00:00 /ru DOMAIN/FUadmin /rp password

Start THOR on the Remote System via WMIC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

THOR can be started on a remote system via "wmic" using a file share
that serves the THOR package and is readable by the user that executes
the scan.


.. code-block:: doscon
   
   C:\temp\thor> wmic /node:10.0.2.10 /user:MYDOM\scanadmin process call create "cmd.exe /c \\server\thor10\thor.exe"

ASGARD Management Center (Windows, Linux, macOS)
------------------------------------------------

ASGARD is the central management platform for THOR scans. It manages
distributed THOR scans on thousands of systems, collects, forwards and
analyses logs. Furthermore, ASGARD can control and execute complex
response tasks if needed.

ASGARD comes in two variations: While ASGARD Management Center features
scan control and response functions, ASGARD Analysis Cockpit can be used
to analyze large amounts of scan logs through an integrated base-lining
and case management.

The hardened, Linux-based ASGARD appliance is a powerful, solid and
scalable response platform with agents for Windows, Linux and macOS. It
provides essential response features like the collection of files,
directories and main memory, remote file system browsing and other
counteractive measures.

It features templates for scan runs and lets you plan and schedule
distributed sweeps with the lowest impact on system resources. Other
services are:

* **Quarantine Service** - file quarantine via Bifrost protocol
* **Update Service** - automatic updates for THOR scanners
* **License Service** - central registration and sub license generation
* **Asset Management Service** - central inventory and status dashboard
* **IOC Management** – manage and scan with custom IOC and YARA rule sets
* **Evidence Collection** – collect evidences (files and memory) from asset

.. figure:: ../images/image5.png
   :alt: ASGARD Management Center

   ASGARD Management Center

.. figure:: ../images/image6.png
   :alt: ASGARD Response Control

   ASGARD Response

Ansible (Linux)
---------------

Distribute Run with Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In practice it is crucial to execute THOR on many servers in a network.
A possible way to achieve this is described within this paper, taking
into account that the footprint on the target should be minimal and that
the procedure should not depend on the used Linux Distribution.

Ansible
^^^^^^^

The software Ansible (https://www.ansible.com) is a solution to perform
tasks distributed over a network on different targets. An Open Source
Version is available as well as a version with commercial support for
enterprises. Ansible uses SSH to connect to the target hosts and
performs a defined set of tasks on them called playbooks. Per default it
uses keys for authentication, but this can be setup differently. Please
refer to the official documentation for other methods of
authentication. The tasks and the targets can be customized using
host groups. The host groups may be used to separate different Linux
distributions. The other steps may remain the same. Within the playbook
any command line option may be customized for the given scenario.

Ansible does parallelization of the tasks by itself. The default amount
of parallel executions is five and can be configured using the ``-f`` or
``--forks`` parameter when starting the playbooks.

Execute THOR using Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^

The following section will show how to use an Ansible playbook to execute
THOR on multiple Linux systems.

It will perform following steps on each system:

* Create a temporary folder
* Mount a RAM drive using the folder as mount point
* Copy THOR to this RAM drive
* Execute THOR
* Unmount the RAM drive
* Delete the temporary folder

Inventory File
^^^^^^^^^^^^^^

First it is needed to define a list of hosts to execute THOR on. This is
done by setting up a YAML file with the hostnames or IP addresses of the
hosts. This file is later used with the -i parameter in the
ansible-playbook command. A simple version of this could look like
following:

.. code-block:: yaml
   
   ---
   host1.com
   host2.com
   132.123.213.111

To learn more about Ansible inventory files and how to use them, please
refer to the official documentation:

https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html

Ansible Playbook Template
^^^^^^^^^^^^^^^^^^^^^^^^^

.. literalinclude:: ../examples/ansible-template.yml
   :language: yaml
   :linenos:

Usage of THOR's Ansible playbook
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy the playbook in the main directory of THOR. After this is done it
can be started as follows:

.. code-block:: console

   nextron@unix:~$ ansible-playbook -f <number_of_parallel_executions> -i <inventory_file> thorplaybook.yml

After the playbook finished running the scans, the output of each system
can be found in the **thoransible**-output directory located at the
parent directory of THOR. Therefor it is important that the user
starting ansible-playbook has the required rights to write in this
directory.

Adjust THOR's Command Line Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Per default this playbook will only start THOR with the parameter that
defines the output log file. This can be changed in the playbook in the
"Execute THOR"-Task. However, it should be kept in mind, that changing
the output log file is not recommended, since the later tasks of the
playbook depend on this.

THOR Thunderstorm Service
-------------------------

The command line flag ``--thunderstorm`` starts THOR as a RESTful web
service on a given network interface and port. This service receives
samples and returns a scan result.

.. figure:: ../images/image7.png
   :alt: THOR Thunderstorm Overview

   THOR Thunderstorm Overview

The service can be started in two scan modes:

* Pure YARA
* Full-Featured

In the pure YARA mode (``--pure-yara``) THOR Thunderstorm only applies
the 13,000 internal and all custom YARA rules to the submitted samples.
It's lightweight and fast.

The full-featured mode is the default. In this mode Thunderstorm also
parses and analyses Windows Eventlogs (EVTX), registry hives, memory
dumps, Windows error reports (WER) and more. It's not just a YARA scan,
but a full forensic processing.

Under normal circumstances, we recommend using the full-featured mode,
since most files are not of a type that triggers an intense parsing
function, the processing speed should be similar to the “pure-yara”
mode.

It is recommended to use "pure-yara" mode in cases in which:

* huge forensic artefacts (EVTX or memory dump files) appear on the source systems and overload the Thunderstorm service
* deeper forensic parsing, IOC matching or other internal THOR checks aren't needed or wanted

The following table contains all THOR Thunderstorm related command line
flags:

.. csv-table::
  :file: ../csv/thunderstorm.csv
  :widths: 30, 25, 45
  :delim: ;
  :header-rows: 1

Service License Type
^^^^^^^^^^^^^^^^^^^^

To run THOR in Thunderstorm service mode, you need a special license
type named "Service License" that allows this mode of operation.

After the launch of THOR Thunderstorm, we may allow other license types
to run THOR in service mode for a limited period of time, so that
customers can test the service and its integration into other solutions.

Thunderstorm Collectors
^^^^^^^^^^^^^^^^^^^^^^^

Thunderstorm API Client
^^^^^^^^^^^^^^^^^^^^^^^

We provide a free and open source command line client written in Python
to communicate with the Thunderstorm service.

https://github.com/NextronSystems/thunderstormAPI

It can be installed with:

.. code-block:: console

   nextron@unix:~$ pip install thunderstormAPI

Thunderstorm API Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An API documentation is integrated into the web service.

Simply visit the service URL, e.g.: :samp:`http://my-server:8080/`

.. figure:: ../images/image8.png
   :alt: Thunderstorm API documentation

   Thunderstorm API documentation

Server Installer Script for Linux
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A script that facilitates the installation on Linux systems can be found
in our github repository.

https://github.com/NextronSystems/nextron-helper-scripts/blob/master/thunderstorm/thunderstorm-installer.sh

The installation of a full THOR Thunderstorm server requires only two
steps.

1. Download and place a THOR Service license file in the current working
   directory

2. Run the following command

.. code-block:: console

   nextron@unix:~$ wget -O - https://raw.githubusercontent.com/NextronSystems/nextron-helper-scripts/master/thunderstorm/thunderstorm-installer.sh | bash

.. warning:: 
   Please inspect scripts from the internet before executing them!

Everything else will automatically be handled by the installer script.
It even supports an “uninstall” flag to remove all files and folders
from the system to get the system clean again after a successful
proof-of-concept.

.. figure:: ../images/image9.png
   :alt: Thunderstorm Service Installer

   Thunderstorm Service Installer

After the installation, the configuration file is located in
``/etc/thunderstorm``.

The log file of the service can be found in ``/var/log/thunderstorm``.

Thunderstorm Update
^^^^^^^^^^^^^^^^^^^

The Thunderstorm service gets updated just as THOR does. Use "thor-util
update" to update signatures or "thor-util upgrade" to update binaries
and signatures. The service has to be stopped during the updates.

Update signatures:

.. code-block:: console

   nextron@unix:~$ thor-util update 

Upgrade signatures:

.. code-block:: console

   nextron@unix:~$ thor-util upgrade

See the `THOR Util Manual <https://thor-util-manual.nextron-systems.com>`_  manual for details on how to use these functions.

Thunderstorm Update Script
""""""""""""""""""""""""""

The Thunderstorm installer script for Linux automatically places an
updater script in the PATH of the server system.

https://github.com/NextronSystems/nextron-helper-scripts/tree/master/thunderstorm

Update binaries and signatures:

.. code-block:: console

   nextron@unix:~$ thunderstorm-update

Stop service, update binaries and signatures, restart
service:

.. code-block:: console

   nextron@unix:~$ thunderstorm-update full

Source Identification
^^^^^^^^^^^^^^^^^^^^^

The log file generated by THOR Thunderstorm doesn't contain the current
host as hostname in each line. By default, it contains the sending
source's FQDN or IP address if a name cannot be resolved using the
locally configured DNS server.

However, every source can set a “source” value in the request and
overwrite the automatically evaluated hostname. This way users can use
custom values that are evaluated or set on the sending on the end
system.

.. code-block:: console

   nextron@unix:~$ curl -X POST "http://myserver:8080/api/check?source=test" -F "file=@sample.exe"

Synchronous and Asynchronous Mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It is also important to mention that THOR Thunderstorm supports two ways
to submit samples, a synchronous and an asynchronous mode.

The default is synchronous submission. In this mode, the sender waits
for the scan result, which can be empty in case of no detection or
contains match elements in cases in which a threat could be identified.

In asynchronous mode, the submitter doesn't wait for the scan result but
always gets a send receipt with an id, which can just be discarded or
used to query the service at a later point in time. This mode is best
for use cases in which the submitter doesn't need to know the scan
results and batch submission should be as fast as possible.

.. list-table::
   :header-rows: 1
   :widths: 30, 30, 40

   * - 
     - Synchronous
     - Asynchronous
   * - Server API Endpoint
     - /api/check
     - /api/checkAsync
   * - ThunderstormAPI Client Parameter
     -
     - --asyn
   * - Advantage
     - Returns Scan Result
     - Faster submission
   * - Disadvantage
     - Client waits for result of each sample
     - No immediate scan result on the client side


In asynchronous mode, the Thunderstorm service keeps the samples in a
queue on disk and processes them one by one as soon as a thread has time
to scan them. The number of files in this queue can be queried at the
status endpoint **/api/status** and checked on the landing page of the
web GUI.

In environments in which the Thunderstorm service is used to handle
synchronous and asynchronous requests at the same time, it is possible
that all threads are busy processing cached asynchronous samples and not
more synchronous requests are possible.

In this case use the ``--sync-only-threads`` flag to reserve a number of
threads for synchronous requests. (e.g. ``--threads 40
--sync-only-threads 10``)

Performance Tests
^^^^^^^^^^^^^^^^^

Performance tests showed the differences between the two submission
modes.

In Synchronous mode, sample transmission and server processing take
exactly the same time since the client always waits for the scan result.
In asynchronous mode, the sample transmission takes much less time, but
the processing on the server takes a bit longer, since the sever caches
the samples on disk.

.. list-table::
   :header-rows: 1
   :widths: 40, 30, 30

   * - 
     - Synchronous
     - Asynchronous
   * - Client Transmission
     - 40 minutes
     - 18 minutes
   * - Server Processing
     -
     - 46 minutes
   * - Total time
     - 40 minutes
     - 46 minutes

SSL/TLS
^^^^^^^

We do not recommend the use of SSL/TLS since it impacts the submission
performance. In cases in which you transfer files through networks with
IDS/IPS appliances, the submission in an SSL/TLS protected tunnel
prevents IDS alerts and connection resets by the IPS.

Depending on the average size of the samples, the submission frequency
and the number of different sources that submit samples, the
transmission could take up to twice as much time.

Note: The thunderstormAPI client doesn't verify the server's certificate
by default as in this special case, secrecy isn't important. The main
goal of the SSL/TLS encryption is an obscured method to transport
potentially malicious samples over network segments that could be
monitored by IDS/IPS systems. You can activate certificate checks with
the ``--verify`` command line flag or ``verify`` parameter in API
library's method respectively.

THOR Remote
-----------

THOR Remote is a quick method to distribute THOR in a Windows
environment. It has been developed during an incident response and can
be considered as a clever hack that makes use of PsExec to push and
execute THOR with certain parameters on remote systems.

Requirements:

* Administrative Domain Windows user account with access rights on the target systems
* Reachability of the target systems (Windows Ports):

  - 135/tcp for SCM (Service Management)

  - 445/tcp for SMB (Mounting)

* A list of target systems

Advantages:

* Agent-less
* Comfortable scanning without scripting
* Quick results (useful in incident response scenarios)

Disadvantages:

* Requires reachability of Windows ports
* User credentials remain on the target system if it is used with explicit credentials
  (NTLM Auth) and the users doesn't already use an account that has access rights on
  target systems (Kerberos Auth)

Usage
^^^^^

A list of parameters used with the remote scanning function can be found
in the help screen.

.. figure:: ../images/image10.png
   :alt: THOR Remote Usage

   THOR Remote Usage

As you can see, a list of target hosts can be provided with the help of
the new YAML config files. See :doc:`chapter Configuration <./configuration>` for more
details.

A YAML file with a list of hosts looks like this:

.. code-block:: yaml
   
   remote:
   - winatl001.dom.int
   - winatl002.dom.int
   - winnyk001.dom2.int

You can then use that file with:

.. code-block:: doscon
   
   C:\nextron\thor>thor64.exe -t targets.yml

THOR Remote Licensing
^^^^^^^^^^^^^^^^^^^^^

Valid licenses for all target systems are required. Place them in the
program folder or any sub folder within the program directory (e.g.
``./licenses``). In case of incident response licenses, just place that
single license in the program folder.

You don't need a valid license for the system that runs THOR's remote
scanning feature (the source system of the scans, e.g. admin
workstation).

.. hint::
   You can pair THOR Remote with the :ref:`usage/other-topics:license retrieval`
   options available within THOR, to make deployment easier.

Output
^^^^^^

The generated log files are collected and written to the folder
``./remote-logs``

The "THOR Remote" function has its own interface, which allows you to
view the progress of the scans, view and scroll through the log files of
the different remote systems.

.. figure:: ../images/image11.png
   :alt: THOR Remote Interface I

.. figure:: ../images/image12.png
   :alt: THOR Remote Interface II

   THOR Remote Interface

Issues
^^^^^^

System Error 5 occurred – Access Denied
"""""""""""""""""""""""""""""""""""""""

See:
https://helgeklein.com/blog/2011/08/access-denied-trying-to-connect-to-administrative-shares-on-windows-7/

Running THOR from a Network Share
"""""""""""""""""""""""""""""""""

THOR must reside on the local file system of the source system. Don't run
it from a mounted network share. This could lead to the following error:

.. code-block:: none
   
   CreateFile .: The system cannot find the path specified.

Distribute to Offline Networks / Field Offices
----------------------------------------------

The quickest and most simple way to run THOR is by providing the ZIP
archive to the colleagues in the remote location, letting them run the
THOR executable and collect the report files afterwards.

The most usable format in this use case is the HTML report if only a few
reports have to be analyzed. If the number of collected reports is high,
we recommend using ASGARD Analysis Cockpit or Splunk with the free App
and Add-on.

ASGARD Analysis Cockpit: https://portal.nextron-systems.com/webshop/downloads

THOR APT Scanner App: https://splunkbase.splunk.com/app/3717/

THOR Add-On: https://splunkbase.splunk.com/app/3718/

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
