{ config, lib, inputs, pkgs, ... }:

let
  #unstable = import <unstable> { };
in {
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.go.enable
  # home.sessionVariables = { GOROOT = [ "${unstable.go.out}/share/go" ]; };

  home.packages = with pkgs; [ delve golangci-lint gopls gotags ];
  # go-tools

  programs.go = {
    enable = true;
    package = pkgs.go_1_19;
    goBin = "go/bin";
    goPath = "go";
  };

  programs.go.packages = {
    "github.com/mdempsky/gocode" = inputs.gotools;
    "golang.org/x/tools/cmd/goimports" = inputs.gotools;
    "golang.org/x/tools/cmd/godoc" = inputs.gotools;
    "golang.org/x/tools/cmd/gorename" = inputs.gotools;
    "golang.org/x/tools/cmd/guru" = inputs.gotools;
  };
}
