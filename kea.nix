{lib}: let
  nix-ip = import ./ip.nix {inherit lib;};
  /*
  Converts a CIDR string into an id for Kea to use

  Type: cidrStrToId :: str -> str

  Examples:
    cidrStrToId "10.4.3.2/22"
    => "10432"
  */
  cidrStrToId = cidr:
    lib.concatStringsSep ""
      (lib.splitString "."
        (lib.head
          (lib.splitString "/" cidr)));
  /*
  Given a CIDR and two offsets, generates a KEA DHCP pool

  Type: cidrToPool

  Examples:
    cidrToPool "10.2.2.0/24" 100 50
    => "10.2.2.101 - 10.2.2.200"
  */
  cidrToPool = cidr: firstOffset: lastOffset: let
    firstIp = nix-ip.prettyIp (nix-ip.cidrToFirstUsableIp cidr);
    firstDhcpIp = nix-ip.ipIncrement firstIp firstOffset;
    lastIp = nix-ip.prettyIp (nix-ip.cidrToLastUsableIp cidr);
    lastDhcpIp = nix-ip.ipIncrement lastIp (- lastOffset);
  in
    lib.concatStringsSep " - " [firstDhcpIp lastDhcpIp];
in {
  inherit
    cidrStrToId
    cidrToPool
    ;
}
