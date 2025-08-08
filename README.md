# bobshell

A library of reusable shell functions for the [shelduck](https://github.com/legeyda/shelduck) tool.

## Features
- Modular shell scripts for common tasks (arrays, strings, maps, buffers, CLI parsing, etc.)
- Consistent function naming and result handling
- Designed for composability and testability

## Installation
Clone this repository and source the required modules in your shell scripts:
```sh
git clone https://github.com/legeyda/bobshell.git
source /path/to/bobshell/base.sh
```

## Usage Guidelines

**Avoid this pattern:**
```sh
foo() {
    printf %s xyz
}
foo=$(bar)
```

**Use this instead:**
```sh
foo() {
    bobshell_result_set xyz
}
bobshell_result_read foo
```

### Why?
1. Function calls inside `$()` cannot have side effects.
2. `$()` strips trailing newlines from output strings.

See `test_shell.sh:test_output_redirection` for more details.

## Modules
- `array/` – Array operations (add, remove, foreach, etc.)
- `map/` – Key-value map utilities
- `base64/` – Encoding/decoding
- `buffer/` – Buffer management
- `cli/` – Command-line parsing and help
- `code/` – Code generation helpers
- `event/` – Event handling
- `git/` – Git utilities
- `locator/` – File and value locators
- `log/` – Logging helpers
- `misc/` – Miscellaneous utilities
- `random/` – Random number generation
- `redirect/` – Input/output redirection
- `regex/` – Regex matching
- `resource/` – Resource management
- ...and more

## Testing
Run the test scripts to verify functionality:
```sh
./test.sh
```
Or run individual module tests, e.g.:
```sh
./array/test_add.sh
```

## Contributing
Contributions are welcome! Please submit issues or pull requests via GitHub.

## License
MIT License