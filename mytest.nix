let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;

  nix-ip = import ./ip.nix {inherit lib;};
  nix-kea = import ./kea.nix {inherit lib;};

in
  #nix-kea.cidrStrToId "192.168.22.0/24"
  nix-kea.cidrToPool "192.168.22.0/24" 10 20


