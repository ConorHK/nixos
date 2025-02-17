{
  config,
  lib,
  ...
}:
with lib;
with lib.ndots; let
  cfg = config.programs.terminals.foot;
in {
  options.programs.terminals.foot = with types; {
    enable = mkBoolOpt false "enable foot terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          shell = "zsh";
          pad = "15x15";
          selection-target = "clipboard";
        };

        scrollback = {
          lines = 10000;
        };
      };
    };
  };
}
