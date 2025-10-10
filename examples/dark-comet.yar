rule Registry_DarkComet {
   date = "2025-10-07"
   meta:
   description = "DarkComet Registry Keys"
   strings:
   $a1 = "LEGACY_MY_DRIVERLINKNAME_TEST;NextInstance"
   $a2 = "\\Microsoft\\Windows\\CurrentVersion\\Run;MicroUpdate"
   $a3 = "Path;Value;4D5A00000001" # REG_BINARY value
   $a4 = "Shell\\Open;Command;explorer.exe\\0comet.exe" # REG_MULTI_SZ value
   $a5 = ";Type;32" # REG_DWORD 0x00000020
   condition:
   1 of them
}
