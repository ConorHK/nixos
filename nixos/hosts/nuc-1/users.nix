{pkgs, ...}: {
  users.users.nuc = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    password = "nuc";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCdVfRbKfpAwzTwuYCiL/3vkkTcODasfxLrXEEpqhak github@conorknowles.com"
    ];
  };
}
