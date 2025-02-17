{
  config,
  lib,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.programs.terminals.ghostty;
in {
  options.programs.terminals.ghostty = {
    enable = mkEnableOption "enable ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        theme = "catppuccin-mocha";
        font-family = "${config.stylix.fonts.monospace.name}";
        command = "zsh";
        gtk-titlebar = false;
        font-size = 14;
        window-padding-x = 6;
        window-padding-y = 6;
        copy-on-select = "clipboard";
        cursor-style = "block";
        confirm-close-surface = false;
      };
    };
  };
}
