#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DO_STOW=1
DO_UPDATE=0

usage() {
  cat <<'EOF'
Usage: ./bootstrap.sh [options]

Clone missing external plugin repos used by this dotfiles setup.

Options:
  --no-stow   Skip stow -R step
  --update    Update already-cloned repos with git pull --ff-only
  -h, --help  Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-stow)
      DO_STOW=0
      shift
      ;;
    --update)
      DO_UPDATE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

clone_or_update_repo() {
  local target="$1"
  local url="$2"
  local branch="$3"

  if [[ -d "$target/.git" ]]; then
    echo "[ok] $target already exists"
    if [[ "$DO_UPDATE" -eq 1 ]]; then
      echo "[up] updating $target"
      git -C "$target" pull --ff-only
    fi
    return
  fi

  if [[ -e "$target" ]]; then
    echo "[skip] $target exists but is not a git repo"
    return
  fi

  mkdir -p "$(dirname "$target")"
  echo "[cloning] $url -> $target"
  git clone --depth=1 --branch "$branch" "$url" "$target"
}

clone_or_update_repo "$HOME/.zsh/zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git" "master"
clone_or_update_repo "$HOME/.zsh/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git" "master"
clone_or_update_repo "$HOME/.zsh/spaceship" "https://github.com/spaceship-prompt/spaceship-prompt.git" "master"
clone_or_update_repo "$HOME/.tmux/plugins/tpm" "https://github.com/tmux-plugins/tpm.git" "master"

if [[ "$DO_STOW" -eq 1 ]]; then
  if command -v stow >/dev/null 2>&1; then
    echo "[stow] restowing zsh and tmux packages"
    stow -R --dir "$DOTFILES_DIR" --target "$HOME" zsh tmux
  else
    echo "[warn] stow not found; skipping stow step"
  fi
fi

echo "Done. Restart your shell or run: source ~/.zshrc"
