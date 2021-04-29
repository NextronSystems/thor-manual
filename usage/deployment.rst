Deployment
==========

This chapter lists different ways to deploy THOR in an environment. Most
of these methods are OS specific.

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
directly via its UNC path (e.g. \\\\server\\share\\thor.exe or \\\\server\\share\\thor64.exe).

.. figure:: ../images/image4.png
   :target: ../_images/image4.png
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
   the share, i.e. **\\\\fileserver\\thor\\**
2. Find the "thor\_remote.bat" batch file, which can be found in the
   “tools” sub folder, place it directly in the root of the program
   folder and adjust it to your needs.

   -  set the network share UNC path

   -  set the parameters for the THOR run (see chapter 7 "Scan")

You should then test the setting like this:

1. Connect to a remote system (Remote Desktop), which you would like to
   scan
2. | Start a command line "as Administrator"
   | (right click > Run as Administrator)
3. | Run the following command, which is going to mount a network drive,
     run THOR and disconnect the previously mounted drive:
   | **\\\\fileserver\\thor\\thor\_remote.bat**

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

.. code:: bash
   
   psexec \\\\server1 -u domain/admin -p pass schtasks /create /tn "THOR
   Run" /tr "\\\\server\\share\\thor\_remote.bat" /sc ONCE /st 08:00:00 /ru
   DOMAIN/FUadmin /rp password

Start THOR on the Remote System via WMIC
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

THOR can be started on a remote system via "wmic" using a file share
that serves the THOR package and is readable by the user that executes
the scan.


.. code:: bash
   
   wmic /node:10.0.2.10 /user:MYDOM\\scanadmin process call create "cmd.exe
   /c \\\\server\\thor10\\thor.exe"

ASGARD Management Center (Windows, Linux, macOS)
------------------------------------------------

ASGARD is the central management platform for THOR scans. It manages
distributed THOR scans on thousands of systems, collects, forwards and
analyses logs. Furthermore, ASGARD can control and execute complex
response tasks if needed. 

ASGARD comes in two variations: While ASGARD Management Center features
scan control and response functions, ASGARD Analysis Cockpit can be used
to analyse large amounts of scan logs through an integrated base-lining
and case management.  

The hardened, Linux-based ASGARD appliance is a powerful, solid and
scalable response platform with agents for Windows, Linux and MacOS. It
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
   :target: ../_images/image5.png
   :alt: ASGARD Management Center

   ASGARD Management Center

.. figure:: ../images/image6.png
   :target: ../_images/image6.png
   :alt: ASGARD IOC Management

   ASGARD IOC Management

Ansible (Linux)
---------------

Distribute Run with Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In practice it is crucial to execute Thor on many servers in a network.
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
of parallel executions is five and can be configured using the -f or
--forks parameter when starting the playbooks.

Execute Thor using Ansible
^^^^^^^^^^^^^^^^^^^^^^^^^^

The following section will show how to use a Ansible playbook to execute
Thor on multiple Linux systems.

It will perform following steps on each system:

* Create a temporary folder
* Mount a RAM drive using the folder as mountpoint
* Copy Thor to this RAM drive
* Execute Thor
* Unmount the RAM drive
* Delete the temporary folder

Inventory File
^^^^^^^^^^^^^^

First it is needed to define a list of hosts to execute Thor on. This is
done by setting up a YAML file with the hostnames or IP addresses of the
hosts. This file is later used with the -i parameter in the
ansible-playbook command. A simple version of this could look like
following:

.. code:: bash
   
   ---
   host1.com
   host2.com
   132.123.213.111

To learn more about Ansible inventory files and how to use them, please
refer to the official documentation:

https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html

Ansible Playbook Template
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash
   
   ---                                                                                                  
   - hosts: all  
   #remote\_user: root become: true tasks: 
   - name: Create folder for temporary RAM drive command: mkdir /mnt/temp\_ram creates=/mnt/temp\_ram 
   - name: Create Thor RAM drive on target                                  
   command: mount -t ramfs -o size=60M ramfs /mnt/temp\_ram/ ignore\_warnings: true                 
   -  name: Copy Thor to RAM drive                                                        
   copy: src=../thor-linux-pack/ dest=/mnt/temp\_ram/ ignore\_warnings: true     
   -  name: Make Thor Executeable                                                 
   file: path=/mnt/temp\_ram/thor-x64 state=touch                
   mode="0555"  
   - name: Execute Thor                                                                               
   command: /mnt/temp\_ram/thor64 -l /mnt/temp\_ram/thor.txt creates=/mnt/temp\_ram/thor.html         
   - name: Fetch Log file                                           
   fetch: src=/mnt/temp\_ram/thor.txt dest=../thoransible-      
   output/{{inventory\_hostname}}/thor.txt flat=true                   
   -  name: Unmount temporary RAM drive mount:   
   path: /mnt/temp\_ram        
   state: unmounted        
   -  name: check Mount  
   command: mount   
   -  name: Delete folder for temporary RAM drive   
   command: rmdir /mnt/temp\_ram/

