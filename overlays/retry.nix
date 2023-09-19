final: super:
let inherit (super) pkgs lib;
in {
  my-loon = pkgs.buildGo118Module rec {
    pname = "retry";
    version = "0.7.2";
    vendorSha256 = "sha256-7X4fY5XYRr0haJMZstiXB9vDlAXzwqnym2wetCSW1Lo=";
    src = pkgs.fetchurl {
      url =
        "https://github.com/moul/retry/archive/refs/tags/v${version}.tar.gz";
      sha256 = "sha256-Xz+bWQgAcDZa+LTcT/T17HdD3Z22Te6XciZKbnGpdcQ=";
    };

    meta = with lib; {
      description = "dynamic realtime pager";
      maintainers = [ maintainers.moul ];
    };
  };
}
