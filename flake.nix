{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              stJD = prev.st.overrideAttrs (oldAttrs: rec {
                version = "master";
                src = ./.;
              });
            })
          ];
        };
      in
      rec {
        apps = {
          st = {
            type = "app";
            program = "${defaultPackage}/bin/st";
          };
        };

        packages.stJD = pkgs.stJD;
        defaultApp = apps.st;
        defaultPackage = pkgs.stJD;
      }
    );
}
