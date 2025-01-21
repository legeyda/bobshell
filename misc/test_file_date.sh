


shelduck import ../assert.sh
shelduck import file_date.sh

test_file_date() {
	file=$(mktemp)

	expected=$(date +%Y-%m-%d_%H-%M)-00
	touch "$file"
	actual=$(bobshell_file_date "$file")
	assert_equals "$expected" "$actual"

	touch -m -t 8001031305 "$file"
	actual=$(bobshell_file_date "$file")
	assert_equals 1980-01-03_00-00-00 "$actual" 
}