{ pkgs, inputs, ... }:

{ 
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.persistence."/persistent/home" = {
    directories = [
      "downloads"
      "media"
      "docs"
      ".ssh"
      ".nixops"
      ".scripts"
      ".dotfiles"
    ];
    allowOther = true;
  };
}
