{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.dust;
in
{
  options.cli.programs.dust = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "'du' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      du-dust
    ];
    programs = {
      zsh.shellAliases = {
        du = "dust";
      };
    };
  };
}
