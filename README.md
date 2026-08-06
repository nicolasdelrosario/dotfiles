# Dotfiles

Personal dotfiles for macOS/Linux development environments, managed from a
single repository and deployed with `install.sh`.

## Repository Layout

```text
dotfiles/
├── .gitignore
├── README.md
├── install.sh
├── bootstrap-ubuntu.sh
├── bootstrap-macos.sh
├── opencode/
│   ├── agents/
│   │   ├── architect.md
│   │   ├── explorer.md
│   │   ├── implementer.md
│   │   └── reviewer.md
│   ├── command/
│   │   └── ponytail.md
│   ├── plugins/
│   │   ├── engram.ts
│   │   ├── ponytail-fixed.mjs
│   │   └── rtk.ts
│   ├── skills/
│   │   └── find-skills/SKILL.md
│   ├── AGENTS.md
│   ├── opencode.jsonc
│   ├── package.json
│   └── tui.json
├── codex/
├── zsh/
│   └── .zshrc
├── kitty/
│   └── kitty.conf
├── p10k/
│   └── .p10k.zsh
├── git/
│   └── .gitconfig
└── docs/
    └── terminal.md
```

## Installation

Clone this repository, review the files, then run:

```bash
./install.sh
```

Ubuntu/Debian restore:

```bash
./bootstrap-ubuntu.sh --dry-run
./bootstrap-ubuntu.sh
```

macOS restore (Homebrew required):

```bash
./bootstrap-macos.sh --dry-run
./bootstrap-macos.sh
```

Use `./install.sh --dry-run` to preview links and backups without changing
files. `XDG_CONFIG_HOME` controls the Kitty config location (default:
`~/.config`). Existing targets are backed up without overwriting earlier
backups. The same variable controls Kitty and OpenCode config locations.

The installer creates symlinks from this repository into your home directory.
If a target file already exists and is not the expected symlink, it is moved to
a timestamped backup before the new symlink is created.

Linked files:

| Source | Target |
| --- | --- |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `zsh/.zshrc` | `~/.zshrc` |
| `p10k/.p10k.zsh` | `~/.p10k.zsh` |
| `git/.gitconfig` | `~/.gitconfig` |
| `codex/config.toml` | `~/.codex/config.toml` |
| `codex/AGENTS.md` | `~/.codex/AGENTS.md` |
| `opencode/opencode.jsonc` | `~/.config/opencode/opencode.jsonc` |
| `opencode/tui.json` | `~/.config/opencode/tui.json` |
| `opencode/AGENTS.md` | `~/.config/opencode/AGENTS.md` |
| `opencode/package.json` | `~/.config/opencode/package.json` |
| `opencode/plugins/*` | `~/.config/opencode/plugins/` |
| `opencode/skills/*` | `~/.config/opencode/skills/` |
| `opencode/command/` | `~/.config/opencode/command/` |
| `opencode/agents/` | `~/.config/opencode/agents/` |

## Requirements

The configuration assumes these tools when available:

- `zsh`
- Oh My Zsh
- Powerlevel10k
- Kitty
- Kitty provides the terminal and local multiplexing features.
- `git`
- Optional CLI tools used by aliases and shell integrations: `fzf`, `fd`, `bat`,
  `tree`, `zoxide`, `atuin`, `nvim`, `lazygit`, `docker`, `kubectl`, `kubectx`,
  `kubens`, `direnv`, `bpytop`, and `cmatrix`

Optional integrations are guarded where practical, so a missing optional tool
should not prevent the shell from starting.

## Kitty terminal y ventanas locales

Kitty is both the terminal and the local multiplexer: it provides shell
integration, scrollback, tabs, splits, URL hints, search, pager, and clipboard
shortcuts. Remote control is disabled. Kitty windows are not persistent after
the Kitty process exits; use a separate persistent-session tool if that is a
requirement.

Main Kitty shortcuts:

| Shortcut | Action |
| --- | --- |
| `Ctrl+Shift+T/W` | New tab in the current directory / close tab |
| `Ctrl+Shift+[` / `]` | Previous/next tab |
| `Ctrl+Shift+D` | Horizontal split |
| `Ctrl+Shift+S` | Vertical split |
| `Ctrl+Shift+N` | New Kitty OS window in the current directory |
| `Ctrl+Shift+H/J/K/L` | Move between windows |
| `Ctrl+Shift+Q` | Close window |
| `Ctrl+Shift+E` | Equalize windows |
| `Ctrl+Shift+M` | Alternar layout apilado |
| `Ctrl+Alt+H/J/K/L` | Resize window |
| `Ctrl+Shift+C/V` | Copy/paste |
| `Ctrl+Shift+P/F/U` | Scrollback pager/search/URL hints |
| `Ctrl+Shift+R/Z` | Reload config/fullscreen |

