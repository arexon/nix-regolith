{
  description = "A simple flake to run Regolith, a compiler for Minecraft Bedrock.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      regolith = pkgs.buildGoModule rec {
        pname = "regolith";
        version = "1.5.0";

        src = pkgs.fetchFromGitHub {
          owner = "arexon";
          repo = pname;
          rev = "fsnotify-dir-watcher";
          sha256 = "sha256-SKvEb0F4At7A9v/C5XC1XfjaVZ+9ciZGrgMN9R+BYnw=";
        };

        vendorHash = "sha256-+4J4Z7lhbAphi6WUEJN9pzNXf6ROUKqN4NdKI2sQSW0=";

        patchPhase = ''
          sed -i 's/unversioned/${version}/g' main.go
        '';

        checkPhase = null;
      };
    in {
      formatter = pkgs.alejandra;

      packages = {
        inherit regolith;
        default = regolith;
      };
    });
}
