# Master Makefile to compile everything in /usr/src except the system.

MAKE	= exec make -$(MAKEFLAGS)

usage:
	@echo "" >&2
	@echo "Master Makefile for MINIX commands and utilities." >&2
	@echo "Root privileges are required for some actions." >&2
	@echo "" >&2
	@echo "Usage:" >&2
	@echo "	make world      # Compile everything (libraries & commands)" >&2
	@echo "	make includes   # Install include files from src/" >&2
	@echo "	make libraries  # Compile and install libraries" >&2
	@echo "	make cmds       # Compile commands, but don't install" >&2
	@echo "	make install    # Compile and install commands" >&2
	@echo "	make depend     # Generate required .depend files" >&2
	@echo "	make clean      # Remove all compiler results" >&2
	@echo "" >&2
	@echo "Run 'make' in tools/ to create a new MINIX configuration." >&2; exit 0
	@echo "" >&2

# world has to be able to make a new system, even if there
# is no complete old system. it has to install commands, for which
# it has to install libraries, for which it has to install includes,
# for which it has to install /etc (for users and ownerships).
# etcfiles also creates a directory hierarchy in its
# 'make install' target.
world:	etcfiles includes libraries cmds install

includes:
	cd include && $(MAKE) install

libraries:
	cd lib && $(MAKE) install

cmds:
	cd commands && $(MAKE) all

install::
	cd commands && $(MAKE) $@

depend::
	/usr/bin/mkdep /usr/src/kernel
	/usr/bin/mkdep /usr/src/servers
	/usr/bin/mkdep /usr/src/drivers


clean::
	cd lib && $(MAKE) $@
	test ! -f commands/Makefile || { cd commands && $(MAKE) $@; }

etcfiles::
	cd etc && $(MAKE) install

all install clean::
	cd boot && $(MAKE) $@
	cd man && $(MAKE) $@	# First manpages, then commands
	test ! -f commands/Makefile || { cd commands && $(MAKE) $@; }
	cd tools && $(MAKE) $@
	cd servers && $(MAKE) $@

