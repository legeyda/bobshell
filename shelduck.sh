

load_shelduck() {

	# or just one line
	# eval "$(curl -fsSL https://raw.githubusercontent.com/legeyda/shelduck/refs/heads/main/shelduck.sh)"


	if [ 0 = "$(id -u)" ]; then
		printf 'not supposed to run as root\n' >&2
		exit 1
	fi

	: "${SHELDUCK_LIBRARY_PATH:=$HOME/.cache/bobtest/shelduck.sh}"
	if [ ! -r "$SHELDUCK_LIBRARY_PATH" ]; then
		SHELDUCK_LIBRARY_PATH_DIR=$(dirname "$SHELDUCK_LIBRARY_PATH")
		mkdir -p "$SHELDUCK_LIBRARY_PATH_DIR"
		: "${SHELDUCK_LIBRARY_PATH_URL:=https://raw.githubusercontent.com/legeyda/shelduck/refs/heads/main/shelduck.sh}"
		curl --fail --silent --show-error --location --output - "$SHELDUCK_LIBRARY_PATH_URL" > "$SHELDUCK_LIBRARY_PATH"
	fi

	SHELDUCK_LIBRARY_PATH=$(realpath "$SHELDUCK_LIBRARY_PATH")
	. "$SHELDUCK_LIBRARY_PATH"

}

install_shelduck() {
	true
}

load_shelduck