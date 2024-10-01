{
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    inherit (pkgs) mkShell;
  in {
    devShells.default = pkgs.mkShell {
      inputsFrom = [
        config.mission-control.devShell
      ];
    };
  };
}
