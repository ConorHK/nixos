{
  config,
  lib,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.nix-your-shell;
in
{
  options.cli.programs.nix-your-shell = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Wrapper for nix-develop";
    };
  };

  config = mkIf cfg.enable {
    programs.nix-your-shell.enable = true;
  };
}
