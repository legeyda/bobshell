
shelduck import ./flag.sh
shelduck import ./param.sh
shelduck import ./default.sh
shelduck import ./parse.sh
shelduck import ../assert.sh
shelduck import ../result/check.sh
shelduck import ./test_common.sh

test_parse() {
	bobshell_cli_default test_cli param1
	bobshell_cli_param   test_cli param1 p    param1

	bobshell_cli_default test_cli param2 defval1
	bobshell_cli_param   test_cli param2 q param2

	bobshell_cli_default test_cli flag1 false
	bobshell_cli_flag    test_cli flag1 true  f flag1
	bobshell_cli_flag    test_cli flag1 false F no-flag1
	
	bobshell_cli_default test_cli flag2 true
	bobshell_cli_flag    test_cli flag2 false  g flag2
	
	assert_parse


}