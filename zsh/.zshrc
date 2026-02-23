# ----- Completion System -----
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true
zstyle ':completion::complete:*' gain-privileges 1   # sudo completion

# ----- History -----
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS       # trim unnecessary whitespace
setopt HIST_VERIFY              # show expanded history command before running

# ----- Navigation & QoL -----
setopt AUTO_CD                  # type a dir name to cd into it
setopt AUTO_PUSHD               # cd pushes to dir stack
setopt PUSHD_IGNORE_DUPS        # no dupes in dir stack
setopt PUSHD_SILENT             # don't print dir stack on pushd
setopt CORRECT                  # suggest correction for typos
setopt INTERACTIVE_COMMENTS     # allow # comments in shell
setopt GLOB_DOTS                # include dotfiles in glob

# ----- Directory Shortcuts -----
hash -d proj=~/projects         # use ~proj instead of ~/projects
hash -d dl=~/Downloads          # use ~dl instead of ~/Downloads
hash -d cfg=~/.config           # use ~cfg instead of ~/.config

# ----- Smart Extract -----
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1"   ;;
      *.tar.gz)  tar xzf "$1"   ;;
      *.tar.xz)  tar xJf "$1"   ;;
      *.bz2)     bunzip2 "$1"   ;;
      *.rar)     unrar x "$1"   ;;
      *.gz)      gunzip "$1"    ;;
      *.tar)     tar xf "$1"    ;;
      *.tbz2)    tar xjf "$1"   ;;
      *.tgz)     tar xzf "$1"   ;;
      *.zip)     unzip "$1"     ;;
      *.Z)       uncompress "$1";;
      *.7z)      7z x "$1"      ;;
      *.zst)     unzstd "$1"    ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ----- Useful Aliases -----
alias ls='ls --color=auto'
alias ll='ls -lAhF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -pv'         # create parents + verbose
alias cp='cp -iv'              # confirm before overwrite
alias mv='mv -iv'
alias rm='rm -iv'
alias df='df -h'
alias du='du -sh'
alias grep='grep --color=auto'
alias path='echo $PATH | tr ":" "\n"'   # pretty print $PATH
alias ports='lsof -i -P -n | grep LISTEN'
alias myip='curl -s ifconfig.me'
alias weather='curl wttr.in/?0'
alias reload='source ~/.zshrc && echo "✔ reloaded"'
# ----- Arch / Pacman Aliases -----
alias p='sudo pacman'
alias pin='sudo pacman -Sy'            # install
alias pup='sudo pacman -Syu'           # full system upgrade
alias prm='sudo pacman -Rns'           # remove pkg + deps + config
alias pss='pacman -Ss'                 # search remote repos
alias pqs='pacman -Qs'                 # search installed packages
alias pinf='pacman -Qi'               # info about installed package
alias pls='pacman -Ql'                # list files owned by package
alias pown='pacman -Qo'               # which package owns a file
alias porph='pacman -Qdtq'            # list orphaned packages
alias pclean='sudo pacman -Rns $(pacman -Qdtq)'  # remove all orphans
alias pcache='sudo pacman -Sc'        # clear old package cache
alias pmirror='sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# ----- AUR Helper (yay/paru) -----
if command -v paru &>/dev/null; then
  alias y='paru'
  alias yin='paru -S'
  alias yup='paru -Syu'
  alias yss='paru -Ss'
  alias yrm='paru -Rns'
elif command -v yay &>/dev/null; then
  alias y='yay'
  alias yin='yay -S'
  alias yup='yay -Syu'
  alias yss='yay -Ss'
  alias yrm='yay -Rns'
fi

# ----- Systemd Shortcuts -----
alias sc='sudo systemctl'
alias sce='sudo systemctl enable --now'
alias scd='sudo systemctl disable --now'
alias scr='sudo systemctl restart'
alias scs='systemctl status'
alias scl='journalctl -xe'            # view recent logs
alias scf='systemctl --failed'        # list failed units

# ----- Quick System Info -----
alias pkgcount='pacman -Q | wc -l'    # total installed packages
alias bigpkg='expac -H M "%m\t%n" | sort -h | tail -20'  # 20 largest packages
alias lastinstalled='expac --timefmt="%Y-%m-%d %T" "%l\t%n" | sort | tail -20'
alias hw='fastfetch'                   # or neofetch

# ----- FZF Integration (if installed) -----
if command -v fzf &>/dev/null; then
  # Ctrl+R: fuzzy history search
  source <(fzf --zsh 2>/dev/null) || true

  export FZF_DEFAULT_OPTS="
    --height=40%
    --layout=reverse
    --border=rounded
    --prompt='❯ '
    --pointer='▶'
    --marker='✓'
    --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8
    --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8
    --color=info:#cba6f7,prompt:#94e2d5,pointer:#f5e0dc
    --color=marker:#a6e3a1,spinner:#f5e0dc,header:#94e2d5
  "
fi

# ----- Zoxide (smarter cd, if installed) -----
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  # now use `z myproject` to jump to ~/projects/myproject from anywhere
fi

# ----- Plugins -----
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/spaceship/spaceship.zsh

# ----- Keybindings -----
bindkey '^[[Z' reverse-menu-complete    # Shift+Tab reverse menu
bindkey '^[[A' history-search-backward  # Up arrow: search history back
bindkey '^[[B' history-search-forward   # Down arrow: search history forward
bindkey '^[[1;5C' forward-word          # Ctrl+Right: jump word forward
bindkey '^[[1;5D' backward-word         # Ctrl+Left: jump word backward
bindkey '^[[3~' delete-char             # Delete key works properly
bindkey '^U' backward-kill-line         # Ctrl+U: delete to start of line

# ----- Welcome Message -----
echo ""
figlet -f slant "$(whoami)" | lolcat 2>/dev/null || figlet -f slant "$(whoami)"
echo "  $(date '+%A, %B %d %Y • %H:%M')"
echo ""

# opencode
export PATH=/home/pho/.opencode/bin:$PATH
