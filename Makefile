PREFIX = /usr/local

.PHONY : compile
compile:
	swift build --disable-sandbox -c release

.PHONY : prefix_install
prefix_install: compile
	mkdir -p $(PREFIX)/bin
	cp -p ./.build/release/monch $(PREFIX)/bin

.PHONY : install
install:
	make prefix_install PREFIX=/usr/local

#
# Prepare git hook
#
.PHONY : prepare_git_hook
.git/hooks/post-checkout:
	scripts/prepare-git-hook.rb $@
	chmod 755 $@

prepare_git_hook: .git/hooks/post-checkout
