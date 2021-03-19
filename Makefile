.DEFAULT_GOAL := help
.PHONY: install check help

check: *.sh
	shellcheck $?

install: *.sh
ifeq ($(DESTDIR),)
	$(error Installation DESTDIR was not privided)
endif
	@ echo "Installing:"
	@ chmod +x $?
	@ mkdir -p $(DESTDIR)
	@ for file in $?; do \
		cp -v "$${file}" "${DESTDIR}"/"$${file%.sh}" ; \
	done

help:
	@ echo "Available commands:"
	@ echo
	@ echo "make check"
	@ echo "make install DESTDIR=${DESTDIR}"
