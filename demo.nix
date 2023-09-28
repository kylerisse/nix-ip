{ config, lib, pkgs, ... }:
let
  nix-ip = import ./default.nix { inherit lib; };
  nix-kea = import ./kea.nix { inherit lib; };

  listen-interfaces = [ "eth0" ];
  managed-subnets = [
    "10.10.10.0/22"
    "192.168.73.0/24"
    "172.16.20.0/20"
    "10.10.250.0/22"
  ];
in
{
  system.stateVersion = "22.11";
  services.kead.dhcp4 = {
    enable = true;
    settings = {
      loggers = [{
        name = "*";
        severity = "DEBUG";
      }];
      valid-lifetime = 86400;
      renew-timer = 21600;
      rebind-timer = 43200;
      interfaces-config = {
        interfaces = listen-interface;
      };
      lease-database = {
        type = "memfile";
        persist = true;
        name = "/var/lib/kea/dhcp4.leases";
      };
      option-data = [
        {
          name = "domain-name-servers";
          data = cfg.dns;
        }
        {
          name = "domain-name";
          data = cfg.domain;
        }
      ];
      reservation-mode = "global";
      /*
        [{
          subnet = "192.168.70.0/24";
          id = 19216870;
          user-context.vlan = "kvm-unrouted";
          pools = [
            { pool = "192.168.70.100 - 192.168.70.199"; }
          ];
          option-data = [
            { name = "routers"; data = "192.168.70.1"; }
          ];
        }];
      */
      subnet4 = [
        builtins.map
      ];
    };
  };
}
