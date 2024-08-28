{
  description = "A simple flake to run Regolith, a compiler for Minecraft Bedrock.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {inherit system;};

      regolith = pkgs.buildGoModule rec {
        pname = "regolith";
        version = "1.4.1";

        src = pkgs.fetchFromGitHub {
          owner = "Bedrock-OSS";
          repo = pname;
          rev = version;
          sha256 = "sha256-HZOkUyLBnBk3KOizpADrl6fBLY8mA10AI37rJDloaOs";
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
        default = self.packages.${system}.regolith;
      };
    });
}
