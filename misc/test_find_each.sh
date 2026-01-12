


shelduck import ../assert.sh
shelduck import ./find_each.sh

test_find_each() {
	expected=$(find ./misc -printf '%p\n' | sort)
	#expected="$bobshell_newline$expected"

	actual=
	bobshell_find_each handle_test_find_each ./misc

	assert_equals "$expected" "$actual"
}

handle_test_find_each() {
	actual="${actual:-}${actual:+
}$1"
}


