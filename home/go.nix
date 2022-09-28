{ config, lib, pkgs, ... }:

let unstable = import <unstable> { };
in {
  # home.sessionVariables = { GOROOT = [ "${unstable.go.out}/share/go" ]; };

  home.packages = with pkgs; [ delve golangci-lint gopls gotags go-tools ];

  programs.go = {
    enable = true;
    goBin = "go/bin";
    goPath = "go";
  };

  programs.go.packages = {
    #"github.com/motemen/gore/cmd/gore" =
    #  builtins.fetchGit "https://github.com/motemen/gore";
    #"github.com/mdempsky/gocode" =
    #  builtins.fetchGit "https://go.googlesource.com/tools";
    #"golang.org/x/tools/cmd/godoc" =
    #  builtins.fetchGit "https://go.googlesource.com/tools";
    #"golang.org/x/tools/cmd/goimports" =
    #  builtins.fetchGit "https://go.googlesource.com/tools";
    #"golang.org/x/tools/cmd/gorename" =
    #  builtins.fetchGit "https://go.googlesource.com/tools";
    #"golang.org/x/tools/cmd/guru" =
    #  builtins.fetchGit "https://go.googlesource.com/tools";
    #"github.com/cweill/gotests/..." =
    #  builtins.fetchGit "https://github.com/cweill/gotests";
    #"github.com/fatih/gomodifytags" =
    #  builtins.fetchGit "https://github.com/fatih/gomodifytags";
  };
}
