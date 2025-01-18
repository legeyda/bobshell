#!/bin/sh
set -eu


shelduck import url.sh
shelduck import assert.sh


test_resolve() {

	result=$(bobshell_base_url http://domain/dir/name)
	assert_equals http://domain/dir/ "$result"


	result=$(bobshell_resolve_url http://abs)
	assert_equals http://abs "$result"

	result=$(bobshell_resolve_url rel http://domain/base)
	assert_equals http://domain/base/rel "$result"

	result=$(bobshell_resolve_url rel http://domain/base/)
	assert_equals http://domain/base/rel "$result"

	result=$(bobshell_resolve_url ./rel http://domain/base)
	assert_equals http://domain/base/rel "$result"


}

test_parent() {
	value=$(bobshell_resolve_url ./../../1/2/3 4/5/6)
	assert_equals 4/1/2/3 "$value"
	

	assert_ok    eval '(bobshell_resolve_url ./../x /1)'
	assert_error eval '(bobshell_resolve_url ./../x /)'
}