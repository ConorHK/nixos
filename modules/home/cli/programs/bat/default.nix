{
  config,
  lib,
  ...
}:

with lib;
with lib.ndots;
let
  cfg = config.cli.programs.bat;
in
{
  options.cli.programs.bat = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "Text file viewer";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;
        config = {
          pager = "less -FR";
          theme = "TwoDark";
        };
      };
      zsh.shellAliases = {
        bat = "bat --style='plain,rule,header' --paging=never";
        cat = "bat";
      };
    };
  };
}
