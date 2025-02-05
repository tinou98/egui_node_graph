{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    crane,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      craneLib = crane.mkLib pkgs;
      dlopenedLibs = [
        pkgs.wayland
        pkgs.libxkbcommon
        pkgs.libglvnd
      ];
    in {
      formatter = pkgs.alejandra;
      devShells.default = craneLib.devShell {
        packages = with pkgs; [rust-analyzer];
        LD_LIBRARY_PATH = lib.makeLibraryPath dlopenedLibs;
      };
    });
}
