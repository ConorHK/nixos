{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mapAttrs' nameValuePair mkForce;
in {
  environment.systemPackages = with pkgs; [
    curl
    diskrsync
    httpie
    neovim
    ntfs3g
    ntfsprogs
    partclone
    wget
  ];

  # Use nvim as the default editor
  environment.variables.EDITOR = "nvim";

  networking = {
    firewall.enable = false;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    usePredictableInterfaceNames = false;
  };

  services.resolved.enable = false;

  systemd = {
    network.enable = true;
    network.networks =
      mapAttrs'
      (num: _:
        nameValuePair "eth${num}" {
          extraConfig = ''
            [Match]
            Name = eth${num}
            [Network]
            DHCP = both
            LLMNR = true
            IPv4LL = true
            LLDP = true
            IPv6AcceptRA = true
            IPv6Token = ::521a:c5ff:fefe:65d9
            Address = fd42:4492:6a6d:43:1::${num}/64
            [DHCP]
            UseHostname = false
            RouteMetric = 512
          '';
        })
      {
        "0" = {};
        "1" = {};
        "2" = {};
        "3" = {};
      };
    services.update-prefetch.enable = false;
    services.sshd.wantedBy = mkForce ["multi-user.target"];
  };

  documentation = {
    enable = false;
    nixos.options.warningsAreErrors = false;
    info.enable = false;
  };

  nix = {
    gc.automatic = true;

    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      flake-registry = ${inputs.flake-registry}/flake-registry.json
    '';

    nixPath = [
      "nixpkgs=${pkgs.path}"
    ];
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCdVfRbKfpAwzTwuYCiL/3vkkTcODasfxLrXEEpqhak github@conorknowles.com"
  ];

  system.stateVersion = "24.05";
}
