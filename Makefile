.PHONY: init
init:
	git config core.hooksPath .hooks

.PHONY: go
go: gofmt gotidy gocheck gotest gobuild

.PHONY: gofmt
gofmt:
	# find all go-source files and format them.
	find . -type f -regex ".*\.go" -exec gofmt -w {} \; | wc -l | grep -q 0

.PHONY: gotidy
gotidy:
	# find all directorys contaning a go.mod file and run go mod tidy to update go.mod and go.sum
	for dir in $$(find . -type d -exec test -e '{}'/go.mod \; -print ); \
		do $$(cd $$dir; go mod tidy; \
		touch go.mod); \
	done

.PHONY: gocheck
gocheck: gonewer
	# find all go-source files and fail if one is not formated
	find . -type f -regex ".*\.go" -exec gofmt -l {} \; | wc -l | grep -q 0

.PHONY: gonewer
gonewer:
	# search for newer go files than go.mod files.
	for dir in $$(find . -type d -exec test -e '{}'/go.mod \; -print ); \
		do newer=$$(cd $$dir; find . -type f -regex ".*\.go" -newer go.mod ); \
		if [ "$$newer" ];then echo "there are newer go-files then the go.mod files: please run 'make gotidy'"; \
			exit 1; \
		fi; \
	done

.PHONY: gobuild
gobuild:
	# build the server executable
	cd server; \
	go build -o soti-server

.PHONY: generate
generate:
	cd server/api/generated
	protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative protos/api.proto

.PHONY: gotest
gotest:
	# run all the go tests
	for dir in $$(find . -type d -exec test -e '{}'/_test.go \; -print ); \
		do go test; \
	done

.PHONY: flutter
flutter: flutterfmt flutterget fluttercheck flutternewer flutterupgrade flutterbuild

.PHONY: flutterfmt
flutterfmt:
	# format all files in app
	flutter format app/

.PHONY: flutterget
flutterget:
	# install dependencies specified in pubspec.yaml
	cd app/; \
	flutter pub get

.PHONY: fluttercheck
fluttercheck:
	# check all dart files in app/
	cd app/; \
	flutter analyze --no-pub

.PHONY: flutternewer
flutternewer:
	# list outdated files
	cd app; \
	flutter pub outdated --show-all

.PHONY: flutterupgrade
flutterupgrade:
	# upgrade pubspec dependencies
	cd app/; \
	flutter pub upgrade --no-offline

.PHONY: flutterbuild
flutterbuild:
	# build soTired app
	cd app/; \
	flutter build apk --release

.PHONY: fluttertest
fluttertest:
	cd app/; \
	flutter test
