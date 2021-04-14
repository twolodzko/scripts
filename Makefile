.DEFAULT_GOAL := help
.PHONY: install check help

check: *.sh
	shellcheck $?

install: *.sh
ifeq ($(PREFIX),)
	$(error Installation PREFIX was not privided)
endif
	@ echo "Installing:"
	@ chmod +x $?
	@ mkdir -p $(PREFIX)
	@ for file in $?; do \
		cp -v "$${file}" "${PREFIX}"/"$${file%.sh}" ; \
	done

help:
	@ echo "Available commands:"
	@ echo
	@ echo "make check"
	@ echo "make install PREFIX=${PREFIX}"
