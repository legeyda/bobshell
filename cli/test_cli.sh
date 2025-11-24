
shelduck import ../assert.sh
shelduck import ./setup.sh
shelduck import ./parse.sh
shelduck import ./help.sh
shelduck import ../result/check.sh


test_cli() {

	bobshell_cli_setup test_cli --var=param1 --param --default-unset         p param1
	bobshell_cli_setup test_cli --var=param2 --param --default-value=defval1 q param2
	bobshell_cli_setup test_cli --var=param3 --param --append --separator=', ' r param3
	bobshell_cli_setup test_cli --var=flag1  --flag                          f flag1
	bobshell_cli_setup test_cli --var=flag1  --flag  --flag-value=false      F no-flag1
	bobshell_cli_setup test_cli --var=flag2  --flag  --flag-value=false --default-value=true g flag2

	(
		bobshell_cli_parse test_cli -p value1 -q value2 -f -g 1 2 3
		assert_equals 6 "$bobshell_cli_shift"
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
		assert_equals 5 "$bobshell_cli_shift"
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		bobshell_result_check x y z
		assert_equals -f "$x"
		assert_equals -g "$y"
		assert_equals --param1 "$z"
	)

	(
		bobshell_cli_parse test_cli --param1 value1 --param2 value2 1 2 3
		assert_equals 4 "$bobshell_cli_shift"
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)

	(
		bobshell_cli_parse test_cli -pvalue1 -qvalue2 -f -g 1 2 3
		assert_equals 4 "$bobshell_cli_shift"
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
		assert_equals 2 "$bobshell_cli_shift"
		assert_equals value1 "$param1"
		assert_equals value2 "$param2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)

	(
		bobshell_cli_parse test_cli -fgpvalue1 1 2 3
		assert_equals 1 "$bobshell_cli_shift"
		assert_equals value1 "$param1"
		assert_equals true  "$flag1"
		assert_equals false "$flag2"
		bobshell_result_check x y z
		assert_equals 1 "$x"
		assert_equals 2 "$y"
		assert_equals 3 "$z"
	)

	(
		bobshell_cli_parse test_cli -rhello --param3=you -rall 1 2 3
		assert_equals 'hello, you, all' "$param3"
		assert_equals false "$flag1"
	)

}


test_listener() {


	param2=
	bobshell_cli_setup test_cli --var=param --param --default-unset                  p param1
	bobshell_cli_setup test_cli             --param --listener='param2="$param2 $1"' q param2

	(
		bobshell_cli_parse test_cli -p a -pb -pc --param1 d --param1=e \
		                            -q 1 -q2 -q3 --param2 4 --param2=5
		assert_equals 14 "$bobshell_cli_shift"
		assert_equals e "$param"
		assert_equals ' 1 2 3 4 5' "$param2"

	)

}