


shelduck import ../assert.sh
shelduck import ./foreach.sh
shelduck import ./set.sh


test_foreach() {
	bobshell_result_set 1 2 3
	assert_equals '<1> <2> <3> ' "$(bobshell_result_foreach myecho)"
}


myecho() {
	printf '<%s> ' "$1"
}