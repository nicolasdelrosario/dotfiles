#!/usr/bin/env bash
set -euo pipefail
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DRY_RUN=false
FULL=false
usage() { printf 'Usage: %s [--dry-run] [--full]\n' "$(basename "$0")"; }
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;; --full) FULL=true ;; -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done
run() { if "$DRY_RUN"; then printf '+ %q' "$1"; shift; printf ' %q' "$@"; printf '\n'; else "$@"; fi; }
if ! command -v brew >/dev/null 2>&1; then printf 'Homebrew is required: https://brew.sh\n' >&2; exit 1; fi
packages=(zsh kitty git curl wget fzf fd bat tree zoxide neovim)
if "$FULL"; then packages+=(direnv atuin lazygit); fi
run brew update
run brew install "${packages[@]}"
clone_if_missing() {
  local destination=$1 url=$2
  if [[ -e "$destination" ]]; then printf 'Keeping existing %s\n' "$destination"; else run git clone --depth=1 "$url" "$destination"; fi
}
clone_if_missing "$HOME/.oh-my-zsh" https://github.com/ohmyzsh/ohmyzsh.git
clone_if_missing "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" https://github.com/romkatv/powerlevel10k.git
clone_if_missing "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" https://github.com/zsh-users/zsh-autosuggestions.git
clone_if_missing "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" https://github.com/zsh-users/zsh-syntax-highlighting.git
if [[ ! -d "$HOME/Library/Fonts" ]] || ! compgen -G "$HOME/Library/Fonts/Hack*.ttf" >/dev/null 2>&1; then run brew install --cask font-hack-nerd-font; fi
run bash "$ROOT/install.sh"
printf '\nThe default shell was not changed. If desired, run: chsh -s %s\n' "$(command -v zsh)"