Usage of Thor´s Ansible playbook
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy the playbook in the main directory of Thor. After this is done it
can be started as follows:

.. code:: bash

   ansible-playbook -f <number\_of\_parallel\_executions> -i <inventory\_file> thorplaybook.yml

After the playbook finished running the scans, the output of each system
can be found in the **thoransible**-output directory located at the
parent directory of thor. Therefor it is important that the user
starting ansible-playbook has the required rights to write in this
directory.

Adjust Thor's Command Line Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Per default this playbook will only start Thor with the parameter that
defines the output log file. This can be changed in the playbook in the
„Execute Thor“-Task. However, it should be kept in mind, that changing
the output log file is not recommended, since the later tasks of the
playbook depend on this.

THOR Thunderstorm Service
-------------------------

The command line flag "**--thunderstorm**" starts THOR as a RESTful web
service on a given network interface and port. This service receives
samples and returns a scan result.

.. figure:: ../images/image7.png
   :target: ../_images/image7.png
   :alt: THOR Thunderstorm Overview

   THOR Thunderstorm Overview

The service can be started in two scan modes: 

* Pure YARA
* Full-Featured

In the pure YARA mode (**--pure-yara**) THOR Thunderstorm only applies
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

It is recommended to use “pure-yara” mode in cases in which:

* huge forensic artefacts (EVTX or memory dump files) appear on the source systems and overload the Thunderstorm service
* deeper forensic parsing, IOC matching or other internal THOR checks aren’t needed or wanted

The following table contains all THOR Thunderstorm related command line
flags:

.. list-table:: 
   :header-rows: 1
  
   * - Parameter
     - Values 
     - Function
   * - --thunderstorm
     - 
     - | Watch and scan all files sent to a specific port (see
       | --server-port). Disables resource checks and quick    
       | mode, activate intense mode, disable ThorDB and 
       | apply IOCs platform independently 	
   * - --server-host
     - ip-address
     - | IP address that THOR's server should bind to 
       | (default "127.0.0.1")
   * - --server-port 
     - port number
     - | TCP port that THOR's server should bind to 
       | (default 8080)
   * - --server-cert
     - .crt location
     - | TLS certificate that THOR's server should use. If
       | left empty, TLS is not used
   * - --server-key
     - .key location
     - | Private key for the TLS certificate that THOR's 
       | server should use. Required if --server-cert is 
       | specified
   * - --pure-yara 
     - 
     - | Apply only YARA signatures (no IOCs or other
       | programmatical checks)
   * - --server-upload-dir 
     - upload-directory
     - | Path to a temporary directory where THOR drops
       | uploaded files. Only relevant for Windows and 
       | MacOS; on Linux, THOR stores files in in-memory 
       | files. (default "/tmp/thor-uploads")
   * - --server-result-cache-size
     - number of results
     - | Size of the cache that is used to store results of
       | asynchronous requests temporarily. If set to 0, the 
       | cache is disabled and asynchronous results are not
       | stored. (default 10000)
   * - --server-store-samples
     - all/malicious/none
     - | Sets whether samples should be stored 
       | permanently in the folder specified with 
       | --server-upload-dir. Specify "all" to store all 
       | samples, or "malicious" to store only samples that
       | generated a warning or an alert. (default "none")
   * - --sync-only-threads
     - number of threads
     - | Number of threads reserved for synchronous 
       | requests (only needed in environments in which 
       | users use both synchronous and asynchronous 
       | mode of transmission)
   * - --threads
     - number of threads
     - | Number of threads that the Thunderstorm service 
       | should use (default: number of detected CPU 
       | cores)


Service License Type
^^^^^^^^^^^^^^^^^^^^

To run THOR in Thunderstorm service mode, you need a special license
type named „Service License” that allows this mode of operation.

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

It can be installed with: **pip install thunderstormAPI**

