#!/bin/bash
set -euo pipefail

repo_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
home_dir="${HOME}"

link_file() {
  local source="$1"
  local target="$2"

  if [ ! -e "$source" ]; then
    echo "skip: missing source $source"
    return 0
  fi

  local target_dir
  target_dir="$(dirname -- "$target")"
  mkdir -p "$target_dir"

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -L "$target" ] && [ "$(readlink -- "$target")" = "$source" ]; then
      echo "ok: $target already linked"
      return 0
    fi

    local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    echo "backup: $target -> $backup"
  fi

  ln -s "$source" "$target"
  echo "link: $target -> $source"
}

link_file "$repo_dir/kitty/kitty.conf" "$home_dir/.config/kitty/kitty.conf"
link_file "$repo_dir/zsh/.zshrc" "$home_dir/.zshrc"
link_file "$repo_dir/tmux/.tmux.conf" "$home_dir/.tmux.conf"
link_file "$repo_dir/p10k/.p10k.zsh" "$home_dir/.p10k.zsh"
link_file "$repo_dir/git/.gitconfig" "$home_dir/.gitconfig"
link_file "$repo_dir/misc/.gitignore_global" "$home_dir/.gitignore_global"

