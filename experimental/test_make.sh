shelduck import ../assert.sh

shelduck import ./make.sh



test_make() {
	mkdir -p target/test_make
	cd       target/test_make

	bobshell_make_rule x y -- eval 'cat $2 > $1'
	bobshell_result_assert -- should be ok

	rm -f x
	printf %s 1 > y
	bobshell_make_build x
	bobshell_result_assert -- should be ok
	assert_file_exists x
	assert_equals 1 "$(cat x)"



	printf %s 2 > y
	printf %s 1 > x
	bobshell_make_build x
	bobshell_result_assert -- should be ok
	assert_file_exists x
	assert_equals 1 "$(cat x)"


	printf %s 3 > y
	bobshell_make_build x
	bobshell_result_assert -- should be ok
	assert_file_exists x
	assert_equals 3 "$(cat x)"




}

test_make_undef() {
	bobshell_make_build x
	assert_error bobshell_result_check
}

test_make_circular_1() {
	bobshell_make_rule x x
	assert_error bobshell_result_check bobshell_make_rule x x
}

test_make_circular_2() {
	bobshell_make_rule x y -- eval 'echo building... $1 ok'
	bobshell_result_assert -- should be ok
	bobshell_make_rule y x -- eval 'echo building... $1 ok'
	assert_error bobshell_result_check
	bobshell_make_build y
	assert_error bobshell_result_check


	bobshell_make_rule y z -- eval 'echo building... $1 ok'
	bobshell_result_assert -- should be ok
	bobshell_make_rule z x -- eval 'echo building... $1 ok'
	assert_error bobshell_result_check
	bobshell_make_build z
	assert_error bobshell_result_check

	bobshell_make_rule z fu -- eval 'echo building... $1 ok'
	bobshell_result_assert -- should be ok
	bobshell_make_rule fu x -- eval 'echo building... $1 ok'
	assert_error bobshell_result_check
	bobshell_make_build fu
	assert_error bobshell_result_check

}

test_make_circular_3() {
	# a -> b, b->c, .... y->z
	trg=a
	for dep in b c d e f g h i j k l m n o p q r s t u v w x y z; do
		bobshell_make_rule "$trg" "$dep" -- echo hello
		bobshell_result_assert -- should be ok
		trg="$dep"
	done

	bobshell_make_rule z a -- echo hello
	assert_error bobshell_result_check

}
