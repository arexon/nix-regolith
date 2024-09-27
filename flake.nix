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
          sha256 = "sha256-1nXyOojfXfcVoTUSwI96C0lJQBJZ9Zo4Ug1gUA3zd3Q=";
        };

        vendorHash = "sha256-+rr1sueoWER8IuI2bkv/vmIdfXZOydq4RjSHWBLwKsQ=";

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
