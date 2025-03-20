


shelduck import ../assert.sh
shelduck import file_date.sh
shelduck import ../result/read.sh

test_ls() {
	file=$(mktemp)

	TC_ALL=C touch -m -d 'Sat Jan  1 00:00:00 UTC 2000' "$file" 
	bobshell_file_date_ls '%Y-%m-%d_%H-%M-%S' "$file"
	bobshell_result_read actual
	assert_equals 2000-01-01_00-00-00 "$actual"

	TC_ALL=C touch -m -d 'Sat Jan  1 00:00:00 UTC 2000' "$file" 
	bobshell_file_date_ls '%s' "$file"
	bobshell_result_read actual
	assert_equals 946684800 "$actual"

	TC_ALL=C touch -m -d 'Thu Jan  1 00:00:00 UTC 1970' "$file"
	bobshell_file_date_ls '%s' "$file"
	bobshell_result_read actual
	assert_equals 0 "$actual"

	TC_ALL=C touch -m -d 'Sun Sep  9 00:00:00 UTC 2001' "$file"
	bobshell_file_date_ls '%s' "$file"
	bobshell_result_read actual
	assert_equals 999993600 "$actual"

	expected=$(( $(date +%s) / 60 * 60 ))
	touch -m -t "$(date +%Y%m%d%H%M.00)" "$file"
	bobshell_file_date_ls '%s' "$file"
	bobshell_result_read actual
	assert_equals "$expected" "$actual"
	 
}

test_diff() {
	file=$(mktemp)

	TC_ALL=C touch -m -d 'Sat Jan  1 00:00:00 UTC 2000' "$file" 
	bobshell_file_date_diff '%Y-%m-%d_%H-%M-%S' "$file"
	bobshell_result_read actual
	assert_equals 2000-01-01_03-00-00 "$actual"

	TC_ALL=C touch -m -d 'Sat Jan  1 00:00:00 UTC 2000' "$file" 
	bobshell_file_date_diff '%s' "$file"
	bobshell_result_read actual
	assert_equals 946684800 "$actual"

	TC_ALL=C touch -m -d 'Thu Jan  1 00:00:00 UTC 1970' "$file"
	bobshell_file_date_diff '%s' "$file"
	bobshell_result_read actual
	assert_equals 0 "$actual"

	TC_ALL=C touch -m -d 'Sun Sep  9 00:00:00 UTC 2001' "$file"
	bobshell_file_date_diff '%s' "$file"
	bobshell_result_read actual
	assert_equals 999993600 "$actual"

	expected=$(( $(date +%s) / 60 * 60 ))
	touch -m -t "$(date +%Y%m%d%H%M.00)" "$file"
	bobshell_file_date_diff '%s' "$file"
	bobshell_result_read actual
	assert_equals "$expected" "$actual"
	 
}
