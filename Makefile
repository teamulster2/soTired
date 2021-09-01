.PHONY: init
init:
	git config core.hooksPath .hooks

.PHONY: gofmt
gofmt:
	# find all go-source files and format them.
	find . -type f -regex ".*\.go" -exec gofmt -w {} \; | wc -l | grep -q 0

.PHONY: gotidy
gotidy:
	# find all directorys contaning a go.mod file and run go mod tidy to update go.mod and go.sum
	for dir in $$(find . -type d -exec test -e '{}'/go.mod \; -print ); do $$(cd $$dir; go mod tidy); done

.PHONY: gocheck
gocheck:
	# find all go-source files and fail if one is not formated
	find . -type f -regex ".*\.go" -exec gofmt -l {} \; | wc -l | grep -q 0
