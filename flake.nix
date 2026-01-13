{
  description = "JackTrip - High-quality audio network performance system";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system: f nixpkgs.legacyPackages.${system}
      );
  in {
    packages = forAllSystems (pkgs: {
      jacktrip = import ./default.nix {inherit pkgs;};
      default = self.packages.${pkgs.system}.jacktrip;
    });

    apps = forAllSystems (pkgs: {
      jacktrip = {
        type = "app";
        program = "${self.packages.${pkgs.system}.jacktrip}/bin/jacktrip";
      };
      default = self.apps.${pkgs.system}.jacktrip;
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        inputsFrom = [self.packages.${pkgs.system}.jacktrip];

        packages = with pkgs;
          [
            # C++ development
            clang-tools
            cmake-format

            # Qt development
            qt6.qttools

            # Documentation
            help2man
            doxygen
          ]
          ++ lib.optionals stdenv.isLinux [
            # Linux-specific tools
            gdb
            valgrind
          ]
          ++ lib.optionals (stdenv.isLinux && pkgs ? qt6.qtcreator) [
            qt6.qtcreator
          ];

        shellHook = ''
          echo "JackTrip Development Shell"
          echo ""
          echo "Build commands:"
          echo "  meson setup builddir -Dqtversion=6 -Djack=enabled"
          echo "  meson compile -C builddir"
          echo "  ./builddir/jacktrip --version"
        '';
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);
  };
}
