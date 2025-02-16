{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.roles.common;
in {
  options.roles.common = {
    enable = lib.mkEnableOption "Enable common configuration";
  };

  config = lib.mkIf cfg.enable {

    system = {
      nix.enable = true;
    };

    cli = {
      shells.zsh.enable = true;
    };

    security = {
      sops.enable = true;
    };

    programs = {
      bat.enable = true;
      comma.enable = true;
      duf.enable = true;
      dust.enable = true;
      eza.enable = true;
      fzf.enable = true;
      htop.enable = true;
      less.enable = true;
      ssh.enable = true;
      zoxide.enable = true;
    };

    styles.stylix.enable = true;

    # TODO: move this to a separate module
    home.packages = with pkgs; [
      optinix
      (hiPrio parallel)
      moreutils
      nvtopPackages.amd
      unzip
      gnupg
      showmethekey
    ];
  };
}
