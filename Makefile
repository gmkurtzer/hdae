.PHONY: check

check:
	sh -n install.sh
	shellcheck -s sh install.sh tests/install.sh tests/fixtures/bin/sha256sum
	./tests/install.sh
