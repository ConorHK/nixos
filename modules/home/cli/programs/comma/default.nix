{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.ndots;
let
  cfg = config.cli.programs.comma;
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.cli.programs.comma = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Run applications not already installed on system";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ comma ];
  };
}
