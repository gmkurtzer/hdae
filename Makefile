.PHONY: check

check:
	sh -n install.sh
	shellcheck -s sh install.sh tests/install.sh
	./tests/install.sh
