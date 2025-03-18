


shelduck import ./assert.sh
shelduck import ./bobtest.sh


test_e() {
	bobtest_script=$(realpath ./bobtest)

	rm -rf target/test_bobtest
	mkdir -p target/test_bobtest
	cd target/test_bobtest
	echo '
	test_test() {
		false
		echo "OH""NO""SHOULD""NOT""PRINT""THIS"
		bobshell_die exit test_test
	}
' > test_test.sh

	reset
	sh -c "'$bobtest_script' test_test.sh:test_test"
	bobshell_die AFTER SH
}

