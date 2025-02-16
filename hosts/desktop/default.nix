{
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/global
    ../common/users/gabriel
    ../common/optional/fail2ban.nix
    ../common/optional/tailscale-exit-node.nix
  ];

  networking = {
    hostName = "desktop";
    useDHCP = true;
    dhcpcd.IPv6rs = true;
    interfaces.enp13s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
      ipv4.addresses = [
        {
          address = "192.168.0.07";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "e80::1ead:9efd:142a:580b";
          prefixLength = 64;
        }
      ];
    };
  };
  system.stateVersion = "24.11";
}
