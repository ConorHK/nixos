{
  config,
  lib,
  ...
}:
with lib;
with lib.ndots; let
  cfg = config.hardware.networking;
in {
  options.hardware.networking = with types; {
    enable = mkBoolOpt false "Enable networkmanager";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
    };
    networking.networkmanager.enable = true;
  };
}

