# Dotfiles

Personal dotfiles for macOS/Linux development environments, managed from a
single repository and deployed with `install.sh`.

## Repository Layout

```text
dotfiles/
├── README.md
├── install.sh
├── bootstrap-ubuntu.sh
├── bootstrap-macos.sh
├── opencode/
├── zsh/
│   └── .zshrc
├── kitty/
│   └── kitty.conf
├── p10k/
│   └── .p10k.zsh
├── git/
│   └── .gitconfig
└── misc/
    └── .gitignore_global
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
backups.

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
| `misc/.gitignore_global` | `~/.gitignore_global` |
| `opencode/opencode.jsonc` | `~/.config/opencode/opencode.jsonc` |
| `opencode/AGENTS.md` | `~/.config/opencode/AGENTS.md` |
| `opencode/package.json` | `~/.config/opencode/package.json` |

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
| `Ctrl+Shift+M` | Maximize/restore window |
| `Ctrl+Alt+H/J/K/L` | Resize window |
| `Ctrl+Shift+C/V` | Copy/paste |
| `Ctrl+Shift+P/F/U` | Scrollback pager/search/URL hints |
| `Ctrl+Shift+R/Z` | Reload config/fullscreen |

`Enter` y `Backspace` quedan libres: ya no se usan para crear splits.
Consulta el [cheat sheet de terminal](docs/terminal.md) para el flujo diario y
los comandos opcionales disponibles.

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
- `zsh/.zshrc`: interactive shell configuration.
- `p10k/.p10k.zsh`: Powerlevel10k prompt configuration.
- `git/.gitconfig`: portable Git configuration.
- `misc/.gitignore_global`: optional global Git ignore rules.

## What Does Not Belong Here

- Old shell backups.
- `~/.oh-my-zsh/`
- Toolchains such as `~/.nvm/`, `~/.sdkman/`, or `~/.bun/`
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

`install.sh` links the portable OpenCode config, instructions, and plugin entry
points. OpenCode resolves `engram`, `codegraph`, and `rtk` through `PATH`; install
those tools separately. Set `SLEEVE_GATEWAY_URL` locally if using the optional
Sleeve gateway.

This repository intentionally excludes OpenCode sessions, auth/credentials,
Engram databases, logs, caches, `node_modules`, and machine-specific proxy
details. Kitty remains the current machine configuration, including its Rosé
Pine theme, font, shell integration, behavior, and shortcuts.
# Dependencies

This repository contains configuration only; it includes no OpenCode sessions,
authentication credentials, or Engram memory database. Install these external
dependencies separately and ensure they are on `PATH`:

- `engram` (the `engram mcp --tools=agent` command)
- `codegraph` (the `codegraph serve --mcp` command)
- `rtk` (the RTK command-line tool)
- OpenCode plus npm packages `@opencode-ai/plugin@1.18.5`,
  `@dietrichgebert/ponytail@4.8.4`, `opencode-model-router@1.3.0`, and
  `opencode-subagent-statusline@1.2.1` (installed by `install.sh`)
- `opencode/tui.json` loads `opencode-subagent-statusline`.
- Optional Sleeve gateway: set `SLEEVE_GATEWAY_URL` when available.

Engram, CodeGraph, RTK, the model router, statusline, and Sleeve are not
vendored here. No sessions, auth, or memory DB are included.
