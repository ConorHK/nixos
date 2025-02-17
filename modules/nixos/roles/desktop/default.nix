
899 B

{
  lib,
  config,
  ...
}:
with lib;
with lib.ndots; let
  cfg = config.roles.desktop;
in {
  options.roles.desktop = {
    enable = mkEnableOption "Enable desktop configuration";
  };
  config = mkIf cfg.enable {
    # transparent emulation for binaries compiled with different CPU architectures
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    roles = {
      common.enable = true;
      desktop.addons = {
        nautilus.enable = true;
      };
    };
    hardware = {
      audio.enable = true;
      bluetooth.enable = true;
      logitechMouse.enable = true;
    };
    services = {
      ndots.avahi.enable = true;
      backup.enable = true;
      vpn.enable = true;
      virtualisation.podman.enable = true;
    };
    system = {
      boot.plymouth = true;
    };
    cli.programs = {
      nh.enable = true;
      nix-ld.enable = true;
    };
    user = {
      name = "conor";
      initialPassword = "1";
    };
  };
}
