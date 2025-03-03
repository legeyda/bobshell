

shelduck import ../assert.sh
shelduck import ./parse.sh


test_parse() {
	bobshell_semver_parse '1.2.3-beta.1+123'
	assert_equals 1      "$bobshell_semver_parse_major"
	assert_equals 2      "$bobshell_semver_parse_minor"
	assert_equals 3      "$bobshell_semver_parse_patch"
	assert_equals beta.1 "$bobshell_semver_parse_pre"
	assert_equals 123    "$bobshell_semver_parse_meta"
}