{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.gpg;
in
{
  options.cli.programs.gpg = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Gnu Privacy Guard";
    };
  };

  config = mkIf cfg.enable {
    # services.gnome-keyring.enable = true;
    programs = {
      gpg.enable = true;
    };
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
}

