{ config, lib, pkgs, ... }:

let configsd = "~/go/src/moul.io/nixpkgs/configs";
in {
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.ssh.enable

  #programs.ssh = {
  #  enable = true;
  #  controlMaster = "auto";
  #  controlPath = "${config.xdg.cacheHome}/ssh-%u-%r@%h:%p";
  #  controlPersist = "1800";
  #  forwardAgent = true;
  #  serverAliveInterval = 60;
  #  hashKnownHosts = true;
  #  extraConfig = ''
  #    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  #  '';
  #};

  home.activation.sshHook = config.lib.dag.entryAfter [
    "reloadSystemd"
    "writeBoundary"
    "onFilesChange"
    "installPackages"
  ] ''
    # ssh
    mkdir -p ~/.ssh;
    ln -sf ${configsd}/assh.yml ~/.ssh/assh.yml;
    ${pkgs.assh}/bin/assh config build > ~/.ssh/config;
    chmod 711 ~/.ssh
    chmod 600 ~/.ssh/config || true
  '';
}
