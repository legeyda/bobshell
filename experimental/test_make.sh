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
	assert_die bobshell_make_rule y x -- eval 'echo building... $1 ok'
	assert_die bobshell_make_build y

	bobshell_make_rule y z -- eval 'echo building... $1 ok'
	assert_die bobshell_make_rule z x -- eval 'echo building... $1 ok'
	assert_die bobshell_make_build z

	bobshell_make_rule z fu -- eval 'echo building... $1 ok'
	assert_die bobshell_make_rule fu x -- eval 'echo building... $1 ok'
	assert_die bobshell_make_build fu
}

test_make_circular_3() {
	# a -> b, b->c, .... y->z
	trg=a
	for dep in b c d e f g h i j k l m n o p q r s t u v w x y z; do
		bobshell_make_rule "$trg" "$dep" -- echo hello
		trg="$dep"
	done
	assert_die bobshell_make_rule z a -- echo hello
}
