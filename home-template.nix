{ config, pkgs, pkgs-2411, atomi, profile, ... }:

#####################
# Custom ZSH folder #
#####################
let
  customDir = pkgs.stdenv.mkDerivation {
    name = "oh-my-zsh-custom-dir";
    src = ./zsh_custom;
    installPhase = ''
      mkdir -p $out/
      cp -rv $src/* $out/
    '';
  };
in
with pkgs;
{

  # Let Home Manager install and manage itself.
  home.stateVersion = "24.11";
  home.username = "${profile.user}";
  home.homeDirectory = if profile.kernel == "linux" then "/home/${profile.user}" else "/Users/${profile.user}";

  programs.home-manager.enable = true;

  #########################
  # Install packages here #
  #########################

  home.packages = (
    [
      # system
      coreutils
      uutils-coreutils
      kubernetes-helm
      kubectl
      docker
    ]
    ++
    (if profile.kernel == "linux" then
      [ ]
    else
      ([
        pinentry-curses
        pinentry_mac
        nerdfonts
      ]))
  );


  ###################################
  # Addtional environment variables #
  ###################################
  home.sessionVariables = { };

  ##################
  # Addtional PATH #
  ##################
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
  ];
  #######################
  # Background services #
  #######################
  services = (
    if profile.kernel == "linux" then
      {
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
          enableExtraSocket = true;
        };
      } else ({ })
  );

  ##########################
  # Program Configurations #
  ##########################
  programs = {
    gpg = {
      enable = true;
    };

    ssh = {
      enable = true;
    };

    git = {
      enable = true;
      userEmail = "${profile.email}";
      userName = "${profile.gituser}";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = "true";
      };
      lfs = {
        enable = true;
      };
    };

    alacritty = {
      enable = true;
      settings = {
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
        };
      };
    };

    bat = {
      enable = true;
    };


    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    zsh = {
      enable = true;
      enableCompletion = false;
      initExtra = ''
      '';

      oh-my-zsh = {
        enable = true;
        extraConfig = ''
          ZSH_CUSTOM="${customDir}"
          zstyle ':completion:*:*:man:*:*' menu select=long search
          zstyle ':autocomplete:*' recent-dirs zoxide
        '';
        plugins = [
          "git"
          "docker"
          "kubectl"
          "pls"
          "aws"
        ];
      };

      shellAliases = {
        hms = "nix run home-manager/release-24.11 -- switch";
        hmsz = "nix run home-manager/release-24.11 -- switch && source ~/.zshrc";
        configterm = "POWERLEVEL9K_CONFIG_FILE=\"$HOME/home-manager-config/p10k-config/.p10k.zsh\" p10k configure";
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        # p10k config
        {
          name = "powerlevel10k-config";
          src = ./p10k-config;
          file = ".p10k.zsh";
        }
        # live autocomplete
        {
          name = "zsh-autocomplete";
          file = "zsh-autocomplete.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "marlonrichert";
            repo = "zsh-autocomplete";
            rev = "6d059a3634c4880e8c9bb30ae565465601fb5bd2";
            sha256 = "sha256-0NW0TI//qFpUA2Hdx6NaYdQIIUpRSd0Y4NhwBbdssCs=";
          };
        }
        {
          name = "you-should-use";
          src = pkgs.zsh-you-should-use;
          file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
        }
      ];
    };
  };
}
