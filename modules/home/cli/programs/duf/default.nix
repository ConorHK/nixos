{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.duf;
in
{
  options.cli.programs.duf = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "'df' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ duf ];
    programs.zsh.shellAliases = {
      df = "duf";
    };
  };
}
