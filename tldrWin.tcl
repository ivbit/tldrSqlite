#! /bin/sh
# -*- tcl -*-
# vim:filetype=tcl
# launch \
exec tclsh "$0" ${1+"$@"}

# Intellectual property information START
# 
# Copyright (c) 2025 Ivan Bityutskiy 
# 
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# 
# Intellectual property information END

# Description START
# 
# Extract manuals from tldrWin.db (sqlite3 database file).
# tldrWin.db was created from contents of tldr markdown files.
#
# sudo apt install sqlite3
# 
# Description END

# How SQL string should look like inside sqlite3 shell:
# SELECT contents FROM tldr WHERE item = 'bash';

# Define procedures START
proc ErrExit {msg} {
  chan puts stderr \n$msg\n
  exit 1
}
# Define procedures END

# Declare variables START
set inFile tldrWin.db
set inPath [file normalize [file join [file dirname [info script]] $inFile]]
if {![file isfile $inPath]} then {ErrExit "File \"$inPath\" does not exist."}
if {![file readable $inPath]} then {ErrExit "File \"$inPath\" is not readable."}
# Declare variables END

# BEGINNING OF SCRIPT
if {[catch {package require sqlite3}]} then {
  ErrExit {Tcl package "sqlite3" is not installed!}
}
sqlite3 data $inPath

chan puts -nonewline stderr {
Display help for: }
set query [string trim [chan gets stdin]]

try {
  set result [data onecolumn {SELECT contents FROM tldr WHERE item = :query;}]
} on error {errMsg} {
  data close
  ErrExit "Database transaction failed!\n[string totitle $errMsg]!"
} finally {
  data close
}

# Clear screen
chan puts -nonewline stderr "\u001b\[3J\u001b\[1;1H\u001b\[0J"

chan puts stderr {}
foreach itm [split $result \n] {
  if {![regexp {^[[:cntrl:][:space:]]*$} $itm]} then {
    chan puts stdout [string map {` {} \{\{ \u001b\[34m \}\} \u001b\[0m} $itm]
  }
}
chan puts stderr {}

# END OF SCRIPT

