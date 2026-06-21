# Dotfiles

Personal dotfiles for macOS/Linux development environments, managed from a
single repository and deployed with `install.sh`.

## Repository Layout

```text
dotfiles/
├── README.md
├── install.sh
├── kitty/
│   └── kitty.conf
├── zsh/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
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

The installer creates symlinks from this repository into your home directory.
If a target file already exists and is not the expected symlink, it is moved to
a timestamped backup before the new symlink is created.

Linked files:

| Source | Target |
| --- | --- |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `zsh/.zshrc` | `~/.zshrc` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `p10k/.p10k.zsh` | `~/.p10k.zsh` |
| `git/.gitconfig` | `~/.gitconfig` |
| `misc/.gitignore_global` | `~/.gitignore_global` |

## Requirements

The configuration assumes these tools when available:

- `zsh`
- Oh My Zsh
- Powerlevel10k
- `tmux` and TPM (`~/.tmux/plugins/tpm`)
- Kitty
- `git`
- Optional CLI tools used by aliases and shell integrations: `fzf`, `fd`, `bat`,
  `tree`, `zoxide`, `atuin`, `nvim`, `lazygit`, `docker`, `kubectl`, `kubectx`,
  `kubens`, `direnv`, `bpytop`, and `cmatrix`

Optional integrations are guarded where practical, so a missing optional tool
should not prevent the shell from starting.

## Validation

Useful checks after editing:

```bash
bash -n install.sh
zsh -n zsh/.zshrc
git config --file git/.gitconfig --list
HOME=/tmp/dotfiles-test-home ./install.sh
tmux -f tmux/.tmux.conf start-server
```

The temporary `HOME` command verifies the installer without touching your real
home directory.

## What Belongs Here

- `kitty/kitty.conf`: Kitty terminal configuration.
- `zsh/.zshrc`: interactive shell configuration.
- `tmux/.tmux.conf`: Tmux configuration and plugin list.
- `p10k/.p10k.zsh`: Powerlevel10k prompt configuration.
- `git/.gitconfig`: portable Git configuration.
- `misc/.gitignore_global`: optional global Git ignore rules.

## What Does Not Belong Here

- Old shell backups.
- `~/.oh-my-zsh/`
- `~/.tmux/plugins/`
- Toolchains such as `~/.nvm/`, `~/.sdkman/`, or `~/.bun/`
