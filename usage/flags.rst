Command Line Options
====================

This section lists all options that THOR currently offers.

Scan Options
----------------------------------------------------------------------
      -t, --template string            Process default scan parameters from this YAML file
      --generate-config            Print a YAML config from the given parameters and exit
      -p, --path strings               Scan a specific file path. Define multiple paths by specifying this option multiple times. Append ':NOWALK' to the path for non-recursive scanning (default: only the system drive)
      --allhds                     (Windows Only) Scan all local hard drives (default: only the system drive)
      --alldrives                  Scan all local drives, including network drives (default: only the system drive). Requires a Forensic Lab license.
      --max_file_size uint         Max. file size to check (larger files are ignored). Increasing this limit will also increase memory usage of THOR.
      --max_log_lines int          Maximum amount of lines to check in a log file before skipping the remaining lines
      --max_process_size uint      Max process size to check (larger processes won't be scanned)
      --max_runtime int            Maximum runtime in hours. THOR will stop once this time has run out. 0 means no maximum runtime.
      --nodoublecheck              Don't check whether another THOR instance is running (e.g. in Lab use cases when several mounted images are scanned simultaneously on a single system) (requires a Forensic Lab license)
      -f, --epoch strings              Specify a range of days with attacker activity as start and end date pairs.

                                   Files created/modified between these days (including the specified start, excluding the specified end) will receive an extra score.

                                   Example: -f 2009-10-09 -f 2009-10-10 marks the 09.10.2009 as relevant.
      --epochscore int             Score to add for files that were created/modified on days with attacker activity (see --epoch parameter)
      --insecure                   Skip TLS host verification (insecure)
      --ca strings                 Root CA for host certificate verification during TLS handshakes
      --cross-platform             Apply IOCs with path separators platform independently.
      --require-admin              Terminate immediately if THOR is executed without administrator rights.
      --follow-symlinks            When encountering a symlink during the file scan that points to a directory, scan the directory.
      --max-recursion-depth uint   Maximum depth of archives to scan
      --max-nested-objects uint    Maximum number of files per archive to scan

Scan Modes
----------------------------------------------------------------------
      --quick                      Activate a number of flags to speed up the scan at cost of some detection.

                                   This is equivalent to: --noeventlog --nofirewall --noprofiles --nologscan --noevtx --nohotfixes --nomft --lookback 3 --lookback-modules filescan
      --soft                       Skip CPU and RAM intensive modules (Mutexes, Firewall, Logons, Network sessions and shares, LSA sessions, open files, hosts file), don't decompress executables and doesn't perform a DoublePulsar backdoor check, lower max CPU usage to 70% and set low priority for THOR.

                                   This mode activates automatically on systems with 1 CPU core or less than 1024 MB RAM.
      --intense                    Paranoid scan mode that disables all safe guards. Only use this mode in lab scanning scenarios. We don't recommend using this mode to live scan productive systems. (enables: memory intensive extra modules)
      --diff                       Set lookback time (see --lookback) for each module to the last time the module ran successfully and activates --global-lookback.

                                   Effectively, this means that only elements that changed since the last scan are examined. (only works if ThorDB has been active)
      --lookback int               Specify how many past days shall be analyzed. Event log entries from before this point will be ignored. 0 means no limit
      --global-lookback            Apply Lookback to all modules that support it (not only Eventlog). See also --lookback and --lookback-modules.

                                   Warning: Timestomping or similar methods of antivirus evasion may result in elements not being examined.
      --force-aptdir-lookback      Enforce lookback application on all files in the FileScan module. By default, especially endangered directories ignore the lookback value.
      --lookback-modules strings   Apply Lookback to the given modules. See also --lookback and --modules.

                                   Warning: Timestomping or similar methods of antivirus evasion may result in elements not being examined.
      --lab                        Lab scan mode - scan only the file system, disable resource checks and quick mode, activate intense mode, disable ThorDB, apply IOCs platform independently and use all CPU cores.

                                   This option scans all drives by default, but is often used with -p to scan only a single path. Requires a Forensic Lab license.
      --virtual-map strings        Rewrite found file paths to use a different prefix.

                                   This can be useful for mounted images, where the current location of files does not match the original location and therefore references might be out of date.

                                   Specify the original and current path as --virtual-map path/to/current/location:path/to/original/location.

                                   On Windows, drive names are also supported, e.g. specify --virtual-map F:C if the drive on F: was originally used as C:.

                                   Requires a Forensic Lab license.

Resource Options
----------------------------------------------------------------------
      -c, --cpulimit float        Pause any THOR actions while the overall CPU usage exceeds this value (in percent). Minimum is 15%
      --nocpulimit            Disable cpulimit check
      --nosoft                Disable automatic activation of soft mode (see --soft)
      --norescontrol          Do not check whether the system is running out of resources. Use this option to enforce scans that have been canceled due to resource scarcity. (use with care!)
      --minmem uint           Cancel the running scan if the amount of free physical memory drops below this value (in MB)
      --lowprio               Reduce the priority of the THOR process to a lower level
      --verylowprio           Reduce the priority of the THOR process to a very low level
      --lowioprio             Reduce the disk priority of the THOR process to a lower level
      --nolowprio             Do not reduce the priority of the THOR process to a lower level due to soft mode (see --soft)
      --nolockthread          Do not lock calls to C libraries to main thread (this may increase performance at the cost of memory usage)
      --yara-stack-size int   Allocate this number of slots for the YARA stack. Increasing this limit will allow you to use larger rules, albeit with more memory overhead.
      --yara-timeout int      Cancel any YARA checks that take longer this amount of time (in seconds)
      --threads IntVar        Run this amount of THOR threads in parallel. Numbers <= 0 are subtracted from the number of cores (0=use all cores), e.g. use -2 to use all cores except for two.
      --bulk-size uint        Check this amount of elements together, e.g. log lines or registry entries

Special Scan Modes
----------------------------------------------------------------------
      -m, --image_file string          Scan only the given single memory image / dump file (don't use for disk images, scan them mounted with --lab). Requires a Forensic Lab license.
      --image-chunk-size uint      Scan image / dump files in chunks of this size
      -r, --restore_directory string   Restore PE files with YARA rule matches during the DeepDive into the given folder
      --restore_score int          Restore only chunks with a total match score higher than the given value
      --dropzone                   Watch and scan all files dropped to a certain directory (which must be passed with -p). Disable resource checks and quick mode, activate intense mode, disable ThorDB and apply IOCs platform independently. Requires a Forensic Lab license.
      --dropdelete                 Delete all files dropped to the drop zone after the scan.
      --dropzone-delay uint32      Scan dropped files after specified delay in seconds (longer delay allow for longer copy processes

Thor Thunderstorm Service
----------------------------------------------------------------------
      --thunderstorm                      Watch and scan all files sent to a specific port (see --server-port). Disable resource checks and quick mode, activate intense mode, disable ThorDB and apply IOCs platform independently.
      --server-upload-dir string          Path to a directory where THOR drops uploaded files.

                                          If this path does not exist, THOR tries to create it.
      --server-host string                IP address that THOR's server should bind to.
      --server-port uint16                TCP port that THOR's server should bind to.
      --server-cert string                TLS certificate that THOR's server should use. If left empty, TLS is not used.
      --server-key string                 Private key for the TLS certificate that THOR's server should use. Required if --server-cert is specified.
      --server-store-samples string       Sets whether samples should be stored permanently in the folder specified with --server-upload-dir.

                                          Specify "all" to store all samples, or "malicious" to store only samples that generated a warning or an alert.
      --server-result-cache-size uint32   Size of the cache that is used to store results of asynchronous requests temporarily.

                                          If set to 0, the cache is disabled and asynchronous results are not stored.
      --pure-yara                         Only scan files using YARA signatures (disables all programmatic checks, STIX, Sigma, IOCs, as well as most features and modules)
      --sync-only-threads uint16          Reserve this amount of THOR threads for synchronous requests
      --force-max-file-size               Enforce the maximum file size even on files like registry hives or log files which are usually scanned despite size.

License Retrieval
----------------------------------------------------------------------
      --asgard string           Hostname of the ASGARD server from which a license should be requested, e.g. asgard.my-company.internal
      --asgard-token string     Use this token to authenticate with the License API of the asgard server. The token can be found in the 'Downloads' or 'Licensing' section in the ASGARD. This requires ASGARD 2.5+.
      -q, --license-path string     Path containing the THOR license
      --portal-key string       Get a license for this host from portal.nextron-systems.com using this API Key.

                                This feature is only supported for host-based server / workstation contracts.
      --portal-contracts ints   Use these contracts for license generation. If no contract is specified, the portal selects a contract by itself. See --portal-key.
      --portal-nonewlic         Only use an existing license from the portal. If none exists, exit. See --portal-key.

Active Modules
----------------------------------------------------------------------
      -a, --module strings      Activate the following modules only (Specify multiple modules with -a Module1 -a Module2 ... -a ModuleN).
      --noprocs             Do not analyze Processes
      --nofilesystem        Do not scan the file system
      --noreg               Do not analyze the registry
      --nousers             Do not analyze user accounts
      --nologons            Do not show currently logged in users
      --noautoruns          Do not analyse autorun elements
      --noeventlog          Do not analyse the eventlog
      --norootkits          Do not check for rootkits
      --noevents            Do not check for malicious events
      --nodnscache          Do not analyze the local DNS cache
      --noenv               Do not analyze environment variables
      --nohosts             Do not analyze the hosts file
      --nomutex             Do not check for malicious mutexes
      --notasks             Do not analyse scheduled tasks
      --noservices          Do not analyze services
      --noprofiles          Do not analyze profile directories
      --noatjobs            Do not analyze jobs scheduled with the 'at' tool
      --nonetworksessions   Do not analyze network sessions
      --nonetworkshares     Do not analyze network shares
      --noshimcache         Do not analyze SHIM Cache entries
      --nohotfixes          Do not analyze Hotfixes
      --nowmistartup        Do not analyze startup elements using WMI
      --nofirewall          Do not analyze the local Firewall
      --nowmi               Disable all checks with WMI functions
      --nolsasessions       Do not analyze lsa sessions
      --nomft               Do not analyze the drive's MFT (default, unless in intense mode)
      --mft                 Analyze the drive's MFT
      --nopipes             Do not analyze named pipes
      --noetwwatcher        Do not analyze ETW logs during THOR runtime
      --nointegritycheck    Do not check with the package manager for package integrity on Linux
      --notimestomp         Disable timestomping detection
      --nocron              Disable crontab parsing
      --collector           Activate Collector module: collects and zips various different files interesting for IR & DF
      --collector-only      Activate Collector module only: collects and zips various different files intresting for IR & DF

Module Extras
----------------------------------------------------------------------
      --process ints                  Process IDs to be scanned. Define multiple processes by specifying this option multiple times (default: all processes) (Module: ProcessCheck)
      --dump-procs                    Generate process dumps for suspicious or malicious processes (Module: ProcessCheck)
      --max-procdumps uint            Create at most this many process dumps (Module: ProcessCheck)
      --procdump-dir string           Store process dumps of suspicious processes in this directory (Module: ProcessCheck)
      -n, --eventlog-target strings       Scan specific Eventlogs (e.g. 'Security' or 'Microsoft-Windows-Sysmon/Operational') (Module: Eventlog)
      --nodoublepulsar                Do not check for DoublePulsar Backdoor (Module: Rootkit)
      --full-registry                 Do not skip registry hives keys with less relevance (Module: Registry)
      --noregwalk                     Do not scan the whole registry during the registry scan
      --showdeleted                   Show deleted files found in the MFT as 'info' messages.
      --allfiles                      Scan all files, even ones that are usually not interesting. Sets --max_file_size to 200MB unless specified otherwise.
      --ads                           Scan Alternate Data Streams for all files
      --collector-output string       Output path for the ZIP archive created by the 'Artifact-Collector' module
      --collector-print-config        Output default 'Artifact-Collector' config and exit
      --collector-dry-run             Run 'Artifact-Collector' in dry-run mode - files will be listed in the output but not added to the output archive
      --collector-no-mft              Disable MFT parsing in the 'Artifact-Collector' (faster, but might cause some files to be not accessible)
      --collector-config string       Config file for 'Artifact-Collector' module
      --collector-max-filesize uint   Max size for files the 'Artifact-Collector' module should collect - 0 means no limit

Active Features
----------------------------------------------------------------------
      --nothordb               Do not use or create ThorDB database for holding scan information
      --nosigma                Disable Sigma signatures
      --dumpscan               Scan memory dumps
      --nologscan              Do not scan log files (identified by .log extension or location)
      --noyara                 Disable checks with YARA
      --nostix                 Disable checks with STIX
      --noarchive              Do not scan contents of archives
      --noc2                   Disable checks for known C2 Domains
      --noprochandles          Do not analyze process handles
      --noprocconnections      Do not analyze process connections
      --noamcache              Do not analyze Amcache files
      --noregistryhive         Do not analyze Registry Hive files
      --noexedecompress        Do not decompress and scan portable executables
      --nowebdirscan           Do not analyze web directories that were found in process handles
      --novulnerabilitycheck   Do not analyze system for vulnerabilities
      --noprefetch             Do not analyze prefetch directory
      --nogroupsxml            Do not analyze groups.xml
      --nowmipersistence       Do not check WMI Persistence
      --nolnk                  Do not analyze LNK files
      --noknowledgedb          Do not check Knowledge DB on Mac OS
      --nower                  Do not analyze .wer files
      --noevtx                 Do not analyze EVTX files
      --noauthorizedkeys       Do not analyze authorized_keys files
      --noimphash              Do not calculate imphash for suspicious EXE files (Windows only)
      --c2-in-memory           Apply C2 IOCs on process memory (not recommended unless you are willing to accept many false positives on browser and other process memories)
      --custom-c2-in-memory    Apply custom C2 IOCs on process memory
      --noeml                  Disable Email parser
      --noetl                  Disable ETL parser
      --noauditlog             Disable Audit log parser
      --nomftfile              Disable MFT file parser
      --nounescape             Disable unescape feature
      --nommap                 Disable reading data from scanned files via memory mapping (except for YARA scans)

Feature Extras
----------------------------------------------------------------------
      --customonly              Use custom signatures only (disables all internal THOR signatures and detections)
      --init-selector strings   Load only signatures where metadata (rule name, title, tags, description or similar) contains the given string. Use --print-signatures to list metadata of all signatures.
      --init-filter strings     Do not load signatures where metadata (rule name, title, tags, description or similar) contains the given string. Use --print-signatures to list metadata of all signatures.
      --full-proc-integrity     Increase sensitivity of --processintegrity for process impersonation detection. Likely to cause false positives, but also better at detecting real threats.
      --processintegrity        Run PE-Sieve to check for process integrity (Windows only)
      --split-registry-keys     Scan registry values separately instead of scanning the whole key at once. This is useful for large registry keys with many values.

Output Options
----------------------------------------------------------------------
      -l, --logfile string                                    Log file for text output
      --htmlfile string                                   Log file for HTML output
      --nolog                                             Do not generate text or HTML log files
      --nohtml                                            Do not create an HTML report file
      --appendlog                                         Append text log to existing log instead of overwriting
      --keyval                                            Format text and HTML log files with key value pairs to simplify the field extraction in SIEM systems (key='value')
      --jsonfile string    Log file for JSON output. If no value is specified, defaults to :hostname:_thor_:time:.json.
      --jsonv2                                            Print JSON logs in the v2 format, which is easier to parse than the old v1 format
      -o, --csvfile string                                    Generate a CSV containing MD5,Filepath,Score for all files with at least the minimum score
      --nocsv                                             Do not write a CSV of all mentioned files with MD5 hash (see --csvfile)
      --stats-file string         Generate a CSV file containing the scan summary in a single line. If no value is specified, defaults to :hostname:_stats.csv.
      -e, --rebase-dir string                                 Specify the output directory where all output files will be written. Defaults to the current working directory.
      --suppresspi                                        Suppress all personal information in log outputs to comply with local data protection policies
      --eventlog                                          Log to windows application eventlog
      -x, --min int                                           Only report files with at least this score
      --max-reasons int                                   Show at most X reasons why a match is considered dangerous (0 = no limit)
      --printshim                                         Include all SHIM cache entries in the output as 'info' level messages
      --printamcache                                      Include all AmCache entries in the output as 'info' level messages
      -j, --overwrite-hostname string                         Override the local hostname value with a static value (useful when scanning mounted images in the lab. Requires a Forensic Lab license.
      -i, --scanid string                                     Specify a scan identifier (useful to filter on the scan ID, should be unique)
      --scanid-prefix string                              Specify a prefix for the scan ID that is concatenated with a random ID if neither --scanid nor --noscanid are specified
      --noscanid                                          Do not automatically generate a scan identifier if none is specified
      --silent                                            Do not print anything to command line
      --cmdjson                                           Format command line output as JSON
      --cmdkeyval                                         Use key-value pairs for command line output, see --keyval
      --encrypt                                           Encrypt the generated log files and the MD5 csv file
      --pubkey string                                     Use this RSA public key to encrypt the logfile and csvfile (see --encrypt). Both --pubkey="<key>" and --pubkey="<file>" are supported.
      --nocolor                                           Do not use ANSI escape sequences for colorized command line output
      --genid                                             Print a unique ID for each log message. Identical log messages will have the same ID.
      --truncate int                                      Max. length per THOR value (0 = no truncation)
      --registry_depth_print int                          Don't print info messages when traversing registry keys at a higher depth than this
      --utc                                               Print timestamps in UTC instead of local time zone
      --rfc3339                                           Print timestamps in RFC3339 (YYYY-MM-DD'T'HH:mm:ss'Z') format
      --reduced                                           Reduced output mode - only warnings, alerts and errors will be printed
      --printlicenses                                     Print all licenses to command line (default: only 10 licenses will be printed)
      --local-syslog                                      Print THOR events to local syslog
      --showall                                           Print rule matches even if that rule already matched more than 10 times.
      --max-hits uint                                     Report at most X matches of a rule or IOC during the complete THOR scan. 0 means all hits will be reported.
      --ascii                                             Don't print non-ASCII characters to command line and log files
      --string-context uint                               When printing strings from YARA matches, include this many bytes surrounding the match
      --include-info-in-html                              Include info messages in the HTML report
      --audit-trail string                                Output file for audit trail
      --background string                                 Optimize font colors for given terminal background (options: default, light, dark)

ThorDB
----------------------------------------------------------------------
      --dbfile string   Location of the thor.db file
      --resumeonly      Don't start a new scan, only finish an interrupted one. If no interrupted scan exists, nothing is done.
      --resume          Store information while running that allows to resume an interrupted scan later. If a previous scan was interrupted, resume it instead of starting a new one.

Syslog
----------------------------------------------------------------------
      -s, --syslog strings        Write output to the specified syslog server, format: server[:port[:syslogtype[:sockettype]]].

                              Supported syslog types: DEFAULT/CEF/JSON/SYSLOGJSON/SYSLOGKV

                              Supported socket types: UDP/TCP/TCPTLS

                              Examples: -s syslog1.dom.net, -s arcsight.dom.net:514:CEF:UDP, -s syslog2:4514:DEFAULT:TCP, -s syslog3:514:JSON:TCPTLS
      --rfc3164               Truncate long Syslog messages to 1024 bytes
      --rfc5424               Truncate long Syslog messages to 2048 bytes
      --rfc                   Use strict syslog according to RFC 3164 (simple host name, shortened message)
      --maxsysloglength int   Truncate Syslog messages to the given length (0 means no truncation). This only applies to non-JSON formatted syslog.
      --cef_level int         Define the minimum severity level to log to CEF syslogs (Debug=1, Info=3, Notice=4, Error=5, Warning=8, Alarm=10)

Reporting and Actions
----------------------------------------------------------------------
      --notice int                   Minimum score on which a notice is generated
      --warning int                  Minimum score on which a warning is generated
      --alert int                    Minimum score on which an alert is generated
      --action_command string        Run this command for each file that has a score greater than the score from --action_level.
      --action_args strings          Arguments to pass to the command specified via --action_command.

                                     The placeholders %filename%, %filepath%, %file%, %ext%, %md5%, %score% and %date% are replaced at execution time.
      --action_level int             Only run the command from --action_command for files with at least this score.
      --nofserrors                   Silently ignore filesystem errors
      --minimum-sigma-level string   Only report sigma rule matches with this level or higher

THOR Remote
----------------------------------------------------------------------
      --remote strings           Target host (use multiple --remote <host> statements for a set of hosts)
      --remote-user string       Username (if not specified, windows integrated authentication is used)
      --remote-password string   Password to be used to authenticate against remote hosts
      --remote-prompt            Prompt for password for remote hosts
      --remote-debug             Debug Mode for THOR Remote
      --remote-dir string        Upload THOR to this remote directory
      --remote-workers int       Number of concurrent scans
      --remote-rate int          Number of seconds to wait between scan starts

Automatic Collection of Suspicious Files (Bifrost)
----------------------------------------------------------------------
      --bifrost2Server string   Server running the Bifrost 2 quarantine service. THOR will upload all suspicious files to this server.

                                This flag is only usable when invoking THOR from ASGARD 2.
      --bifrost2Score int       Send all files with at least this score to the Bifrost 2 quarantine service.

                                This flag is only usable when invoking THOR from ASGARD 2.

VirusTotal Integration
----------------------------------------------------------------------
      --vtkey string     Virustotal API key for hash / sample uploads
      --vtmode string    VirusTotal lookup mode (limited = hash lookups only, full = hash and sample uploads)
      --vtscore int      Minimum score for hash lookup / sample upload to VirusTotal
      --vtaccepteula     By specifying this option, you accept VirusTotal's EULA: https://www.virustotal.com/en/about/terms-of-service/
      --vtwaitforquota   Wait if the VirusTotal API key quota is exceeded
      --vtverbose        Show more information from VirusTotal

Debugging and Info
----------------------------------------------------------------------
      --debug                   Show Debugging Output
      --trace                   Show Tracing Output
      --printall                Print all files that are checked (noisy)
      --print-signatures        Show THOR Signatures and IOCs and exit
      --print-signatures-json   Show THOR Signatures and IOCs as JSON and exit
      --version                 Show THOR, signature and software versions and exit
      -h, --help                    Show help for most important options and exit
      --fullhelp                Show help for all options and exit
      --completions string      Generate shell completions for the specified shell (bash, zsh, fish, powershell)

