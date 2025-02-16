{
  config,
  lib,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.ripgrep;
in
{
  options.cli.programs.ripgrep = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "File searcher";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      ripgrep = {
        enable = true;
      };
    };
  };
}
