DESTDIR := ${HOME}/.local/bin/
.DEFAULT_GOAL := help
.PHONY: install check help

check:
	@ for file in $$(ls -I Makefile); do \
		printf "Checking: %s\n" "$$file"; \
		shellcheck "$$file"; \
	done

install:
	@ for file in $$(ls -I Makefile); do \
		chmod +x "$$file"; \
		cp -v "$$file" ${DESTDIR}; \
	done

help:
	@ echo "Available commands:"
	@ echo
	@ echo "make check"
	@ echo "make install DESTDIR=${DESTDIR}"
