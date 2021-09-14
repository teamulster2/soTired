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
		do $$(cd $$dir; go mod tidy -e; \
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
		do newer=$$(cd $$dir; find . -type f -regex ".*\.go" -newer go.mod -print ); \
		if [ "$$newer" ];then echo "there are newer go-files then the go.mod files:"; \
			echo $$newer ;\
			echo "please run 'make gotidy'"; \
			echo "and add all then changed files."; \
			exit 1; \
		fi; \
	done

.PHONY: gobuild
gobuild:
	# build the server executable
	cd server; \
	go build -o soti-server

.PHONY: gotest
gotest:
	# run all the go tests
	cd server/cmd; \
	go test;

.PHONY: flutter
flutter: flutterFmt flutterPubGet flutterCheck flutterNewer flutterPubUpgrade flutterBuild flutterRun

.PHONY: flutterFmt
flutterFmt:
	# format all files in app
	flutter format app/

.PHONY: flutterPubGet
flutterPubGet:
	# install dependencies specified in pubspec.yaml
	cd app/; \
flutter pub get

.PHONY: flutterCheck
flutterCheck:
	# check all dart files in app/
	cd app/; \
flutter analyze --no-pub

.PHONY: flutterNewer
flutterNewer:
	# list outdated files
	cd app; \
flutter pub outdated --show-all

.PHONY: flutterPubUpgrade
flutterPubUpgrade:
	# upgrade pubspec dependencies
	cd app/; \
flutter pub upgrade --no-offline

.PHONY: flutterBuild
flutterBuild:
	# build soTired app
	cd app/; \
flutter build apk --release

.PHONY: flutterTest
flutterTest:
	# Run tests for soTired app
	cd app/; \
flutter test

.PHONY: flutterGenerate
flutterGenerate:
	# Generate TypeAdapters / Mocks for soTired app
	cd app/; \
flutter packages pub run build_runner build --delete-conflicting-outputs

.PHONY: flutterRun
flutterRun:
	# Run soTired app
	cd app/; \
flutter run --enable-software-rendering --verbose --verbose-system-logs
