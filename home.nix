{ lib, ... }:

{

  imports = [
    ./dev.nix
  ];

  home.username = "purofle";
  home.homeDirectory = "/home/purofle";
  home.stateVersion = "25.11";

  home.file.".zimrc".text = ''
        zmodule environment
    # Provides handy git aliases and functions.
    zmodule git
    # Applies correct bindkeys for input events.
    zmodule input
    # Sets a custom terminal title.
    zmodule termtitle
    # Utility aliases and functions. Adds colour to ls, grep and less.
    zmodule utility

    #
    # Prompt
    #

    # Exposes to prompts how long the last command took to execute, used by asciiship.
    zmodule duration-info
    # Exposes git repository status information to prompts, used by asciiship.
    zmodule git-info
    # A heavily reduced, ASCII-only version of the Spaceship and Starship prompts.
    zmodule asciiship

    #
    # Completion
    #

    # Additional completion definitions for Zsh.
    zmodule zsh-users/zsh-completions --fpath src
    # Enables and configures smart and extensive tab completion.
    # completion must be sourced after all modules that add completion definitions.
    zmodule completion

    #
    # Modules that must be initialized last
    #

    # Fish-like syntax highlighting for Zsh.
    # zsh-users/zsh-syntax-highlighting must be sourced after completion
    zmodule zsh-users/zsh-syntax-highlighting
    # Fish-like history search (up arrow) for Zsh.
    # zsh-users/zsh-history-substring-search must be sourced after zsh-users/zsh-syntax-highlighting
    zmodule zsh-users/zsh-history-substring-search
    # Fish-like autosuggestions for Zsh.
    zmodule zsh-users/zsh-autosuggestions

    #Replace zsh's default completion selection menu with fzf
    zmodule Aloxaf/fzf-tab

  '';

  programs.zsh = {
    enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "brackets"
      ];
    };
    completionInit = "";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "CORRECT"
    ];
    initContent = lib.mkOrder 500 ''

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
          # Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
          for key ('^[[A' '^P' ''${terminfo[kcuu1]}) bindkey ''${key} history-substring-search-up
          for key ('^[[B' '^N' ''${terminfo[kcud1]}) bindkey ''${key} history-substring-search-down
          for key ('k') bindkey -M vicmd ''${key} history-substring-search-up
          for key ('j') bindkey -M vicmd ''${key} history-substring-search-down
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
