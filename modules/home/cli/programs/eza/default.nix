{
  config,
  lib,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.eza;
in
{
  options.cli.programs.eza = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "'ls' command line replacement";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      eza.enable = true;
      zsh.shellAliases = {
        l = "eza -la";
        ls = "eza";
      };
    };
  };
}
