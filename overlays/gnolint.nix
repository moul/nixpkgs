final: super:
let inherit (super) pkgs lib fetchFromGitHub fetchGitLocal;
in {
  my-gnolint = pkgs.buildGo121Module rec {
    pname = "gnolint";
    vendorHash = "sha256-OLHcsJrLC4rzuqtlrr2+MMu1LYbH5DuC7fRcC9Bi6Kw=";
    version = "b3ff1d71fcf09be37d3356908a8cc5147304c763";
    # version = "v8-beta";
    # src = /Users/gfanton/code/gnolang/gno;
    src = fetchFromGitHub {
      owner = "gfanton";
      repo = "gno";
      # The specific commit hash you want to fetch
      rev = "${version}"; # replace with the desired commit hash
      sha256 =
        "sha256-jOyv/w5AyaEPwoMC4KUpTgdcu7S7Wh0pz4FAtwid990="; # you will have to compute this
    };

    doCheck = false;
    buildPhase = ''
      go build -ldflags "-X github.com/gnolang/gno/tm2/pkg/amino.buildDir=$out/src" -o $out/bin/gno ./gnovm/cmd/gno
    '';
    installPhase = ''
      cp -r ./ $out/src
      mv $out/bin/gno $out/bin/gnolint
    '';
    meta = {
      description = "";
      maintainers = with lib.maintainers; [ gfanton ];
    };
  };
}
