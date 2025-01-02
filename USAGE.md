# `main.bash` Usage

`main.bash` is a library, so you'll be using it in some other Bash script. Start
writing your script, and `source "main.bash"`.

With `main.bash` included in your script, you'll define one or more of the
functions described below, and they'll be called at the appropriate time. Use
whichever you like; **they're all optional**.

These functions are called at startup, in this order:

1. `handle_option`
2. `handle_arguments`
3. `validate_input`
4. `main`

A couple of others are called when/if your script receives a supported signal
(^C, SIGHUP, etc.):

- `reload`
- `quit`

## Examples

A couple of short examples are provided, to get you started. See
[`examples/`](examples/).

## Functions

### Startup

#### `handle_arguments(arg...)`

Any _non-option_ arguments passed to your script will be passed through to this
function. This is a good place to save that input for later.

```bash
source "main.bash"

INPUT=

function handle_arguments() {
  INPUT="$1"
}

function main() {
  echo "You passed: $INPUT"
}
```

```bash
$ bash myscript.bash "an argument"
You passed: an argument
```

#### `handle_option(name, [value])`

If your script supports options, and any are passed when the script is executed,
`main.bash` will call `handle_option`. It'll be called more than once: one time
for each option provided on the command line, and one _extra_ time at startup,
so you can declare which options you support.

That extra call explains the `OPT_SPEC` line below: The function is always
called once with a special `-` argument. In that case you're expected to export
`OPT_SPEC`, set to a valid `getopts` option string. See the [Bash getopts
manual](https://www.gnu.org/software/bash/manual/bash.html#index-getopts)
to learn about that "optstring" format.

```bash
source "main.bash"

DIR=
VERBOSE=

function handle_option() {
  local OPT="$1"
  local VALUE="$2"

  case "$OPT" in
    -) export OPT_SPEC=":d:v";;
    d) DIR="$VALUE";;
    v) VERBOSE=1;;
  esac
}

function main() {
  echo "Dir: $DIR"
  [[ "$VERBOSE" == "1" ]] && echo "Verbose: enabled"
}
```

```bash
$ bash myscript.bash -d /tmp -v
Dir: /tmp
Verbose: enabled
```

`main.bash` will also compare any options passed by the user against
`$OPT_SPEC`, and exit if unknown options are passed (even if you don't define
`handle_option()`):

```bash
$ bash myscript.bash -x
Error: Unknown option (-x)
```

#### `main()`

If you define a `main()` function, it'll be called automatically at startup.
This one doesn't provided any extra functionality; it just helps keep your
script tidy.

```bash
source "main.bash"

function main() {
  echo "Hello, World!"
}
```

```bash
$ bash myscript.bash
Hello, World!
```

#### `validate_input()`

Like `main()`, this is just about keeping things neat. `validate_input` is
called after handling options and arguments, but before `main`, giving you a
chance to exit early if the user provided bad input.

```bash
source "main.bash"

INPUT=

function handle_arguments() {
  INPUT="$1"
}

function validate_input() {
  if [[ "$INPUT" != "good input" ]]; then
    echo "Error: bad input" >&2
    return 1
  fi
}

function main() {
  echo "You passed: $INPUT"
}
```

```bash
$ bash myscript.bash "good input"
You passed: good input
$ bash myscript.bash "not so good input"
Error: bad input
```

### Signal Handlers

#### `reload()`

Handle SIGHUP, often used to reload configuration.

```bash
source "main.bash"

function main() {
  while true; do
    echo -n .; sleep 1
  done
}

function reload() {
  # in practice we'd do something useful here, like reloading config from disk
  echo -e "\nreload was called"
}
```

```bash
$ bash myscript.bash &
$ MYSCRIPT_PID=$!
$ sleep 5 && kill -HUP $MYSCRIPT_PID
.....
reload was called
$ fg
........^C
```

#### `quit()`

Handle SIGINT or SIGTERM, often used to clean up before shutting down.

```bash
source "main.bash"

function main() {
  while true; do
    echo -n .; sleep 1
  done
}

function quit() {
  # in practice we'd do something useful here, like persisting some data to disk
  echo -ne "\ncleaning up"
}
```

```bash
$ bash myscript.bash
.....^C
cleaning up 
```
