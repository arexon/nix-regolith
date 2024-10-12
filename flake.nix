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
          sha256 = "sha256-7pSVS+HzwL0pJl5z62uZvM/2WZI8hscUReZTuekWb8E=";
        };

        vendorHash = "sha256-+4J4Z7lhbAphi6WUEJN9pzNXf6ROUKqN4NdKI2sQSW0=";

        doCheck = false;
        ldflags = [
          "-X main.buildSource=nix"
          "-X main.version=${version}"
          "-X main.commit=${src.rev}"
          "-X main.date=19700101-00:00:00"
        ];
      };
    in {
      formatter = pkgs.alejandra;

      packages = {
        inherit regolith;
        default = regolith;
      };
    });
}
