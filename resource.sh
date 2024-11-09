




# РЕСУРСЫ И ЛОКАТОРЫ

# file:123.txt, var:FILE_NAME, val:
parse_locator() {
  case "${1:-}" in 
    file:* | stdin:* | stdout:* | var:* | val:* ) split "$1" : "${2:-parse_locator_type}" "${3:-parse_locator_ref}" ;;
    default) die "unrecognized locator: $1";;
  esac
}

parse_locators() {
  parse_locators_all_types=
  i=1
  for parse_locators_locator in "$@"; do
    parse_locator "$parse_locators_locator"
    putvar "parse_locators_${i}_type" "$parse_locator_type"
    putvar "parse_locators_${i}_ref" "$parse_locator_ref"
    parse_locators_all_types="${parse_locators_all_types}${parse_locators_all_types:+:}$parse_locator_type"
    i=$((i+1))
  done
}

# fun: copy_resource <resourcelocator1> <resourcelocator2>
copy_resource() {
  parse_locator "$1"
  #assert_not_equals val "$parse_locator_type" 'output locator type cannot be val'
  copy_resource_input_type="$parse_locator_type"
  copy_resource_input_ref="$parse_locator_ref"

  parse_locator "$2"
  copy_resource_output_type="$parse_locator_type"
  copy_resource_output_ref="$parse_locator_ref"

  copy_${copy_resource_input_type}_to_${copy_resource_output_type} "$copy_resource_input_ref" "$copy_resource_output_ref"

  unset parse_locator_type unset parse_locator_ref
  unset copy_resource_input_type unset copy_resource_input_ref
  unset copy_resource_output_type unset copy_resource_output_ref
}


copy_val_to_val()       { test "$1" = "$2" || die 'cannot write to val resource'; }
copy_val_to_var()       { eval "$2='$1'"; }
copy_val_to_stdin()     { die  'cannot write to stdin resource'; }
copy_val_to_stdout()    { printf %s "$1"; }
copy_val_to_file()      { printf %s "$1" > "$2"; }


copy_var_to_val()       { die 'cannot write to val resource'; }
copy_var_to_var()       { test "$1" = "$2" || eval "$2=\${$1}"; }
copy_var_to_stdin()     { die  'cannot write to stdin resource'; }
copy_var_to_stdout()    { eval "printf %s \"\$$1\""; }
copy_var_to_file()      { eval "printf %s \"\$$1\"" > "$2"; }


copy_stdin_to_val()     { die 'cannot write to val resource'; }
copy_stdin_to_var()     { eval "$2=\$(cat)"; }
copy_stdin_to_stdin()   { die 'cannot write to stdin resource'; }
copy_stdin_to_stdout()  { cat; }
copy_stdin_to_file()    { cat > "$2"; }

copy_stdout_to_val()    { die 'cannot read from stdout resource'; }
copy_stdout_to_var()    { die 'cannot read from stdout resource'; }
copy_stdout_to_stdin()  { die 'cannot read from stdout resource'; }
copy_stdout_to_stdout() { die 'cannot read from stdout resource'; }
copy_stdout_to_file()   { die 'cannot read from stdout resource'; }


copy_file_to_val()      { die 'cannot write to val resource'; }
copy_file_to_var()      { eval "$2=\$(cat '$1')"; }
copy_file_to_stdin()    { die 'cannot write to stdin resource'; }
copy_file_to_stdout()   { cat "$1"; }
copy_file_to_file()     { test "$1" = "$2" || { mkdir -p "$(dirname "$2")" && rm -rf "$2" && cp "$1" "$2";}; }



# fun: resource_as_file <resource> <file name resource>
resource_as_file() {
  parse_locator "$1" resource_as_file__type resource_as_file__ref
  # shellcheck disable=SC2154
  if [ 'file' = "$resource_as_file__type" ]; then
    copy_resource var:resource_as_file__ref "$2"
  else
    # shellcheck disable=SC2034
    resource_as_file__result="$(mktemp)"
    copy_resource "$1" "file:$resource_as_file__result"
    copy_resource var:resource_as_file__result "$2"
    unset resource_as_file__result
  fi
  unset resource_as_file__type resource_as_file__ref
}

make_temp_resource() {
  die 'not implemented'
}

# txt: загрузить ресурс и выполнить как sh-скрипт eval 
eval_resource() {
  eval_resource_data=
  copy_resource "$1" var:eval_resource_data
  eval "$eval_resource_data"
}

# txt: заполнить в строке переменные
# use: VALUE=hello; echo 'msg is $VALUE' | interpolate_resource stdin: stdout: # gives: msg is hello
interpolate_resource() {
  interpolate_resource_data=
  copy_resource "$1" var:interpolate_resource_data
  # shellcheck disable=SC2034
  interpolate_resource_result=$(eval "cat <<EOF
$interpolate_resource_data
EOF
")
  copy_resource var:interpolate_resource_result "$2"
}

