#! /bin/sh

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
# Extract manuals from tldr.db (sqlite3 database file).
# tldr.db was created from contents of tldr markdown files.
#
# sudo apt install sqlite3
# 
# Description END

# How SQL string should look like inside sqlite3 shell:
# SELECT contents FROM tldr WHERE item = 'bash';

# Declare variables START
scriptRoot="$(cd "$(dirname "$0")"; pwd)"
inFile='tldr.db'
inPath="${scriptRoot}/${inFile}"
> /dev/null 2>&1 ls "${inPath}"
if test $? != 0
then
  printf -- '\n'
  printf -- 'Cannot open %s\n' "$inPath"
  printf -- '\n'
  exit 1
fi

optString='.mode list'
sqlString='SELECT contents FROM tldr WHERE item = '
defaultItem='bash'
item="$defaultItem"
# Declare variables END

# BEGINNING OF SCRIPT
printf -- '\n'
read -p "Display help for: " item

if test $? != 0
then
  item="$defaultItem"
fi

if test "x$item" = "x'"
then
  item="$defaultItem"
fi

# Clear screen
printf -- '\033[3J\033[1;1H\033[0J'

sqlString="${sqlString}'${item}';"

printf -- '\n'
sqlite3 "$inPath" "$optString" "$sqlString"
# printf -- '\n'

# END OF SCRIPT

