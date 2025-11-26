


shelduck import ../assert.sh
shelduck import ./set.sh
shelduck import ./add.sh
shelduck import ./apply.sh

test_add() {
	bobshell_result_set 1 2 3
	bobshell_result_add 4 5
	x=$(bobshell_result_apply printf '<%s> ')
	assert_equals '<1> <2> <3> <4> <5> ' "$x"
}
