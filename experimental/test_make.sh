shelduck import ../assert.sh

shelduck import ./make.sh



test_make() {
	mkdir -p target/test_make
	cd       target/test_make

	bobshell_make_rule x y -- eval 'cat $2 > $1'

	rm -f x
	printf %s 1 > y
	bobshell_make_build x
	assert_file_exists x
	assert_equals 1 "$(cat x)"



# 	printf %s 2 > y
# 	printf %s 1 > x
# 	bobshell_make_build x
#	assert_file_exists x
# 	assert_equals 1 "$(cat x)"
#
# 	printf %s 3 > y
# 	bobshell_make_build x
#	assert_file_exists x
# 	assert_equals 3 "$(cat x)"




}

test_make_undef() {
	assert_die bobshell_make_build x
}

test_make_circular_1() {
	assert_die bobshell_make_rule x x
}

test_make_circular_2() {
	bobshell_make_rule x y -- eval 'echo building... $1 ok'
	bobshell_make_rule y x -- eval 'echo building... $1 ok'

	assert_die bobshell_make_build x
	x=$(set +x; assert_die bobshell_make_build x 2>&1)

	assert_contains "$x" 'Maximum function recursion depth' # todo invert

	# assert_not_contains "$x" 'Maximum function recursion depth'
	# assert_contains     "$x" 'bobshell_make_build: circular depenendency'

}
