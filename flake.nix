{
  description = "A simple script";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {

      # Set the default package for the system
      defaultPackage = pkgs.writeShellScriptBin "capture-pane-to-nvim" ''
        ${./index.sh}
      '';
    }
  );
}
