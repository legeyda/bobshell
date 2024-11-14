

load_shelduck() {

	# or just one line
	# eval "$(curl -fsSL https://raw.githubusercontent.com/legeyda/shelduck/refs/heads/main/shelduck.sh)"


	if [ 0 = "$(id -u)" ]; then
		printf 'not supposed to run as root\n' >&2
		exit 1
	fi

	: "${SHELDUCK_LIB:=$HOME/.cache/bobtest/shelduck.sh}"
	if [ ! -r "$SHELDUCK_LIB" ]; then
		SHELDUCK_LIB_DIR=$(dirname "$SHELDUCK_LIB")
		mkdir -p "$SHELDUCK_LIB_DIR"
		: "${SHELDUCK_LIB_URL:=https://raw.githubusercontent.com/legeyda/shelduck/refs/heads/main/shelduck.sh}"
		curl --fail --silent --show-error --location --output - "$SHELDUCK_LIB_URL" > "$SHELDUCK_LIB"
	fi

	SHELDUCK_LIB=$(realpath "$SHELDUCK_LIB")
	. "$SHELDUCK_LIB"

}

install_shelduck() {
	true
}

load_shelduck