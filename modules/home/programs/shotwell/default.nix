{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.programs.shotwell;
in {
  options.programs.shotwell = {
    enable = mkEnableOption "Enable shotwell program";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      shotwell
    ];
  };
}
