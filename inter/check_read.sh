#!/usr/bin/env shelduck_run

shelduck import ../assert.sh
shelduck import ./read.sh

unset x
bobshell_inter_read -s -p 'Input "123" for test:' x 
assert_equals 123 "$x"
printf '\n%s\n' OK