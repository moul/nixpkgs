final: super:
let pkgs = super.pkgs;
in {
  my-libvterm = pkgs.stdenv.mkDerivation rec {
    pname = "libvterm";
    version = "0.3.2";

    src = pkgs.fetchurl {
      url =
        "https://launchpad.net/libvterm/trunk/v0.3/+download/libvterm-${version}.tar.gz";
      sha256 = "sha256-ketQiAafTm7atp4UxCEvbaAZLmVpWVbcBIAWoNq4vPY=";
    };

    nativeBuildInputs = with pkgs; [ libtool gnulib pkg-config ];

    preInstall = ''
      mkdir -p $out/include
      mkdir -p $out/lib
    '';

    preBuild = ''
      makeFlagsArray+=(PREFIX=$out LIBTOOL="libtool")
    '';

    buildInputs = with pkgs; [ gcc perl glib ncurses ];

    meta = with pkgs.lib; {
      homepage = "https://launchpad.net/libvterm";
      description =
        "An abstract library implementation of a DEC VT/xterm/ECMA-48 terminal emulator.";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
}
