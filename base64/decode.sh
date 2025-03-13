


shelduck import ../base.sh
shelduck import ../redirect/io.sh

if bobshell_command_available base64; then
	bobshell_base64_decode() {
		bobshell_redirect_io "$1" "$2" base64 -d
	}
else
	# https://github.com/ko1nksm-shlab/sh-base64/blob/main/base64.sh
	bobshell_base64_decode_awk() {
		set -- "${1:-"+/="}" && set -- "${1%=}" "${1#??}"
		set -- "$@" "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		LC_ALL=C fold -b -w100 | { # fold width must be a multiple of 4
			# workaround for nawk: https://github.com/onetrueawk/awk/issues/38
			[ "$2" = '=' ] && set -- "$1" '\075' "$3"
			LC_ALL=C awk -v x="$3$1" -v p="$2" '
			function dec2bin(n, w,  r) {
				for (r = ""; n > 0; n = int(n / 2)) r = (n % 2) r
				return sprintf("%0" w "d", r)
			}
			BEGIN {
				# Process in pairs of two characters for better performance
				for (i = 0; i < 64; i++) {
				ik = substr(x, i + 1, 1); iv = dec2bin(i, 6); b[ik] = b[ik p] = iv
				for (j = 0; j < 64; j++) b[ik substr(x, j + 1, 1)] = iv dec2bin(j, 6)
				}

				for (i = 1; i < 256; i++) c[dec2bin(i, 8)] = sprintf("%c", i)
				c["00000000"] = "\\\\000"; c["00001001"] = "\\\\011" # NUL HT
				c["00001010"] = "\\\\012"; c["00001011"] = "\\\\013" # LF  VT
				c["00001100"] = "\\\\014"; c["00001101"] = "\\\\015" # FF  CR
				c["00100000"] = "\\\\040"; c["00100010"] = "\\\\042" # SPC DQ
				c["00100101"] = "\\\\045"; c["00100111"] = "\\\\047" # %   SQ
				c["01011100"] = "\\\\\\\\"
			}
			{
				len = length($0); bits = chars = ""
				for (i = 1; i <= len; i+=2) bits = bits b[substr($0, i, 2)]
				for (i = 1; i <= len * 6; i+=8) chars = chars c[substr(bits, i, 8)]
				print chars
			}
			'
		} | (
			for_mksh='[ ${KSH_VERSION:+x} ] && alias printf="print -n";'
			code='IFS=; printf -- "$*"' prog="${ZSH_ARGZERO:-"$0"}"
			LC_ALL=C xargs -n 1000 -E '' sh -c "${for_mksh}${code}" "$prog"
		)
	}

	bobshell_base64_decode() {
		bobshell_redirect_io "$1" "$2" bobshell_base64_decode_awk
	}
fi