
# https://stackoverflow.com/a/32158604
# https://howardhinnant.github.io/date_algorithms.html


# fun: bobshell_file_date [--format DATEFORMAT] FILE
# txt: print file modification date
#      if time is earlier then half year ago, there is no time information
#      if time is after half year ago, minute-precision is available
bobshell_file_date() {
	bobshell_file_date_format="%s"
	while bobshell_isset_1 "$@"; do
		case "$1" in
			(-f|--format) 
				bobshell_file_date_format="$2"
				shift 2
				;;
			(-*)
				bobshell_die "bobshell_file_date: unsupported option: $1"
				;; 
			(*) break
		esac
	done


	bobshell_file_date_ls=$(LC_ALL=C ls -dl "$1")
	printf %s "$bobshell_file_date_ls" | awk \
			-v debug=1 \
			-v current_month="$(date +%m)" \
			-v current_year="$(date +%Y)" \
			-v offset="$(date +%z)" \
			-v format="$bobshell_file_date_format" \
			'

function civil_to_days(year, month, day) {
	year -= (month <= 2) ? 1 : 0;
	era = int((year >= 0 ? year : year - 399) / 400);
	year_of_era = year - era*400; # [0, 399]
	day_of_year = int((153*(month > 2 ? month-3 : month+9) + 2)/5) + day-1;  # [0, 365]
	day_of_era = year_of_era * 365 + int(year_of_era/4) - int(year_of_era/100) + day_of_year;  # [0, 146096]
	result = 146097*era + day_of_era - 719468
	return result;
}


function offset_to_minutes(offset) {
	offset_minutes=int(offset)
	result = int(offset_minutes/100)*60 + (offset_minutes%100)
	
	return result
}

{

	# month
	switch($6) {
		case "Jan": month= 1; break
		case "Feb": month= 2; break
		case "Mar": month= 3; break
		case "Apr": month= 4; break
		case "May": month= 5; break
		case "Jun": month= 6; break
		case "Jul": month= 7; break
		case "Aug": month= 8; break
		case "Sep": month= 9; break
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
		hour = 0
		minute = 0
		time_is_known=0
	} else if ($8 ~ /^[[:digit:]]{2}:[[:digit:]]{2}$/) {
		hour = substr($8, 1, 2);
		minute = substr($8, 4, 2);
		
		if(month <= int(current_month)) {
			year = int(current_year)
		} else {
			year = int(current_year) - 1;
		}
		time_is_known=1
	} else {
		exit 1
	}

	# parse format and output
	format_length = split(format, format_chars, "")
	if(0 == format_length) {
		exit
	}


	i=1;
	while(i<format_length) {
		current_char=format_chars[i];
		if("%" == current_char) {
			i++;
			if(i>format_length) {
				print("malformed format") > "/dev/stderr"
				exit 1
			}
			current_char=format_chars[i];
			if("%" == current_char) {
				printf("%")
			} else if("s" == current_char) {
				if(time_is_known) {
					offset_minutes = offset_to_minutes(offset)
				} else {
					offset_minutes = 0
				}
				seconds_since_epoch=60*(60*(24*civil_to_days(year, month, day) + hour) + minute - offset_minutes);
				printf("%d", seconds_since_epoch)
			} else if("Y" == current_char) {
				printf("%04d", year)
			} else if("m" == current_char) {
				printf("%02d", month)
			} else if("d" == current_char) {
				printf("%02d", day)
			} else if("H" == current_char) {
				printf("%02d", hour)
			} else if("M" == current_char) {
				printf("%02d", minute)
			} else if("S" == current_char) {
				printf("%02d", seconds)
			} else {
				printf("unsupported format %s", current_char) > "/dev/stderr"
				exit 1
			}
			i++
		} else {
			printf(current_char);
			i++
		}
	}

}'
}