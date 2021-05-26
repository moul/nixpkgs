apply:
	home-manager switch

test:
	docker run -v "$(PWD):/root/dotfiles" -w /root/dotfiles -it --rm nixos/nix \
		nix-shell -p stow --run 'make install-flake setup-cachix _setup USER=dockerTest'

SETENV = . ~/.nix-profile/etc/profile.d/nix.sh
_setup:
	mkdir -p ~/.config
	ln -sf $(PWD) ~/.config/nixpkgs
	#$(SETENV); nix build .#moul.activationPackage
	$(SETENV); nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	$(SETENV); nix-channel --update
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
	echo "exec ~/.nix/nix-user-chroot ~/.nix ~/.nix-profile/bin/zsh -l" > ~/nixsh
	chmod 711 ~/nixsh
	~/.nix/nix-user-chroot ~/.nix make apply

fmt:
	nixfmt `find . ! -path './home-manager/*' ! -path './.git/*' -name "*.nix"`

install-flake:
	nix-env -iA nixpkgs.nixFlakes
	nix-env -iA nixpkgs.curl
	nix-env -iA nixpkgs.git
	if [ ! -f ~/.config/nix/nix.conf ]; then \
		mkdir -p ~/.config/nix; \
		echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf; \
	fi
	curl -L https://github.com/numtide/nix-flakes-installer/releases/download/nix-3.0pre20200804_ed52cf6/install | sh

setup-cachix:
	nix-env -iA cachix -f https://cachix.org/api/v1/install
	cachix use nix-community

regen-emacs:
	raw-emacs --batch --load=~/.spacemacs -debug-init
	#raw-emacs --eval='(configuration-layer/load)' --quit --debug-init
	raw-emacs --no-site-file --batch --load=~/.spacemacs --eval="(package-initialize)"
