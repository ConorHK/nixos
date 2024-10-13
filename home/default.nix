{
  # secrets,
  pkgs,
  inputs,
  username,
  nix-index-database,
  config,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    htop
    jq
    killall
    mosh
    oscclip
    procs
    ripgrep
    unzip
    wget
    zip
  ];

  stable-packages = with pkgs; [
    inputs.nixcats.packages.${system}.nvim
    difftastic
    eza
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
    ./common/git.nix
    ./common/shell.nix
    ./common/tmux.nix
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
    packages = 
      stable-packages
      ++ unstable-packages;
  };


  programs = {
    home-manager.enable = true;
    nix-index = {
      enable = true;
      enableZshIntegration = true;
      
    };
    nix-index-database.comma.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
  };
}
