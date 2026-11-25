{
  description = "Flake for wl-kbptr";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    wl-kbptr = {
      url = "github:moverest/wl-kbptr";
      flake = false;
    }
  };

  outputs = {self, nixpkgs, wl-kbptr, ...}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      meta = {
        description = "Flake for wl-kbptr";
        platform = [ "${system}" ];
        mainProgram = "wl-kbptr";
      };

      inherit (pkgs)
        lib
        fetchFromGitHub
        gtk3
        libxkbcommon
        meson
        ninja
        opencv
        pixman
        pkg-config
        stdenv
        wayland
        wayland-protocols
        wayland-scanner;

      wl-kbptr-pkg =
      stdenv.mkDerivation (finalAttrs: {
        pname = "wl-kbptr";
        version = "unstable-${wl-kbptr.shortRev}";

        src = wl-kbptr;

        depsBuildBuild = [ pkg-config ];

        nativeBuildInputs = [
          meson
          ninja
          pkg-config
          wayland-scanner
        ];

        buildInputs = [
          gtk3
          libxkbcommon
          opencv
          pixman
          wayland
          wayland-protocols
        ];

        mesonFlags = [ "-Dopencv=enabled" ];

        strictDeps = true;

        meta = {
          homepage = "https://github.com/moverest/wl-kbptr";
          description = "Control the mouse pointer with the keyboard on Wayland";
          license = lib.licenses.gpl3;
          mainProgram = "wl-kbptr";
          maintainers = [
            lib.maintainers.luftmensch-luftmensch
            lib.maintainers.clementpoiret
          ];
          inherit (wayland.meta) platforms;
        };
      });
    in {
      packages.${system} = {
        default = wl-kbptr-pkg;
        wl-kbptr = wl-kbptr-pkg;
      };
    };
}
