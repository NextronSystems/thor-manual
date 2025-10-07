.. Index:: Help Us Debugging

Help Us With The Debugging
--------------------------

If you cannot find the source of a problem, please contact us using the
support@nextron-systems.com email address.

You can help us find and debug the problem as quickly as possible by
providing the following information.

Which THOR version do you use?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tell us the exact THOR version you are using:

1. For which operating system (Windows, Linux, macOS, AIX)
2. For which architecture (32bit, 64bit)

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

What is the target platform that THOR fails on?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Which command line arguments do you use?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please provide a complete list of command line arguments that you've used
when the error occurred.

.. code-block:: doscon

   C:\thor>thor64.exe --quick -e D:\logs -p C:\Windows\System32

Provide a diagnostics pack or crash output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If THOR is still running (but hanging), make sure to follow the steps in
:ref:`debugging/diag:diagnostics pack`. If THOR crashed and
printed some error messages like the "out of memory" message above,
make sure to copy those and include them in your bug report.

Provide the log of a scan with the ``--debug`` flag (optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The most important element is a scan log of a scan with the ``--debug``
flag used.

The easiest way is to run the scan exactly as you've run it when the
problem occurred adding the ``--debug`` command line flag.

.. code-block:: doscon

   C:\thor>thor64.exe --quick -e D:\logs -p C:\Windows\System32 --debug

If you're able to pinpoint the error to a certain module, you could limit
the scan to that module to get to the problematic element more quickly.

.. code-block:: doscon

   C:\thor>thor64.exe -a Rootkit --debug

After the scan you will find the normal text log (\*.txt) in the program folder.
It is okay to replace confidential information like the hostname or IP addresses.

Note: The debug log files can be pretty big, so please compress the file before
submitting it to us. Normal log files have a size between 1 and 4 MB. Scans started
with the ``--debug`` flag typically have sizes of 30-200 MB. The compression ratio is
typically between 2-4%, so a compressed file shouldn't be larger than 10 MB.

Provide a Screenshot (Optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sometimes errors lead to panics of the executables, which causes the situation
in which relevant log lines don't appear in the log file. In these cases, please
also create a screenshot of a panic shown in the command line window.

Provide the THOR database (Optional)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The :ref:`other/thordb:THOR DB` helps us debug situations in which
the THOR scan timed out or didn't complete at all. It contains statistics on the
run time of all used modules and the durations of all folders up to the second
folder level from the root of a partition. (e.g. ``C:\Windows\SysWow64``).

The default location of that file is:

* Windows: ``C:\ProgramData\thor\thor10.db``
* Linux/macOS: ``/var/lib/thor/thor10.db``

Please provide that file in situations in which:

* THOR exceeded its maximum run time
* THOR froze and didn't complete a scan for days
* THOR scans take too long for the selected scan targets

Further Notes
^^^^^^^^^^^^^

* If the files are too big to send, even after compression, please contact
  us and you'll receive a file upload link that you can use
* If a certain file or element (eventlog, registry hive) caused the issue,
  please check if you can provide that file or element for our analysis, as those
  files can contain sensitive information.
