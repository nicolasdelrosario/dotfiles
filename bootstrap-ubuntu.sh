#!/usr/bin/env bash
set -euo pipefail

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DRY_RUN=false
FULL=false

usage() {
  printf 'Usage: %s [--dry-run] [--full]\n' "$(basename "$0")"
}
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --full) FULL=true ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done

if [[ ! -r /etc/os-release ]]; then
  printf 'Cannot detect the operating system (/etc/os-release is missing).\n' >&2
  exit 1
fi
# shellcheck disable=SC1091
. /etc/os-release
case "${ID:-}" in
  ubuntu|debian) ;;
  *)
    case " ${ID_LIKE:-} " in *\ ubuntu\ *|*\ debian\ *) ;; *)
      printf 'This bootstrap supports Ubuntu/Debian only (detected: %s).\n' "${ID:-unknown}" >&2
      exit 1
      ;;
    esac
    ;;
esac

run() {
  if "$DRY_RUN"; then
    printf '+ %q' "$1"; shift
    printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

apt_packages=(zsh zsh-completions kitty git curl wget unzip fzf fd-find bat tree zoxide neovim)
if "$FULL"; then
  for package in direnv atuin lazygit; do
    if apt-cache show "$package" >/dev/null 2>&1; then
      apt_packages+=("$package")
    else
      printf 'Skipping %s: it is not available from the configured APT sources.\n' "$package"
    fi
  done
fi

run sudo apt-get update
run sudo apt-get install -y "${apt_packages[@]}"

# Debian names these binaries fdfind and batcat; the shell config uses the
# portable names used by Homebrew and most other distributions.
if ! "$DRY_RUN"; then
  mkdir -p "$HOME/.local/bin"
  if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
  if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi
fi

clone_if_missing() {
  local destination=$1 url=$2
  if [[ -e "$destination" ]]; then
    printf 'Keeping existing %s\n' "$destination"
  else
    run git clone --depth=1 "$url" "$destination"
  fi
}

clone_if_missing "$HOME/.oh-my-zsh" https://github.com/ohmyzsh/ohmyzsh.git
clone_if_missing "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" https://github.com/romkatv/powerlevel10k.git
clone_if_missing "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" https://github.com/zsh-users/zsh-autosuggestions.git
clone_if_missing "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" https://github.com/zsh-users/zsh-syntax-highlighting.git
install_font() {
  local font_dir="$HOME/.local/share/fonts" tmp zip
  if compgen -G "$font_dir/Hack*.ttf" >/dev/null 2>&1; then
    printf 'Keeping existing Hack Nerd Font in %s\n' "$font_dir"
    return
  fi
  tmp=$(mktemp -d)
  zip="$tmp/Hack.zip"
  if "$DRY_RUN"; then
    printf '+ download Hack Nerd Font to %s and install it in %s\n' "$zip" "$font_dir"
    rm -rf "$tmp"
    return
  fi
  if curl -fL --retry 2 --silent --show-error \
      -o "$zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip \
      && unzip -q -o "$zip" -d "$tmp/fonts" \
      && compgen -G "$tmp/fonts/*.ttf" >/dev/null 2>&1; then
    mkdir -p "$font_dir"
    cp "$tmp/fonts"/*.ttf "$font_dir/"
    command -v fc-cache >/dev/null 2>&1 && fc-cache -f "$font_dir" || true
    printf 'Installed Hack Nerd Font in %s\n' "$font_dir"
  else
    printf 'Hack Nerd Font could not be downloaded; continuing with the base configuration.\n' >&2
  fi
  rm -rf "$tmp"
}
install_font

if [[ -f "$ROOT/install.sh" ]]; then
  run bash "$ROOT/install.sh"
else
  printf 'Missing %s; skipping repository configuration.\n' "$ROOT/install.sh" >&2
fi

printf '\nThe default shell was not changed. If desired, review and run:\n'
printf '  chsh -s %s\n' "$(command -v zsh 2>/dev/null || printf '%s' /usr/bin/zsh)"
