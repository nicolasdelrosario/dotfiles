# Dotfiles

Estructura base para centralizar configuraciones personales y desplegarlas con `install.sh`.

## Estructura

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

## Instalacion

1. Clonar este repo en una ruta fija o en cualquier ruta local.
2. Editar los archivos dentro de `dotfiles/`.
3. Ejecutar:

```bash
./install.sh
```

El script crea symlinks en el home del usuario y hace backup de archivos existentes antes de reemplazarlos.

## Que va en cada archivo

- `kitty/kitty.conf`: configuracion de Kitty.
- `zsh/.zshrc`: configuracion de shell.
- `tmux/.tmux.conf`: configuracion de Tmux.
- `p10k/.p10k.zsh`: configuracion de Powerlevel10k.
- `git/.gitconfig`: configuracion de Git portable.
- `misc/.gitignore_global`: ignore global opcional.

## Que no va en el repo

- Backups viejos de shell.
- `~/.oh-my-zsh/`
- `~/.tmux/plugins/`
- Toolchains como `~/.nvm/`, `~/.sdkman/` o `~/.bun/`

