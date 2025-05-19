
shelduck import ../assert.sh
shelduck import ./setup.sh
shelduck import ./parse.sh
shelduck import ../result/check.sh

shelduck import ./test_common.sh
test_all() {

	bobshell_cli_setup test_cli --var=param1 --param --default-unset         p param1
	bobshell_cli_setup test_cli --var=param2 --param --default-value=defval1 q param2
	bobshell_cli_setup test_cli --var=flag1  --flag                          f flag1
	bobshell_cli_setup test_cli --var=flag1  --flag  --flag-value=false      F no-flag1
	bobshell_cli_setup test_cli --var=flag2          --flag-value=false --default-value=true g flag2
		
	assert_parse


}