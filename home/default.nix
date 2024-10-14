{
  # secrets,
  pkgs,
  inputs,
  username,
  nix-index-database,
  home,
  lib,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    bat
    coreutils
    curl
    du-dust
    fd
    findutils
    git
    htop
    jq
    mosh
    oscclip
    procs
    ripgrep
    statix
    unzip
    wget
    zip
  ];

  stable-packages = with pkgs; [
    inputs.nixcats.packages.${system}.nvim
    inputs.script-directory.packages.${system}.default
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

  home = {
    username = "${username}";
    stateVersion = "22.11";
    homeDirectory = "/home/${username}";

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
      SD_ROOT = "$HOME/.scripts";
      SD_CAT = "bat";
      SD_EDITOR = "nvim";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
    packages = 
      stable-packages
      ++ unstable-packages;
    
    activation.cloneScriptsRepo = lib.hm.dag.entryAfter ["installPackages"] ''
      run ${pkgs.git}/bin/git clone https://github.com/conorhk/scripts $HOME/.scripts || true
  '';

    sessionPath = [
      "$SD_ROOT/.scripts"
    ];
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
