{ config, pkgs, lib, ... }:

let name = "Mike Grouchy";
    user = "mgrouchy";
    email = "mgrouchy@gmail.com"; in
{
  # Shared shell configuration
  starship = {
    enable = true;
    enableZshIntegration = true;
    settings = lib.mkMerge [
      (builtins.fromTOML
        (builtins.readFile "${pkgs.starship}/share/starship/presets/catppuccin-powerline.toml"
      ))
      {
        # here goes my custom configurations
        palette = lib.mkForce "catppuccin_frappe";
        command_timeout = 500;
      }
    ];
  };

  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  
  zsh = {
    enable = true;
    enableCompletion = true;
    autocd = false;
    
    history = {
      path = "${config.home.homeDirectory}/.history";
      save = 100000;
      size = 100000;
    };
        # zsh options
    setOptions = [
      "APPEND_HISTORY"
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_ALL_DUPS"
      "HIST_REDUCE_BLANKS"
      "HIST_IGNORE_SPACE"
      "HIST_NO_STORE"
      "HIST_VERIFY"
      "EXTENDED_HISTORY"
      "HIST_SAVE_NO_DUPS"
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_FIND_NO_DUPS"
    ];

    # Completion cache
    completionInit = ''
      autoload -Uz compinit
      compinit -C
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' cache-path ${config.home.homeDirectory}/.zshcache
    '';

    # Aliases (including your 'cursor' launcher)
    shellAliases = {
      ports = ''sudo lsof -i -P | grep -i "listen"'';
      ips = ''ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'';
      code = ''/run/current-system/sw/bin/Cursor $1'';
      ls = "ls --color=auto";
      cat = "bat";
    };

    # Extras: your functions + neofetch on startup
    # Note: autosuggestion/syntax highlighting toggles are enabled here
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      # --- formerly initExtraFirst (runs first) ---
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      # Define variables for directories
      export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
      export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
      export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft

      # Set LS_COLORS for different file types
      # disabled nov 18, 2025
      #export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

      # Auto-attach to zellij in interactive login shells
      # Using exec to replace shell (avoids nesting issues on TUI exit)
      if [[ -z "$ZELLIJ_SESSION_NAME" && -z "$INSIDE_EMACS" && -z "$VSCODE_INJECTION" && $- == *i* && -o login ]]; then
        exec zellij attach -c "''${USER}@$(hostname)"
      fi

      # Source work-specific config if it exists (not tracked in git)
      [[ -f ~/.config/zsh/work.zsh ]] && source ~/.config/zsh/work.zsh

      # Display system info on login shells only
      if [[ -o login ]] && command -v fastfetch >/dev/null; then
        fastfetch
      fi

      export PATH="$PATH:$HOME/go/bin"

      #fzf to command+r
      eval "$(fzf --zsh)"
      
      # accept autosuggest with ctrl-f
      bindkey '^F' autosuggest-accept

      # Reset terminal state before each prompt (fixes hanging after TUI apps)
      _reset_terminal_state() {
        [[ -t 0 ]] && stty sane 2>/dev/null
      }
      autoload -Uz add-zsh-hook
      add-zsh-hook precmd _reset_terminal_state

      # corepack enable (node) - only log actual errors, not "already enabled"
      if command -v corepack >/dev/null; then
        mkdir -p ~/.local/share/corepack
        corepack enable --install-directory ~/.local/share/corepack 2>&1 | grep -v "already enabled" >&2 || true
      fi

    '';
    plugins = [
      #{
      #  name = "powerlevel10k";
      #  src = pkgs.zsh-powerlevel10k;
      #  file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      #}
      #{
      #  name = "powerlevel10k-config";
      #  src = lib.cleanSource ./config;
      #  file = "p10k.zsh";
      #}
      {
        name = "autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
    ];


    # initExtraFirst removed (deprecated); its contents were merged above.
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    lfs = {
      enable = true;
    };
    settings = {
      user = {
        name = name;
        email = email;
      };

      alias = {
        lo = "log --oneline";
        lwg = "log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%an%d%Creset %s %Cgreen(%cr)%Creset' --date=relative";
        st = "status";
        s = "status";
        p = "push";
        ra = "remote add";
        rrm = "remote rm";
        smupdate = "submodule foreach git pull origin master --recurse-submodules";
        d = "diff";
        ds = "diff --staged";
        ci = "commit";
        co = "checkout";
        cl = "clone";
        br = "branch";
        last = "log -1"; # show the commit message of HEAD
        patch = "add --patch"; # add hunks of code interactively
        rom = "rebase origin/master"; # rebase against origin/master
        fresh = "!git fetch --all && git reset --hard origin/master"; # fetch from all remotes and reset to origin/master
        ismerged = "branch -r --merged master";
      };

      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
        excludesfile = "~/.gitignore_global";
      };
      pull.rebase = true;
      rebase.autoStash = true;
      
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      
      "color \"branch\"" = {
        current = "yellow reverse";
        remote = "green bold";
        local = "blue bold";
      };
      
      "color \"diff\"" = {
        meta = "blue bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };
      
      push.default = "current";
      web.browser = "open";
      pull.ff = "only";
      status.submoduleSummary = true;
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light = false;
        syntax-theme = "Monokai Extended";
        side-by-side = true;
      };
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
    settings = { ignorecase = true; };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/Projects',
        \ '~/Documents',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
      '';
     };

  direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # enable corepack at shell start if available
  # (no HM module available)

  nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  # nix-index DB refresh weekly (user service on Linux only)
  # systemd user services not available on darwin
  # leaving note only; no HM option on macOS

  # ssh = {
  #   enable = true;
  #   includes = [
  #     (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
  #       "/home/${user}/.ssh/config_external"
  #     )
  #     (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
  #       "/Users/${user}/.ssh/config_external"
  #     )
  #   ];
  #   matchBlocks = {
  #     # Example SSH configuration for GitHub
  #     # "github.com" = {
  #     #   identitiesOnly = true;
  #     #   identityFile = [
  #     #     (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
  #     #       "/home/${user}/.ssh/id_github"
  #     #     )
  #     #     (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
  #     #       "/Users/${user}/.ssh/id_github"
  #     #     )
  #     #   ];
  #     # };
  #   };
  # };
}
