BINARIES_FOLDER=/usr/local/bin
RESOURCES_FOLDER=/usr/local/share/noonian

SWIFT_SNAPSHOT=swift-3.0.1-GM-CANDIDATE
SWIFT_URL=https://swift.org/builds/$(SWIFT_SNAPSHOT)/ubuntu1404/$(SWIFT_SNAPSHOT)/$(SWIFT_SNAPSHOT)-ubuntu14.04.tar.gz

.PHONY: uninstall clean test build install linux_swift

uninstall:
	rm -rf "$(RESOURCES_FOLDER)"
	rm -f "$(BINARIES_FOLDER)/noonian"

clean:
	swift build --clean

test: clean
	swift test

build: clean
	swift build -c release

install: build
	mkdir -p $(BINARIES_FOLDER)
	mkdir -p $(RESOURCES_FOLDER)
	cp .build/release/noonian $(BINARIES_FOLDER)
	cp example.noonian.yml $(RESOURCES_FOLDER)

linux_swift:
	wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
	gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift
	wget $(SWIFT_URL)
	wget $(SWIFT_URL).sig
	gpg --verify $(SWIFT_SNAPSHOT)-ubuntu14.04.tar.gz.sig
	tar xzf $(SWIFT_SNAPSHOT)-ubuntu14.04.tar.gz
	#export PATH="${PWD}/${SWIFT_SNAPSHOT}-ubuntu14.04/usr/bin:${PATH}"
