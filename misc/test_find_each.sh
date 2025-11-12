


shelduck import ../assert.sh
shelduck import ./find_each.sh

test_find_each() {
	find_each handle_test_find_each .
}

handle_test_find_each() {
	printf '<%s> %s\n' "$@"
}


