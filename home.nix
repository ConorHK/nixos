{
  # secrets,
  pkgs,
  inputs,
  username,
  nix-index-database,
  config,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    jq
    killall
    mosh
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    wget
    zip
  ];

  stable-packages = with pkgs; [
    inputs.nixcats.packages.${system}.nvim
    eza
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++ [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    fzf.enable = true;
    fzf.enableZshIntegration = true;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
    zoxide.options = ["--cmd cd"];

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "dev@conorknowles.com";
      userName = "conorhk";
      extraConfig = {
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };
    zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = false;
      syntaxHighlighting.enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      initExtra = ''
        fpath+="${pkgs.script-directory}/share/zsh/site-functions"

        ico_ahead="▲ "
        ico_behind="▼ "
        ico_diverged="↕ "
        color_root="%F{red}"
        color_user="%F{3}"
        color_normal="%F{white}"
        color_git="%F{13}"

        # allow functions in the prompt
        setopt PROMPT_SUBST
        autoload -Uz colors && colors

        # colors for permissions
        if [[ "$EUID" -ne "0" ]]
        then
         color_prompt="''${color_user}"
        else
         color_prompt="''${color_root}"
        fi

        git_prompt() {
          repo=$(git rev-parse --is-inside-work-tree 2> /dev/null)
          if [[ ! "$repo" || "$repo" = false ]]; then
            return
          fi

          bare_repo=$(git rev-parse --is-bare-repository 2> /dev/null)
          if [ "$bare_repo" = true ]; then
            return
          fi

          branch="$(git branch | grep "^*" | tr -d "*" | tr -d " ")"
          if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]; then
            color_git="%F{red}"
          fi

          stat=$(git status | sed -n 2p)
          case "$stat" in
            *ahead*)
              stat="$ico_ahead"
            ;;
            *behind*)
              stat="$ico_behind"
            ;;
            *diverged*)
              stat="$ico_diverged"
            ;;
            *)
              stat=""
            ;;
          esac
          echo "on %B"''${color_git}''${branch} ''${stat} "%b"
        }

        ssh_prompt() {
          [ "$SSH_CLIENT" ] && echo "''${color_prompt}[$HOSTNAME] "
        }

        PROMPT='%B$(ssh_prompt)%F{15}%(5~|%-1|%3~|%4~) %b$(git_prompt) ''${color_prompt}──── ─''${color_normal} '
      '';

      shellAliases = {
        l = "eza -la";
        gs = "git status";
        gc = "git commit";
        ga = "git add";
        gaa = "git add --all";
        gp = "git push";
        gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        nix = "noglob nix";
        source-zsh = "source $ZDOTDIR/.zshrc";
        home-manage = "home-manager switch --flake ~/.dotfiles && source $ZDOTDIR/.zshrc";
        vim = "nvim";
        ls = "eza";
      };

      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        size = 10000;
        share = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      historySubstringSearch = {
        enable = true;
        searchUpKey = [
          "^[[A"
          "^[OA"
          "$terminfo[kcud1]"
        ];
        searchDownKey = [
          "^[[B"
          "^[OB"
        ];
      };
    };
  };
}
