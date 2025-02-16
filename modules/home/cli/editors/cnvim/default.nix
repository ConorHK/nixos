{
  config,
  inputs,
  lib,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.cnvim;
in
{
  imports = [ inputs.cnvim.homeModule ];
  options.cli.programs.cnvim = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Custom nvim";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "cnvim";

    cnvim = {
      enable = true;
      packageNames = [ "cnvim" ];
    };

    programs.zsh.shellAliases = {
      vim = "cnvim";
    };
  };
}
