Upgrading to THOR 11
====================

This chapter helps THOR 10 users prepare for an upgrade to THOR 11.
It focuses on changes that affect existing scan configurations,
command lines, log processing, Thunderstorm integrations, and resource
planning. The other chapters in this manual continue to describe THOR 10.

.. note::
   Check the configuration reference and help included with the THOR 11
   package you intend to deploy.

Before You Upgrade
------------------

* Back up your ``config`` directory and any custom scan templates.
* Review the command lines used in scripts, scheduled scans, and
  deployment tools, including the configuration files they load.
* Start with the THOR 11 configuration and reapply only the settings you
  still need, using the new option names and value formats.
* Review log collectors, parsers, and Thunderstorm clients for the
  changed output and response formats.
* Test your intended scan settings on representative systems and check
  memory usage before a wider rollout.

For an initial evaluation, download a fresh THOR 11 TechPreview package:

.. code-block:: console

   thor-util download --techpreview -t thor-windows

Use ``thor-linux`` or ``thor-macos`` instead of ``thor-windows`` to
download a package for Linux or macOS. Extract the downloaded ZIP file
into a separate directory. This gives you the new configuration files
and lets you compare your existing settings before migrating them.

To upgrade an existing installation to the TechPreview version, run:

.. code-block:: console

   thor-util upgrade --techpreview

This preserves the existing configuration. Before upgrading, read
:ref:`usage/upgrade-to-thor11:Reinitialize the Default Configuration`
to decide whether to reset ``config/thor.yml`` during the upgrade.

On Windows, use ``thor-util.exe``; on Linux and macOS, use
``./thor-util`` when running the utility from its directory.

Command-Line and Configuration Compatibility
--------------------------------------------

THOR 11 reorganizes and renames many command-line options. Many THOR 10
names remain available as aliases, but an accepted option name does
not guarantee that its old value has the same meaning.

This also affects YAML configuration files because their keys correspond
to command-line options. Review both ``config/thor.yml`` and any custom
templates. Updating a script alone does not update the values in the
configuration files it loads.

Why an Existing Configuration Needs Attention
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

THOR 10 installations commonly contain settings such as:

.. code-block:: yaml

   max_file_size: 31457280
   max_file_size_intense: 209715200
   max_runtime: 168
   cpulimit: 95
   minmem: 50
   min: 40
   truncate: 2048

A regular ``thor-util upgrade`` preserves the existing configuration.
An upgrade in the same directory can therefore leave THOR 10 settings
active when you start THOR 11. THOR 11 prints a command-line message
when it detects an old configuration. Review that message and migrate
the settings before using the installation for regular scans.

Use explicit units for file sizes and memory values, for example
``file-size-limit: 64MB`` and ``memory-limit: 50MB``.
In particular, the old ``minmem: 50`` meant 50 MB of free memory;
the THOR 11 memory option interprets a bare number as bytes. Retaining
that old value does not preserve the intended free-memory threshold.

Reinitialize the Default Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

THOR Util provides ``upgrade --reinitialize-config`` to replace
``config/thor.yml`` with the default configuration from the downloaded
package.

.. warning::
   Reinitializing overwrites the settings in ``config/thor.yml``.
   Back up the file first, then reapply the custom settings you still
   need using THOR 11 syntax. This is a reset, not a conversion of your
   old settings. Review custom templates separately.

To upgrade to THOR 11 TechPreview and reset the default configuration,
run the following command from the THOR directory:

.. code-block:: console

   ./thor-util upgrade --reinitialize-config --techpreview

On Windows, use ``thor-util.exe`` instead of ``./thor-util``.

You can check whether your THOR Util version supports the reset option
with ``thor-util upgrade --help``. For general upgrade and package
selection options, see the
`THOR Util manual <https://thor-util-manual.nextron-systems.com/en/latest/usage/upgrade-and-updates.html>`__.

Use the New Configuration Reference
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

THOR 11 includes the following configuration files in the ``config`` directory:

* ``thor.yml`` is the default scan configuration. The supplied file
  contains commented examples of common settings. Leave these commented
  to use THOR's built-in defaults, or uncomment and adjust individual
  settings when you need an override.
* ``thor.yml.defaults`` lists the available configuration options, their
  defaults, and explanatory comments. Use it as a reference when
  choosing settings for ``thor.yml`` or a custom template. Its commented
  entries do not enable options by themselves.

The following table covers the common settings shown above. The THOR 11
column shows the supplied defaults, not a conversion that preserves
every THOR 10 value.

.. list-table:: Common configuration changes
   :header-rows: 1
   :widths: 28 30 42

   * - THOR 10 setting
     - THOR 11 setting and default
     - Migration note
   * - ``max_file_size``
     - ``file-size-limit: 64MB``
     - The default increases from 30 MB to 64 MB. Review any custom
       limit and write the intended size with an explicit unit.
   * - ``max_runtime``
     - ``timeout: 168``
     - The value is still a duration in hours.
   * - ``cpulimit``
     - ``cpu-limit: 95``
     - The value is a CPU load threshold in percent.
   * - ``minmem``
     - ``memory-limit: 50MB``
     - The minimum free physical memory, not a cap on THOR's memory
       consumption. Specify the unit explicitly.
   * - ``min``
     - ``score-notice: 40``
     - Sets the minimum score for a Notice. Info findings have a
       separate threshold; see below.
   * - ``truncate``
     - ``truncate: 2048``
     - The limit remains a number of characters per field value.

