{
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    inherit (config.mission-control) installToDevShell;
    inherit (pkgs) mkShellNoCC;
  in {
    devShells.default = installToDevShell (mkShellNoCC {
      name = "devShell";
      packages = with pkgs; [];
    });
  };
}
