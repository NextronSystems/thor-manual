.. Index:: Help Us Debug an Issue

Help Us Debug an Issue
----------------------

If you cannot identify the source of a problem, please contact us at
support@nextron-systems.com.

To help us investigate the issue as quickly as possible, please provide
the following information.

Which THOR version are you using?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tell us the exact THOR version you are using, including:

1. The operating system (``Windows``, ``Linux``, ``macOS``, or ``AIX``)
2. The architecture (``32-bit`` or ``64-bit``)

Run ``thor --version`` and copy the resulting text into the email.

On Windows:

.. code-block:: doscon

   C:\thor>thor64.exe --version
   THOR 11.0.0
   Build 95121a0 (2025-08-25 10:31:52) (windows, amd64)
   YARA 4.5.4
   PE-Sieve 0.4.1
   OpenSSL 3.1.3
   Signature Database 2025/08/29-110036
   Sigma Database r2025-07-08-33-geeca352f5

On Linux:

.. code-block:: console

   user@desktop:~$ ./thor-linux-64 --version
   THOR 11.0.0
   Build 95121a0 (2025-08-25 10:31:52) (linux, amd64)
   YARA 4.5.4
   PE-Sieve 0.4.1
   OpenSSL 3.1.3
   Signature Database 2025/08/29-110036
   Sigma Database r2025-07-08-33-geeca352f5

On macOS:

.. code-block:: console

   user@macos:~$ ./thor-macosx --version
   THOR 11.0.0
   Build 95121a0 (2025-08-25 10:31:52) (darwin, amd64)
   YARA 4.5.4
   PE-Sieve 0.4.1
   OpenSSL 3.1.3
   Signature Database 2025/08/29-110036
   Sigma Database r2025-07-08-33-geeca352f5

What is the target platform on which THOR fails?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please provide the output of the following commands.

On Windows:

.. code-block:: doscon

   C:\Users\user>systeminfo > systeminfo.txt

On Linux:

.. code-block:: console

   user@desktop:~$ uname -a

On macOS:

.. code-block:: console

   user@macos:~$ system_profiler -detailLevel mini > system_profile.txt

Which command-line arguments are you using?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please provide the full command line that you used when the issue
occurred.

.. code-block:: doscon

   C:\thor>thor64.exe --fast -e D:\logs -p C:\Windows\System32

Provide a diagnostics pack or crash output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If THOR is still running but appears to be hanging, follow the steps in
:ref:`debugging/diag:diagnostics pack`.

If THOR crashed and printed an error message such as ``out of memory``,
please copy that output and include it in your bug report.

Provide a scan log created with ``--debug`` (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

One of the most helpful artifacts is a scan log from a run with the
``--debug`` flag enabled.

The easiest way is to rerun the scan with the same parameters and add
``--debug``.

.. code-block:: doscon

   C:\thor>thor64.exe --fast -e D:\logs -p C:\Windows\System32 --debug

If you can narrow the issue down to a specific module, you can limit the
scan to that module to reach the problematic element more quickly.

.. code-block:: doscon

   C:\thor>thor64.exe -a Rootkit --debug

After the scan, you will find the text log (``*.txt``) in the program
folder. You can redact confidential information such as hostnames or IP
addresses.

Debug log files can be large, so please compress them before sending
them to us. Normal log files are usually between 1 and 4 MB. Scans run
with ``--debug`` typically produce logs of 30 to 200 MB. These files
usually compress well and should remain below 10 MB after compression.

Provide a screenshot (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some errors cause the executable to panic before the relevant log lines
are written to disk. In these cases, please also include a screenshot of
the command-line window.

Provide the THOR database (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :ref:`scanning/special-scan-modes:THOR DB` helps us investigate
cases in which a THOR scan timed out or did not complete. It contains
statistics about the run time of the modules used in the scan and the
durations of folders up to the second directory level from the root of a
partition, for example ``C:\Windows\SysWow64``.

The default location of that file is:

* Windows: ``C:\ProgramData\thor\thor10.db``
* Linux/macOS: ``/var/lib/thor/thor10.db``

Please provide that file in the following situations:

* THOR exceeded its maximum run time
* THOR froze and didn't complete a scan for days
* THOR scans take too long for the selected scan targets

Further Notes
^^^^^^^^^^^^^

* If the files are still too large to send after compression, contact us
  and we will provide an upload link.
* If a specific file or element, such as an event log or registry hive,
  caused the issue, please check whether you can provide it for our
  analysis. Such files can contain sensitive information.
