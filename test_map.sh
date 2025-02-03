
set -x
shelduck import assert.sh
shelduck import map.sh

test_map() {
	assert_error bobshell_map_get mymap key
	assert_equals defval "$(bobshell_map_get mymap key defval)"

	bobshell_map_put mymap 2 two
	assert_error bobshell_map_get mymap 3
	assert_equals three "$(bobshell_map_get mymap 3 three)"
	assert_equals two "$(bobshell_map_get mymap 2)"
	assert_equals two "$(bobshell_map_get mymap 2 ignoreddefval)"


}

test_weird_key_value() {
	key=$(cat<<'EOF'
hello\n;'"""$s	
	
EOF
)

	bobshell_map_put mymap 2 two


}