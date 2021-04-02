apply:
	home-manager switch

test:
	docker run -v "$(PWD):/root/dotfiles" -w /root/dotfiles -it --rm nixos/nix \
		nix-shell -p stow --run 'make _setup'

_setup:
	source ~/.nix-profile/etc/profile.d/nix.sh
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
	home-manager switch

install-darwin:
	xcode-select --install || true
	curl -L https://nixos.org/nix/install > /tmp/nix-install
	sh /tmp/nix-install --darwin-use-unencrypted-nix-store-volume
	. /Users/moul/.nix-profile/etc/profile.d/nix.sh && nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	./result/bin/darwin-installer
	rm -rf result /tmp/nix-install

upgrade:
	nix-channel --update
