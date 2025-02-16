{
  ...
}:
{
  # cli.programs.git.allowedSigners = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINP5gqbEEj+pykK58djSI1vtMtFiaYcygqhHd3mzPbSt dev@conorknowles.com";

  desktops.gnome.enable = true;

  services.ndots = {
    syncthing.enable = true;
  };

  roles = {
    desktop.enable = true;
    social.enable = true;
    gaming.enable = true;
    development.enable = true;
  };

  nixicle.user = {
    enable = true;
    name = "conor";
  };

  home.stateVersion = "24.11";
}
