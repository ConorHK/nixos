{
  config,
  lib,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.zoxide;
in
{
  options.cli.programs.zoxide = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Directory traversal assistant";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
