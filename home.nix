{ lib, ... }:

let
  zimModules = [
    "environment"
    "git"
    "input"
    "termtitle"
    "utility"
    "duration-info"
    "git-info"
    "asciiship"
    "zsh-users/zsh-completions --fpath src"
    "completion"
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-history-substring-search"
    "zsh-users/zsh-autosuggestions"
    "Aloxaf/fzf-tab"
  ];

  zimrcContent = lib.concatMapStringsSep "\n" (m: "zmodule ${m}") zimModules;
in
{
  imports = [
    ./dev.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/home/purofle";
  home.stateVersion = "25.11";

  home.file.".zimrc".text = zimrcContent + "\n";

  programs.zsh = {
    enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "brackets"
      ];
    };
    defaultKeymap = "emacs";
    completionInit = "";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "CORRECT"
    ];
    initContent = lib.mkOrder 500 '
      ZIM_HOME=''${ZDOTDIR:-''${HOME}}/.zim
      # Download zimfw plugin manager if missing.
      if [[ ! -e ''${ZIM_HOME}/zimfw.zsh ]]; then
        if (( ''${+commands[curl]} )); then
          curl -fsSL --create-dirs -o ''${ZIM_HOME}/zimfw.zsh \
              https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
        else
          mkdir -p ''${ZIM_HOME} && wget -nv -O ''${ZIM_HOME}/zimfw.zsh \
              https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
        fi
      fi
      # Install missing modules, and update ''${ZIM_HOME}/init.zsh if missing or outdated.
      if [[ ! ''${ZIM_HOME}/init.zsh -nt ''${ZIM_CONFIG_FILE:-''${ZDOTDIR:-''${HOME}}/.zimrc} ]]; then    
        source ''${ZIM_HOME}/zimfw.zsh init
      fi
      # Initialize modules.
      source ''${ZIM_HOME}/init.zsh
      zmodload -F zsh/terminfo +p:terminfo
      bindkey "^[[1;3C" forward-word
      bindkey "^[[1;3D" backward-word
      unset key
      setopt HIST_IGNORE_ALL_DUPS
      setopt CORRECT 
      zstyle ':completion:*' list-colors "''${(@s.:.)LS_COLORS}"
      zstyle ':completion:*:matches' group 'yes'
      zstyle ':completion:*:options' description 'yes'
      zstyle ':completion:*:options' auto-description '%d'
      zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
      zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
      zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
      zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
      zstyle ':completion:*:default' list-prompt '%S%M matches%s'
      zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
      zstyle ':completion:*' group-name '''
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
      zstyle ':completion:*' use-cache true
      zstyle ':completion:*' rehash true
      zstyle ":history-search-multi-word" page-size "11"
      zstyle ':completion:*' menu select
    '';
    sessionVariables = {
      EDITOR = "helix";
      WORDCHARS = ''''${WORDCHARS//[\/]}'';
    };
    shellAliases = {
      cat = "bat -p";
      ls = "eza --icons=auto";
      tree = "eza -T";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}
