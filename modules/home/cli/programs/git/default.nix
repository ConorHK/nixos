{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.ndots;

let
  cfg = config.cli.programs.git;
  rewriteURL =
    lib.mapAttrs' (key: value: {
      name = "url.${key}";
      value = {insteadOf = value;};
    })
    cfg.urlRewrites;
in
{
  options.cli.programs.git = with types; {
    enable = mkBoolOpt false "Whether or not to enable git";
    email = mkOpt (nullOr str) "dev@conorknowles.com" "The email to use with git";
    urlRewrites = mkOpt (attrsOf str) {} "url we need to rewrite i.e. ssh to http";
    allowedSigners = mkOpt str "" "The public key used for signing commits";
    defaultBranch = mkOpt (nullOr str) "main" "The default branch name to use";
  };

  config = mkIf cfg.enable {
    home.file.".ssh/allowed_signers".text = "* ${cfg.allowedSigners}";
    home.packages = with pkgs; [
      mergiraf
    ];

    programs = {
      git = {
        enable = true;
        userName = "Conor Knowles";
        userEmail = cfg.email;

        extraConfig = {
          init = {
            defaultBranch = cfg.defaultBranch;
          };
          pull = {
            rebase = true;
          };
          merge.mergiraf = {
            name = "mergiraf";
            driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P";
          };
          gpg = {
            format = "ssh";
            ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          };
          core = {
            editor = "nvim";
            pager = "delta";
          };
          color.ui = true;
          push = {
            default = "current";
            autoSetupRemote = true;
          };
        } // rewriteURL;

        attributes = [
          "*.java merge=mergiraf"
          "*.rs merge=mergiraf"
          "*.go merge=mergiraf"
          "*.js merge=mergiraf"
          "*.jsx merge=mergiraf"
          "*.json merge=mergiraf"
          "*.yml merge=mergiraf"
          "*.yaml merge=mergiraf"
          "*.toml merge=mergiraf"
          "*.html merge=mergiraf"
          "*.htm merge=mergiraf"
          "*.xhtml merge=mergiraf"
          "*.xml merge=mergiraf"
          "*.c merge=mergiraf"
          "*.cc merge=mergiraf"
          "*.h merge=mergiraf"
          "*.cpp merge=mergiraf"
          "*.hpp merge=mergiraf"
          "*.cs merge=mergiraf"
          "*.dart merge=mergiraf"
          "*.scala merge=mergiraf"
          "*.sbt merge=mergiraf"
          "*.ts merge=mergiraf"
          "*.py merge=mergiraf"
        ];
        lfs.enable = true;
        difftastic = {
          enable = true;
          background = "dark";
        };
      };

      zsh.shellAliases = {
        gs = "git status";
        gc = "git commit";
        ga = "git add";
        gaa = "git add --all";
        gp = "git push";
        gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        gd = "git diff";
      };
    };
  };
}
