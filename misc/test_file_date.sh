


shelduck import ../assert.sh
shelduck import file_date.sh

test_file_date() {
	file=$(mktemp)

	TC_ALL=C touch -m -d 'Sat Jan  1 00:00:00 UTC 2000' "$file" 
	actual=$(bobshell_file_date --format '%Y-%m-%d_%H-%M-%S' "$file")
	assert_equals 2000-01-01_00-00-00 "$actual"

	TC_ALL=C touch -m -d 'Sat Jan  1 00:00:00 UTC 2000' "$file" 
	actual=$(bobshell_file_date --format '%s' "$file")
	assert_equals 946684800 "$actual"



	TC_ALL=C touch -m -d 'Thu Jan  1 00:00:00 UTC 1970' "$file"
	actual=$(bobshell_file_date --format '%s' "$file")
	assert_equals 0 "$actual"



	TC_ALL=C touch -m -d 'Sun Sep  9 00:00:00 UTC 2001' "$file"
	actual=$(bobshell_file_date --format '%s' "$file")
	assert_equals 999993600 "$actual"



	expected=$(( $(date +%s) / 60 * 60 ))
	touch -m -t "$(date +%Y%m%d%H%M.00)" "$file"
	actual=$(bobshell_file_date --format '%s' "$file")
	assert_equals "$expected" "$actual"

	
	 
}