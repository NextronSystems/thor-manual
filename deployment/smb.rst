.. Index:: Network Share

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

   -  set the parameters for the THOR run (see :ref:`scanning/using-thor:using thor`)

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
