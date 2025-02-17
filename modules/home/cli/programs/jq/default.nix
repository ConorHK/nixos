{
  config,
  lib,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.jq;
in
{
  options.cli.programs.jq = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "json parser";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      jq = {
        enable = true;
      };
    };
  };
}
