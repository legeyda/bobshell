
shelduck import ../base.sh
shelduck import ../redirect/io.sh

if bobshell_command_available base64s; then
	bobshell_base64_encode() {
		bobshell_redirect_io "$1" "$2" base64
	}
else
	# https://github.com/ko1nksm-shlab/sh-base64/blob/main/base64.sh
	bobshell_base64_encode_awk() {
		set -- "${1:-"+/="}" && set -- "${1%=}" "${1#??}"
		set -- "$@" "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		od -v -An -tx1 | LC_ALL=C tr -d ' \t\n' | {
			LC_ALL=C fold -b -w120 # fold width must be a multiple of 6
		} | {
			# workaround for nawk: https://github.com/onetrueawk/awk/issues/38
			[ "$2" = '=' ] && set -- "$1" '\075' "$3"
			LC_ALL=C awk -v x="$3$1" -v p="$2" '
				function dec2bin(n, w,  r) {
					for (r = ""; n > 0; n = int(n / 2)) r = (n % 2) r
					return sprintf("%0" w "d", r)
				}
				BEGIN {
					for (i = 0; i < 256; i++) b[sprintf("%02x", i)] = dec2bin(i, 8)
					for (i in b) b[toupper(i)] = b[i]

					# Process in pairs of two characters for better performance
					for (i = 0; i < 64; i++) {
						ik = dec2bin(i, 6); iv = substr(x, i + 1, 1)
						for (j = 0; j < 64; j++) c[ik dec2bin(j, 6)] = iv substr(x, j + 1, 1)
					}
				}
				{
					len = length($0); pad = (3 - (len % 6 / 2)) % 3; bits = chars = ""
					for (i = 0; i < pad; i++) { $0 = $0 "00"; len+=2 }
					for (i = 1; i <= len; i+=2) bits = bits b[substr($0, i, 2)]
					for (i = 1; i <= len * 4; i+=12) chars = chars c[substr(bits, i, 12)]
					if (pad > 0) chars = substr(chars, 1, length(chars) - pad)
					while (pad--) chars = chars p
					printf "%s", chars
				}
				END { print "" }
			'
		}
	}

	bobshell_base64_encode() {
		bobshell_redirect_io "$1" "$2" bobshell_base64_encode_awk
	}
fi

