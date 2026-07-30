# Cheat sheet de terminal

Guía práctica para trabajar con Kitty, Zsh y Git. No pretende enumerar cada
comando: usa `comando --help` o `man comando` cuando necesites más detalle.

## Kitty: ventanas, tabs y splits

Kitty reemplaza la necesidad de un multiplexor local para este flujo:

| Atajo | Acción |
| --- | --- |
| `Ctrl+Shift+T` | Nueva tab conservando el directorio actual |
| `Ctrl+Shift+W` | Cerrar tab |
| `Ctrl+Shift+[` / `]` | Tab anterior / siguiente |
| `Ctrl+Shift+D` | Split horizontal |
| `Ctrl+Shift+S` | Split vertical |
| `Ctrl+Shift+N` | Nueva ventana de escritorio Kitty en el directorio actual |
| `Ctrl+Shift+H/J/K/L` | Moverse entre splits |
| `Ctrl+Shift+Q` | Cerrar el split actual |
| `Ctrl+Shift+E` | Igualar tamaños |
| `Ctrl+Shift+M` | Alternar layout apilado |
| `Ctrl+Alt+H/J/K/L` | Redimensionar |

`Enter` y `Backspace` están libres; ya no son atajos de split. También están
disponibles `Ctrl+Shift+C/V` (copiar/pegar), `P` (scrollback), `F` (buscar),
`U` (pistas de URL), `R` (recargar configuración) y `Z` (pantalla completa).

## Navegación y archivos

```sh
pwd                         # directorio actual
cd proyecto && ls           # entrar y listar
ls -la                      # incluir ocultos
fd nombre                   # buscar archivos (opcional)
fzf                         # selector interactivo (opcional)
z foo                       # saltar a un directorio conocido (zoxide, opcional)
mkdir -p ruta/nueva
cp origen destino
mv viejo nuevo
rm archivo                  # ¡borra sin papelera; confirma antes!
rm -r directorio            # ¡borrado recursivo e irreversible!
```

Aliases útiles: `la` usa `tree`, `cat` usa `bat`, `v` abre Neovim y `cl`
limpia la pantalla. También existen `cx`, `fcd`, `f` y `fv` para navegación
interactiva.

## Buscar y leer

```sh
rg "texto" .               # opcional: buscar dentro de archivos
bat archivo                 # opcional: lectura con colores
less archivo
tail -f archivo.log
```

## Procesos y diagnóstico

```sh
ps aux | less
top                         # o ptop si está disponible (bpytop)
kill PID                    # verifica el PID antes
command -v herramienta     # comprobar si está instalada
which herramienta
uname -a
df -h && free -h
```

Para diagnosticar el entorno: `echo "$SHELL"`, `echo "$PATH"`, `zsh --version`,
`kitty --version`, `git --version` y `git config --list`. En Kitty, recarga con
`Ctrl+Shift+R` después de editar `kitty.conf`.

## Git

```sh
git status                  # alias: gst
git diff                    # alias: gdiff
git add archivo             # alias: gadd; ga usa add -p
git commit -m "mensaje"    # alias: gc
git log --oneline --decorate --graph
git branch                  # alias: gb
git stash
git stash pop
```

`gl` ofrece un log gráfico más detallado, `lg` abre LazyGit (opcional) y `gco`
facilita cambiar de rama. Revisa siempre `status` y `diff` antes de confirmar.

## Neovim y herramientas opcionales

```sh
v archivo                  # nvim
nvim .
lg                         # lazygit, opcional
```

Si están instalados, Docker usa `dco` (`docker compose`), `dps` (`docker ps`),
`dpa` y `dx` (`docker exec -it`). Kubernetes usa `k` (`kubectl`), `kg`, `kd`,
`kdel`, `ka`, `kc` (kubectx) y `kns` (kubens). Comprueba disponibilidad con
`command -v docker`, `command -v kubectl`, `command -v lazygit` y `command -v nvim`.

## Clipboard

Kitty ofrece `Ctrl+Shift+C/V`. En la shell, `copy_to_clipboard` detecta
`pbcopy`, `wl-copy`, `xclip` o `xsel`; si ninguno existe, instala el soporte
apropiado para tu sistema o usa redirecciones con cuidado.

## Validación del repositorio

Desde la raíz de dotfiles:

```sh
bash -n install.sh
bash -n bootstrap-ubuntu.sh
zsh -n zsh/.zshrc
git diff --check
./bootstrap-ubuntu.sh --dry-run
```

El dry-run muestra las acciones previstas sin instalar paquetes ni modificar
la configuración.
