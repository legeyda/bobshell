
shelduck import ../assert.sh
shelduck import ./copy.sh

test_resource_copy() {
	mkdir -p target/test_resource_copy
	cd target/test_resource_copy
	# todo assert_exit
	#   for type in file stdin stdout var val; do
	#     assert_error bobshell_resource_copy $type:a stdin:
	#     assert_error bobshell_resource_copy $type:a val:
	#     assert_error bobshell_resource_copy stdout: $type:a
	#   done
		
	printf hello > a.txt
	bobshell_resource_copy file:a.txt file:b.txt
	assert_equals hello "$(cat b.txt)"

	printf hello > a.txt
	assert_equals hello "$(bobshell_resource_copy file:a.txt stdout:)"

	printf hello > a.txt
	bobshell_resource_copy file:a.txt var:VAR
	assert_equals hello "$VAR"

	printf hi | bobshell_resource_copy stdin: file:b.txt
	assert_equals hi "$(cat b.txt)"

	assert_equals hi "$(printf hi | bobshell_resource_copy stdin: stdout:)"

	assert_equals hi "$(printf hi | ( bobshell_resource_copy stdin: var:VAR_FROM_FILE; printf "$VAR_FROM_FILE"; ) )"

	VAR_TO_FILE=msg
	bobshell_resource_copy var:VAR_TO_FILE file:c.txt
	assert_equals msg "$(cat c.txt)"
	assert_equals msg "$(VAR_TO_STDOUT=msg; bobshell_resource_copy var:VAR_TO_STDOUT stdout: )"

	assert_empty "${VAR_FROM_VAR:-}"
	VAR_TO_VAR=pss
	bobshell_resource_copy var:VAR_TO_VAR var:VAR_FROM_VAR
	assert_equals "$VAR_TO_VAR" "$VAR_FROM_VAR"

	bobshell_resource_copy val:xxx file:d.txt
	assert_equals xxx "$(cat d.txt)"

	assert_equals xxx "$(bobshell_resource_copy val:xxx stdout:)"
	
	bobshell_resource_copy val:xxx var:FROM_VAL
	assert_equals xxx "$FROM_VAL"
}

test_copy_url() {
	bobshell_resource_copy https://github.com/legeyda/shelduck/releases/latest/download/install.sh var:x
	assert_ok bobshell_starts_with "$x" '#!/bin/sh'
}