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
          sha256 = "sha256-9lXQD5/pqjvos+/ddl9AbVfUNnzZbuYfN7P7qe+Q/dM=";
        };

        vendorHash = "sha256-or0OKi5oM7evulRzG4r/WvhZmFAcM10zJxZaXA3U2I8=";

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
