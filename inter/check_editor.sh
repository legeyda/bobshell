#!/usr/bin/env shelduck_run

shelduck import ../assert.sh
shelduck import ./editor.sh

dir=$(mktemp -d)
printf %s 'Enter "123" for test and save the file. Type any key when ready.'
read x
bobshell_inter_editor "$dir/file.txt"

assert_equals 123 "$(cat $dir/file.txt)"
printf '\n%s\n' OK