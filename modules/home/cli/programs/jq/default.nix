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
    enable = mkoption {
      default = false;
      type = with types; bool;
      description = "json parser";
    };
  };

  config = mkif cfg.enable {
    programs = {
      jq = {
        enable = true;
      };
    };
  };
}
