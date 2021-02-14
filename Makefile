test:
	docker run -v "$(PWD):/root/dotfiles" -w /root/dotfiles -it --rm nixos/nix \
	  nix-shell -p stow --run 'make _setup'

_setup:
	source ~/.nix-profile/etc/profile.d/nix.sh
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	nix-shell '<home-manager>' -A install
	home-manager switch
