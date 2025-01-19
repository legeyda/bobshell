

# shellcheck disable=SC2016
bobshell_file_date_awk='{
	# month
	switch($6) {
		case "Jan": month=1; break
		case "Feb": month=2; break
		case "Mar": month=3; break
		case "Apr": month=4; break
		case "May": month=5; break
		case "Jun": month=6; break
		case "Jul": month=7; break
		case "Aug": month=8; break
		case "Sep": month=9; break
		case "Oct": month=10; break
		case "Nov": month=11; break
		case "Dec": month=12; break
		default: exit 1
	}

	# day
	day=int($7)

	# year or time
	if ($8 ~ /^[[:digit:]]{4}$/) {
		year = int($8)
		time = 0
	} else if ($8 ~ /^[[:digit:]]{2}:[[:digit:]]{2}$/) {
		hour = substr($8, 1, 2);
		minute = substr($8, 4, 2);
		
		if(month <= int(current_month)) {
			year = int(current_year)
		} else {
			year = int(current_year) - 1;
		}
	} else {
		exit 1
	}
	printf("%04d-%02d-%02d_%02d-%02d", year, month, day, hour, minute)
}'


# fun: bobshell_file_date FILE
# txt: print file modification date in format +%Y-%m-%d_%H-%M
bobshell_file_date() {
	bobshell_file_date_ls=$(LC_ALL=C ls -dl "$1")
	printf %s "$bobshell_file_date_ls" | awk -v debug=1 -v current_month="$(date +%m)" -v current_year="$(date +%Y)" "$bobshell_file_date_awk"
}