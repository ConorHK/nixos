{
  # secrets,
  username,
  hostname,
  pkgs,
  inputs,
  ...
}: {
  time.timeZone = "Europe/Dublin";

  networking.hostName = "${hostname}";

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  environment.enableAllTerminfo = true;

  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];
    hashedPassword = "$y$j9T$P9t0y46MDYAg8CKYhJIrv/$TKd0g8U5ukoc2ul8eeY7SyWRZgdYB4.UFW6u/m8kbt7";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCdVfRbKfpAwzTwuYCiL/3vkkTcODasfxLrXEEpqhak github@conorknowles.com"
    ];
  };

  home-manager.users.${username} = {
    imports = [
      ./home
    ];
  };

  system.stateVersion = "22.05";

  wsl = {
    enable = true;
    wslConf = {
      automount.root = "/mnt";
      interop.appendWindowsPath = false;
      network.generateHosts = false;
    };
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [username];
      # access-tokens = [
      #   "github.com=${secrets.github_token}"
      #   "gitlab.com=OAuth2:${secrets.gitlab_token}"
      # ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixFlakes;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