`Enter` y `Backspace` quedan libres: ya no se usan para crear splits.
Consulta el [cheat sheet de terminal](docs/terminal.md) para el flujo diario y
los comandos opcionales disponibles.

Kitty remains the current machine configuration, including its Rosé Pine theme,
font, shell integration, behavior, and shortcuts.

## Validation

Useful checks after editing:

```bash
bash -n install.sh
zsh -n zsh/.zshrc
git config --file git/.gitconfig --list
HOME=/tmp/dotfiles-test-home ./install.sh
```

The temporary `HOME` command verifies the installer without touching your real
home directory.

## What Belongs Here

- `kitty/kitty.conf`: Kitty terminal configuration.
- `codex/config.toml` and `codex/AGENTS.md`: portable Codex configuration and instructions.
- `zsh/.zshrc`: interactive shell configuration.
- `p10k/.p10k.zsh`: Powerlevel10k prompt configuration.
- `git/.gitconfig`: portable Git configuration.

## Ubuntu bootstrap

Requirements: Ubuntu or Debian, an interactive `sudo` account, and a network connection. The script does not change the default shell and never stores passwords.

```sh
./bootstrap-ubuntu.sh --dry-run
./bootstrap-ubuntu.sh
./bootstrap-ubuntu.sh --full
```

The base setup installs zsh, kitty, git, curl, wget, unzip, fzf, fd-find, bat, tree, zoxide, and neovim. `--full` additionally installs `direnv`, `atuin`, and `lazygit` when those packages are available from APT. It also installs missing Oh My Zsh, Powerlevel10k, zsh plugins, and Hack Nerd Font, then runs `install.sh` without overwriting existing configuration.

## macOS bootstrap

The macOS bootstrap uses Homebrew equivalents (`fd` and `bat`, rather than
Ubuntu's `fdfind` and `batcat`) and follows the same restore flow:

```bash
./bootstrap-macos.sh --dry-run
./bootstrap-macos.sh
```

## OpenCode restore and exclusions

`install.sh` links the portable OpenCode config, native agents, instructions, and
plugin entry points, then runs `npm ci` in the source `opencode/` directory. The
source install is intentional: plugin symlinks resolve npm dependencies from
their real path in this repository. OpenCode resolves `engram`, `codegraph`,
and `rtk` through `PATH`.

Luna is the primary OpenCode agent. Native subagents use DeepSeek for free
exploration and review, Luna for implementation, and Terra only for difficult
architecture or debugging work.

### OpenCode stack

The configured stack is deliberately small and role-based:

- `explorer`: read-only codebase discovery with `opencode/deepseek-v4-flash-free`.
- `reviewer`: read-only correctness review with `opencode/deepseek-v4-flash-free`.
- `implementer`: focused edits and tests with Luna; cannot delegate.
- `architect`: read-only difficult architecture analysis with Terra; use sparingly.
- Ponytail: prompt rules, `/ponytail`, and related skills.
- Engram: persistent project memory through the local MCP server and plugin.
- CodeGraph: local symbol/call-graph MCP, used only when a repo has `.codegraph/`.
- Context7: remote documentation MCP for current library/API references.
- RTK: external command rewriter that reduces shell output tokens.

### OpenCode dependencies

Install the external tools separately and keep them on `PATH`:

```bash
# RTK: official macOS/Linux installer
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh | sh
rtk init --global --opencode
```

The npm dependencies for Ponytail and the OpenCode plugin API are installed by
`install.sh` from `opencode/package-lock.json`. The repository intentionally
does not commit `node_modules`.

### OpenCode verification

After installation or plugin changes, restart OpenCode and run:

```bash
rtk --version
rtk init --show
opencode agent list
bun -e "import('./opencode/plugins/ponytail-fixed.mjs').then(async m => console.log(Object.keys(await m.default({}))))"
```

The expected RTK output includes `OpenCode: plugin installed`. The Ponytail
check should list `config`, `command.execute.before`, and
`experimental.chat.system.transform`.

This repository intentionally excludes OpenCode sessions, auth/credentials,
Engram databases, logs, caches, `node_modules`, and machine-specific proxy
details.
