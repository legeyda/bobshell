


shelduck import ./assert.sh
shelduck import ./bobtest.sh


test_e() {
	: "${BOBSHELL_BUILD_ROOT:=./target}"
	bobtest_script=$(realpath ./bobtest)

	mkdir -p "$BOBSHELL_BUILD_ROOT/test_bobtest"
	echo '
	test_test() {
		false
		echo "OH""NO""SHOULD""NOT""PRINT""THIS"
		bobshell_die exit test_test
	}
' > "$BOBSHELL_BUILD_ROOT/test_bobtest/test_test.sh"
	
	# https://github.com/legeyda/bobshell/actions/runs/14133698340/job/39600202215#step:3:33
	# reset: terminal attributes: No such device or address
	reset || true

	sh -c ". '$BOBSHELL_BUILD_ROOT/shelduck.sh'; shelduck import ./bobtest.sh; bobtest '$BOBSHELL_BUILD_ROOT/test_bobtest/test_test.sh:test_test' || true"
}