Thunderstorm API Documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An API documentation is integrated into the web service.

Simply visit the service URL, e.g.: http://my-server:8080/

.. figure:: ../images/image8.png
   :target: ../_images/image8.png
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

.. code:: bash

   wget -O - https://raw.githubusercontent.com/NextronSystems/nextron-helper-scripts/master/thunderstorm/thunderstorm-installer.sh \| bash

Everything else will automatically be handled by the installer script.
It even supports an “uninstall” flag to remove all files and folders
from the system to get the system clean again after a successful
proof-of-concept.

.. figure:: ../images/image9.png
   :target: ../_images/image9.png
   :alt: Thunderstorm Service Installer

   Thunderstorm Service Installer

After the installation, the configuration file is located in
**/etc/thunderstorm**.

The log file of the service can be found in **/var/log/thunderstorm**.

Thunderstorm Update
^^^^^^^^^^^^^^^^^^^

The Thunderstorm service gets updated just as THOR does. Use “thor-util
update” to update signatures or “thor-util upgrade” to update binaries
and signatures. The service has to be stopped during the updates.

Update signatures:

.. code:: bash

   thor-util update 

Upgrade signatures:

.. code:: bash

   thor-util upgrade

See the “thor-util” manual for details on how to use these functions.

Thunderstorm Update Script
~~~~~~~~~~~~~~~~~~~~~~~~~~

The Thunderstorm installer script for Linux automatically places an
updater script in the PATH of the server system.

https://github.com/NextronSystems/nextron-helper-scripts/tree/master/thunderstorm

Update binaries and signatures:

.. code:: bash

   thunderstorm-update

Stop service, update binaries and signatures, restart
service:

.. code:: bash

   thunderstorm-update full

Source Identification
^^^^^^^^^^^^^^^^^^^^^

The log file generated by THOR Thunderstorm doesn’t contain the current
host as hostname in each line. By default, it contains the sending
source’s FQDN or IP address if a name cannot be resolved using the
locally configured DNS server.

However, every source can set a “source” value in the request and
overwrite the automatically evaluated hostname. This way users can use
custom values that are evaluated or set on the sending on the end
system.

.. code:: bash

   curl -X POST "http://myserver:8080/api/check?source=test" -F "file=@sample.exe"

Synchronous and Asynchronous Mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It is also important to mention that THOR Thunderstorm supports two ways
to submit samples, a synchronous and an asynchronous mode.

The default is synchronous submission. In this mode, the sender waits
for the scan result, which can be empty in case of no detection or
contains match elements in cases in which a threat could be identified.

In asynchronous mode, the submitter doesn’t wait for the scan result but
always gets a send receipt with an id, which can just be discarded or
used to query the service at a later point in time. This mode is best
for use cases in which the submitter doesn’t need to know the scan
results and batch submission should be as fast as possible.

.. list-table:: 
   :header-rows: 1

   * -
     - Synchronous
     - Asynchronous
   * - Server API Endpoint
     - /api/check
     - /api/checkAsync
   * - | ThunderstormAPI Client
       | Parameter
     -
     - --asyn
   * - Advantage
     - Returns Scan Result
     - Faster submission
   * - Disadvantage
     - | Client waits for result of each
       | sample
     - | No immediate scan result on the
       | client side

In asynchronous mode, the Thunderstorm service keeps the samples in a
queue on disk and processes them one by one as soon as a thread has time
to scan them. The number of files in this queue can be queried at the
status endpoint **/api/status** and checked on the landing page of the
web GUI.

In environments in which the Thunderstorm service is used to handle
synchronous and asynchronous requests at the same time, it is possible
that all threads are busy processing cached asynchronous samples and not
more synchronous requests are possible.

In this case use the **--sync-only-threads** flag to reserve a number of
threads for synchronous requests. (e.g. **--threads 40
--sync-only-threads 10**)

Performance Tests
^^^^^^^^^^^^^^^^^

Performance tests showed the differences between the two submission
modes.

In Synchronous mode, sample transmission and server processing take
exactly the same time since the client always waits for the scan result.
In asynchronous mode, the sample transmission takes much less time, but
the processing on the server takes a bit longer, since the sever caches
the samples on disk.

+-----------------------+---------------+----------------+
|                       | Synchronous   | Asynchronous   |
+=======================+===============+================+
| Client Transmission   | 40min         | 18min          |
+-----------------------+---------------+----------------+
| Server Processing     |               | 46min          |
+-----------------------+---------------+----------------+
| Total Time            | 40min         | 46min          |
+-----------------------+---------------+----------------+

