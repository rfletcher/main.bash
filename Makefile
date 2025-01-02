all: lint test

lint:
	@echo Linting with \`shellcheck\`...
	@shellcheck --severity style main.bash

test:
	@echo "Running tests..."
	@bats tests/
