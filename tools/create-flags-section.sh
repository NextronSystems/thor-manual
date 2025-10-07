#!/bin/bash

thor=$1

cat <<EOF
Command Line Options
====================

This section lists all options that THOR currently offers.

EOF

$1 -fullhelp 2>&1 | sed -E -f <(cat <<EOF
# Remove default values
s/\(default [^)]*\).*$//
s/\[=".*"\]/ /

# Indent options with short flag as expected by RST
s/^  -/      -/g

# Format section headers for RST
s/^> (.*) (-*)$/\1\n----------------------------------------------------------------------/g

# Remove header text before Scan Options
0,/Scan Options/ {
        /Scan Options/ !d
}

# Remove Usage examples section
/Usage examples/,$ d

# Remove "Available modules:" line that is OS dependent
/Available modules: / d

# Separate line breaks in a flag description with an empty line, as expected by RST
s/^( {10,}[^- ].*)$/\n\1/g

# Remove trailing whitespace
s/ +$//g
EOF
)
