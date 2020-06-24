PREFIX = /usr/local

.PHONY : compile
compile:
	swift build --disable-sandbox -c release

.PHONY : install
install: compile
	sudo mkdir -p $(PREFIX)/bin
	sudo cp -p ./.build/release/monch $(PREFIX)/bin

#
# Prepare git hook
#
.PHONE : prepare_git_hook
.git/hooks/post-checkout:
	scripts/prepare-git-hook.rb $@

prepare_git_hook: .git/hooks/post-checkout