THOR 11 also reports Info findings, with a default ``score-info`` of
``30``. Setting ``score-notice: 40`` therefore does not recreate a
general minimum reporting score of 40.

Review ``max_file_size_intense`` separately when migrating intense scans.
THOR 11's ``--deep`` mode, which has ``--intense`` as an alias, increases
the file size limit to ``200MB`` unless a custom ``file-size-limit`` is
specified. Do not copy the old setting into the new configuration
without reviewing the intended scan mode and limit.

JSON v3 Logs as the Default
---------------------------

THOR 11 writes its scan log file in **JSONL format** (``.jsonl``) by default,
using **THOR JSON log format version 3**. Each line contains a JSON
object representing a log entry. The text log file that was created
by default in THOR 10 must now be enabled explicitly.

Version 3 introduces a defined schema with structured objects for
findings, messages, and the elements they describe. Existing parsers
for THOR 10 JSON output also need to be checked against this schema;
changing the expected file extension alone is not sufficient. See the
`THOR JSON log format documentation and schema <https://github.com/NextronSystems/jsonlog>`__
for details.

Before upgrading, check that your log collectors pick up ``.jsonl``
files and that your SIEM integrations, field mappings, and dashboards
can process version 3 events. Test these integrations with logs from
the THOR 11 build you intend to deploy.

Enable the Text Log Explicitly
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you still need the text log format, specify ``--text <file>``.
For example, on Windows:

.. code-block:: doscon

   C:\thor>thor64.exe --text thor-scan.txt

This creates a text log in addition to the default JSONL log. To
disable the JSONL log, add ``--no-json``. This also disables the HTML
report, which is generated from the JSON log.

THOR 11 represents scan results internally as objects. Its text log is
reconstructed from these objects and is intended to match the THOR 10
text format as closely as possible. Minor formatting or field
differences may remain. Test any scripts or parsers that depend on the
exact THOR 10 text format before upgrading. JSON preserves richer
structured information and is the preferred format for new integrations.

Changed Thunderstorm Responses
------------------------------

When THOR Thunderstorm runs with THOR 11, the format of the scan results
returned by the service changes as well. Applications that submit
samples and process the server's responses must account for the new
response structure. Existing THOR 10 response parsers may require
changes even if sample submission still succeeds.

Before upgrading a Thunderstorm service:

* Review the API documentation served at the root URL of the THOR 11
  Thunderstorm instance, for example ``http://my-server:8080/``.
* Test your clients with representative responses, including results
  with findings, results without findings, and errors.
* Adapt response parsing, field mappings, and downstream processing
  before switching production clients to the upgraded service. Include
  result retrieval for asynchronous submissions if your integration
  uses that mode.

The ``--text`` option described above controls THOR's text log file.
Do not assume that enabling it restores the THOR 10 Thunderstorm
response format; validate the service responses separately.

Higher Memory Usage
-------------------

Initial testing indicates that THOR 11 uses approximately **40% more
memory** than THOR 10. Treat this as a planning estimate, not a fixed
increase for every scan. Actual usage depends on the scan settings,
signatures, and scanned data.

Check available memory on systems that already run close to their
limits with THOR 10. During a trial scan, measure peak memory usage
with your intended configuration. Also review custom file size limits:
increasing the amount of file content scanned can increase memory use.

The ``memory-limit`` setting defines how much physical memory must
remain free. It does not reserve memory for THOR or limit THOR to the
specified amount.

Changed Help Options
--------------------

THOR 10 uses ``--help`` for the most important options and ``--fullhelp``
for all options. In THOR 11, select the detail level with
``--help <verbosity>``:

.. list-table:: THOR 11 help levels
   :header-rows: 1
   :widths: 35 65

   * - Option
     - Output
   * - ``--help short``
     - The most important options.
   * - ``--help long``
     - All available options; use this in place of THOR 10's
       ``--fullhelp``.
   * - ``--help detailed``
     - All available options with extensive descriptions.

For example, on Windows:

.. code-block:: doscon

   C:\thor>thor64.exe --help long
   C:\thor>thor64.exe --help detailed

Use ``--help detailed`` when reviewing renamed options and their value
formats. The short form ``-h`` also accepts the verbosity argument.

.. Editorial review before release:
   - Confirm the release upgrade/download commands with engineering.
   - Confirm detection conditions and wording of the old-config message.
   - Confirm handling of max_file_size_intense in older custom templates.
   - Validate the approximate 40% memory increase against release builds.
   - Validate JSON/parser and Thunderstorm response migration guidance
     against release builds and add any further deployment-specific changes.
