

shelduck import ../assert.sh
shelduck import ./get.sh




test_forever() {
	unset _test_cache_flag _test_cache_get__result
	bobshell_cache_get 1 eval 'bobshell_result_set one; _test_cache_flag=true'
	bobshell_result_read _test_cache_get__result
	assert_equals one "$_test_cache_get__result"
	assert_equals true "$_test_cache_flag"

	unset _test_cache_flag _test_cache_get__result
	bobshell_cache_get 1 eval 'bobshell_result_set two; _test_cache_flag=true'
	bobshell_result_read _test_cache_get__result
	assert_equals one "$_test_cache_get__result"
	assert_unset _test_cache_flag

}


test_ttl() {
	unset _test_cache_flag _test_cache_get__result
	bobshell_cache_get --ttl=1 1 eval 'bobshell_result_set one; _test_cache_flag=true'
	bobshell_result_read _test_cache_get__result
	assert_equals one "$_test_cache_get__result"
	assert_equals true "$_test_cache_flag"

	unset _test_cache_flag _test_cache_get__result
	bobshell_cache_get --ttl=1 1 eval 'bobshell_result_set two; _test_cache_flag=true'
	bobshell_result_read _test_cache_get__result
	assert_equals one "$_test_cache_get__result"
	assert_unset _test_cache_flag

	sleep 1
	unset _test_cache_flag _test_cache_get__result
	bobshell_cache_get --ttl=1 1 eval 'bobshell_result_set three; _test_cache_flag=true'
	bobshell_result_read _test_cache_get__result
	assert_equals three "$_test_cache_get__result"
	assert_isset _test_cache_flag

}