SSL/TLS
^^^^^^^

We do not recommend the use of SSL/TLS since it impacts the submission
performance. In cases in which you transfer files through networks with
IDS/IPS appliances, the submission in an SSL/TLS protected tunnel
prevents IDS alerts and connection resets by the IPS.

Depending on the average size of the samples, the submission frequency
and the number of different sources that submit samples, the
transmission could take up to twice as much time.

Note: The thunderstormAPI client doesn’t verify the server’s certificate
by default as in this special case, secrecy isn’t important. The main
goal of the SSL/TLS encryption is an obscured method to transport
potentially malicious samples over network segments that could be
monitored by IDS/IPS systems. You can activate certificate checks with
the **--verify** command line flag or **verify** parameter in API
library’s method respectively.

THOR Remote
-----------

THOR Remote is a quick method to distribute THOR in a Windows
environment. It has been developed during an incident response and can
be considered as a clever hack that makes use of PsExec to push and
execute THOR with certain parameters on remote systems.

Requirements:

* Administrative Domain Windows user account with access rights on the target systems
* | Reachability of the target systems (Windows Ports)
  | 135/tcp für SCM (Service Management)
  | 445/tcp für SMB (Mounting)
* A list of target systems

Advantages:

* Agent-less
* Comfortable scanning without scripting
* Quick results (useful in incident response scenarios)

Disadvantages:

* Requires reachability of Windows ports
* User credentials remain on the target system if it is used with explicit credentials (NTLM Auth) and the users doesn’t already use an account that has access rights on target systems (Kerberos Auth)

Usage
^^^^^

A list of parameters used with the remote scanning function can be found
in the help screen.

.. figure:: ../images/image10.png
   :target: ../_images/image10.png
   :alt: THOR Remote Usage

   THOR Remote Usage

As you can see, a list of target hosts can be provided with the help of
the new YAML config files. See chapter 10 “Configuration Files” for more
details.

A YAML file with a list of hosts looks like this:

+------------------------+
| remote:                |
| - winatl001.dom.int    |
| - winatl002.dom.int    |
| - winnyk001.dom2.int   |
+------------------------+


We recommend using a text editor that supports multi-line editing like
Atom or Sublime.

https://atom.io/

https://stackoverflow.com/questions/39391688/multi-line-editing-on-atom

You can then use that file with:

.. code:: batch
   
   thor64.exe -t targets.yml

Licensing
^^^^^^^^^

Valid licenses for all target systems are required. Place them in the
program folder or any sub folder within the program directory (e.g.
**./licenses**). In case of incident response licenses, just place that
single license in the program folder.

You don’t need a valid license for the system that runs THOR’s remote
scanning feature (the source system of the scans, e.g. admin
workstation).

Output
^^^^^^

The generated log files are collected and written to the folder
**./remote-logs**

The “THOR Remote” function has its own interface, which allows you to
view the progress of the scans, view and scroll through the log files of
the different remote systems.

.. figure:: ../images/image11.png
   :target: ../_images/image11.png
   :alt: THOR Remote Interface I

.. figure:: ../images/image12.png
   :target: ../_images/image12.png
   :alt: THOR Remote Interface II

   THOR Remote Interface

Issues
^^^^^^

System Error 5 occurred – Access Denied
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See:
https://helgeklein.com/blog/2011/08/access-denied-trying-to-connect-to-administrative-shares-on-windows-7/

Running THOR from a Network Share
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

THOR must reside on the local filesystem of the source system. Don’t run
it from a mounted network share. This could lead to the following error:

.. code:: bash
   
   CreateFile .: The system cannot find the path specified.

Using Templates and Other Absolute Paths
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Distribute to Offline Networks / Field Offices
----------------------------------------------

The quickest and most simple way to run THOR is by providing the ZIP
archive to the colleagues in the remote location, letting them run the
THOR executable and collect the report files afterwards.

The most usable format in this use case is the HTML report if only a few
reports have to be analyzed. If the number of collected reports is high,
we recommend using ASGARD Analysis Cockpit or Splunk with the free App
and Add-on.

ASGARD Analysis Cockpit

https://portal.nextron-systems.com/webshop/downloads

THOR APT Scanner App

https://splunkbase.splunk.com/app/3717/

THOR Add-On

https://splunkbase.splunk.com/app/3718/

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
