#!/usr/bin/env bash
set -Eeuxo pipefail

# Supported OS check
case "$(uname)" in
  Linux)
    if ! [ -x "$(command -v apt-get)" ]; then
      echo 'Only Debain based linux are supported.'
      exit 1
    fi
    ;;
  Darwin)
    ;;
  *)
    echo "Unsupported OS"
    exit 1
    ;;
esac

if [[ "$(uname)" == "Linux" ]]; then
  # Install `sudo` command for container build.
  (apt-get update && apt-get install -y sudo) && :
  # Deps needed to download & run Nix install script.
  sudo apt-get install -y curl xz-utils
fi

# Stop Nix services
case "$(uname)" in
  Linux)
    # https://github.com/NixOS/nix/blob/b7e712f9fd3b35e7b75180fcfbe90dce6c9b06a4/scripts/install-systemd-multi-user.sh
    sudo systemctl stop nix-daemon.socket || :
    sudo systemctl stop nix-daemon.service || :
    sudo systemctl disable nix-daemon.socket || :
    sudo systemctl disable nix-daemon.service || :
    sudo systemctl daemon-reload || :
    ;;
  Darwin)
    # https://github.com/NixOS/nix/blob/b7e712f9fd3b35e7b75180fcfbe90dce6c9b06a4/doc/manual/src/installation/uninstall.md
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist || :
    sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist || :
    sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist || :
    sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist || :
    ;;
esac

# If Nix is previously installed, new nix installation will complain these files
# already exist and fail.  So restore them if they exist
sudo mv /etc/zshrc.backup-before-nix /etc/zshrc || :
sudo mv /etc/bashrc.backup-before-nix /etc/bashrc || :
sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc || :
sudo mv /etc/profile.d/nix.sh.backup-before-nix /etc/profile.d/nix.sh || :

# Install Nix https://nixos.org/download.html
sh <(curl -L https://nixos.org/nix/install --connect-timeout 5 --retry 3) --daemon --no-channel-add --no-modify-profile --yes
set +u # the following script has an intended unbound variable.
# shellcheck disable=SC1091  # /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh is generated.
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
set -u
# https://nixos.org/manual/nix/stable/command-ref/conf-file.html
mkdir -p ~/.config/nix/
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
