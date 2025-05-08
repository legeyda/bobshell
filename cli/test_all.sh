
shelduck import ./flag.sh
shelduck import ./param.sh
shelduck import ./default.sh
shelduck import ./parse.sh
shelduck import ../assert.sh
shelduck import ../result/check.sh

test_all() {
	bobshell_cli_default test_cli param1
	bobshell_cli_param   test_cli param1 p    param1

	bobshell_cli_default test_cli param2 defval1
	bobshell_cli_param   test_cli param2 q param2

	bobshell_cli_default test_cli flag1 false
	bobshell_cli_flag    test_cli flag1 true  f flag1
	bobshell_cli_flag    test_cli flag2 false F no-flag1
	
	bobshell_cli_default test_cli flag2 true
	bobshell_cli_flag    test_cli flag2 false  g flag2
	

	(
		bobshell_cli_parse test_cli -p value1 -q value2 -f -g 1 2 3
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		assert_equals true  "$flag1"
		assert_equals false "$flag2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)

	(
		bobshell_cli_parse test_cli -p value1 -q value2 -- -f -g --param1 --flag1 --no-flag1 -F --flag2
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		bobshell_result_check x y z
		assert_equals -f "$x"
		assert_equals -g "$y"
		assert_equals --param1 "$z"
	)

	(
		bobshell_cli_parse test_cli --param1 value1 --param2 value2 1 2 3
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)


	(
		bobshell_cli_parse test_cli -p=value1 -q=value2 -f -g 1 2 3
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		assert_equals true  "$flag1"
		assert_equals false "$flag2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)

	(
		bobshell_cli_parse test_cli --param1=value1 --param2=value2 1 2 3
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)

	(
		bobshell_cli_parse test_cli -fgp value1 1 2 3
		assert_equals value1 "$param1"
		assert_equals true  "$flag1"
		assert_equals false "$flag2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)





	





}