
ensure_file_dir() {
	_ensure_file_dir=$(dirname "$1")
	mkdir -p "$_ensure_file_dir"
	unset _ensure_file_dir
}