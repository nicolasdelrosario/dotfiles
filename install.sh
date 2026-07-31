#!/bin/bash
set -euo pipefail

repo_dir="$(CDPATH='' cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
home_dir="${HOME}"
config_dir="${XDG_CONFIG_HOME:-$home_dir/.config}"
dry_run=false

case "${1:-}" in
  "") ;;
  -n|--dry-run) dry_run=true ;;
  *) echo "usage: $0 [--dry-run]" >&2; exit 2 ;;
esac

link_file() {
  local source="$1"
  local target="$2"

  if [ ! -e "$source" ]; then
    echo "skip: missing source $source"
    return 0
  fi

  local target_dir
  target_dir="$(dirname "$target")"
  if "$dry_run"; then
    echo "dry-run: link $target -> $source (backup existing target if needed)"
    return 0
  fi
  mkdir -p "$target_dir"

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      echo "ok: $target already linked"
      return 0
    fi

    local backup
    backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      backup="${target}.backup.$(date +%Y%m%d%H%M%S).$RANDOM"
    done
    mv "$target" "$backup"
    echo "backup: $target -> $backup"
  fi

  ln -s "$source" "$target"
  echo "link: $target -> $source"
}

link_file "$repo_dir/kitty/kitty.conf" "$config_dir/kitty/kitty.conf"
link_file "$repo_dir/zsh/.zshrc" "$home_dir/.zshrc"
link_file "$repo_dir/p10k/.p10k.zsh" "$home_dir/.p10k.zsh"
link_file "$repo_dir/git/.gitconfig" "$home_dir/.gitconfig"
link_file "$repo_dir/misc/.gitignore_global" "$home_dir/.gitignore_global"

link_file "$repo_dir/codex/config.toml" "$home_dir/.codex/config.toml"
link_file "$repo_dir/codex/AGENTS.md" "$home_dir/.codex/AGENTS.md"

link_file "$repo_dir/opencode/opencode.jsonc" "$config_dir/opencode/opencode.jsonc"
link_file "$repo_dir/opencode/tui.json" "$config_dir/opencode/tui.json"
link_file "$repo_dir/opencode/AGENTS.md" "$config_dir/opencode/AGENTS.md"
link_file "$repo_dir/opencode/package.json" "$config_dir/opencode/package.json"
for plugin in "$repo_dir"/opencode/plugins/*; do
  [ -f "$plugin" ] || continue
  link_file "$plugin" "$config_dir/opencode/plugins/$(basename "$plugin")"
done
for skill in "$repo_dir"/opencode/skills/*; do
  [ -e "$skill" ] || continue
  link_file "$skill" "$config_dir/opencode/skills/$(basename "$skill")"
done
for directory in command agents; do
  [ -d "$repo_dir/opencode/$directory" ] || continue
  link_file "$repo_dir/opencode/$directory" "$config_dir/opencode/$directory"
done

if command -v npm >/dev/null 2>&1 && [ -f "$repo_dir/opencode/package.json" ] && ! "$dry_run"; then
  # Plugins are symlinked from the repository, so dependencies must resolve
  # from the source tree rather than only from the deployed config directory.
  npm ci --prefix "$repo_dir/opencode" --ignore-scripts --no-audit --no-fund
fi
