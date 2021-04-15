apply:
	home-manager switch

test:
	docker run -v "$(PWD):/root/dotfiles" -w /root/dotfiles -it --rm nixos/nix \
		nix-shell -p stow --run 'make _setup'

SETENV = . ~/.nix-profile/etc/profile.d/nix.sh 
_setup:
	ln -sf $(PWD) ~/.config/nixpkgs
	$(SETENV); nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	$(SETENV); nix-channel --update
	$(SETENV); nix-shell '<home-manager>' -A install
	$(SETENV); home-manager switch

install-darwin:
	xcode-select --install || true
	curl -L https://nixos.org/nix/install > /tmp/nix-install
	sh /tmp/nix-install --darwin-use-unencrypted-nix-store-volume
	. /Users/moul/.nix-profile/etc/profile.d/nix.sh && nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer
	rm -rf result /tmp/nix-install

upgrade:
	nix-channel --update

install-linux-no-root:
	unshare --user --pid echo YES | grep -q YES
	mkdir -p -m 0755 ~/.nix
	wget "https://github.com/nix-community/nix-user-chroot/releases/download/1.2.1/nix-user-chroot-bin-1.2.1-x86_64-unknown-linux-musl" -N -O ~/.nix/nix-user-chroot
	chmod +x ~/.nix/nix-user-chroot
	~/.nix/nix-user-chroot ~/.nix bash -c "curl -L https://nixos.org/nix/install | bash"
	~/.nix/nix-user-chroot ~/.nix make _setup
	echo "exec ~/.nix/nix-user-chroot ~/.nix zsh -l" > ~/nixsh
	chmod 711 ~/nixsh
