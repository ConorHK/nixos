{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.roles.development;
in {
  options.roles.development = {
    enable = mkEnableOption "Enable development configuration";
  };

  config = mkIf cfg.enable {
    cli = {
      editors.cnvim.enable = true;
      multiplexers.tmux.enable = true;

      programs = {
        atuin.enable = true;
        git.enable = true;
        gpg.enable = true;
        jq.enable = true;
        networking-tools.enable = true;
        nix-your-shell.enable = true;
        ripgrep.enable = true;
        script-directory.enable = true;
        wget.enable = true;
      };
    };
  };
}
