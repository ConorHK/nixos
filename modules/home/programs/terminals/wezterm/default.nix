{
  config,
  lib,
  ...
}:
with lib;
with lib.ndots;
let
  cfg = config.programs.terminals.wezterm;
in {
  options.programs.terminals.wezterm = {
    enable = mkEnableOption "enable wezterm terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./config.lua;
    };
  };
}
