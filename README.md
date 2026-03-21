# dotfiles

Cross-platform dev environment: WezTerm + tmux + zsh + earthtone color scheme.

Built from [Josean's WezTerm setup](https://www.josean.com/posts/how-to-setup-wezterm-terminal) ([repo](https://github.com/josean-dev/dev-environment-files)), adapted for Windows + macOS with a custom earthtone palette.

## Packages

### macOS (Homebrew)

| Package | Purpose |
|---------|---------|
| `wezterm` | Terminal emulator |
| `tmux` | Terminal multiplexer |
| `font-jetbrains-mono-nerd-font` | Nerd Font for icons |
| `powerlevel10k` | zsh prompt theme |
| `zsh-autosuggestions` | Ghost text suggestions |
| `zsh-syntax-highlighting` | Command coloring |
| `oh-my-posh` | Prompt engine (for consistency with Windows) |
| `fzf` | Fuzzy finder |
| `fd` | Fast `find` replacement |
| `eza` | Modern `ls` with icons |
| `zoxide` | Smart `cd` replacement |
| `bat` | Syntax-highlighted `cat` |
| `yazi` | Terminal file manager |

### Windows (scoop + winget)

| Package | Source | Purpose |
|---------|--------|---------|
| `wezterm` | winget | Terminal emulator |
| `oh-my-posh` | winget | Prompt engine |
| `fzf` | scoop | Fuzzy finder |
| `fd` | scoop | Fast `find` replacement |
| `eza` | scoop | Modern `ls` with icons |
| `zoxide` | scoop | Smart `cd` replacement |
| `bat` | scoop | Syntax-highlighted `cat` |
| `yazi` | scoop | Terminal file manager |

### WSL2 / Linux (apt + git)

Same as macOS packages but installed via `apt`, `git clone`, and direct binaries. See `scripts/setup-wsl.sh`.

## Setup

### macOS

```bash
git clone https://github.com/RyHops/dotfiles.git ~/dotfiles
chmod +x ~/dotfiles/scripts/setup-macos.sh
~/dotfiles/scripts/setup-macos.sh
```

### Windows

1. Install [WezTerm](https://wezfurlong.org/wezterm/installation), [scoop](https://scoop.sh), [Oh My Posh](https://ohmyposh.dev)
2. Clone this repo
3. Symlink or copy configs:
   ```powershell
   Copy-Item dotfiles\wezterm\.wezterm.lua $HOME\.wezterm.lua
   Copy-Item dotfiles\omp\earthtone-p10k.omp.json $HOME\.config\omp\earthtone-p10k.omp.json
   Copy-Item dotfiles\powershell\Microsoft.PowerShell_profile.ps1 $PROFILE
   ```
4. Install CLI tools: `scoop install fzf fd eza zoxide bat yazi`

### WSL2

```bash
git clone https://github.com/RyHops/dotfiles.git ~/dotfiles
chmod +x ~/dotfiles/scripts/setup-wsl.sh
~/dotfiles/scripts/setup-wsl.sh
```

## Post-setup

1. Open WezTerm
2. Powerlevel10k wizard launches — pick **rainbow** style, **disable transient prompt**
3. In tmux, press `Ctrl+a` then `Shift+I` to install plugins
4. Customize P10k colors in `~/.p10k.zsh` to match earthtone palette

## Color Palette

| Role | Hex | Name |
|------|-----|------|
| Background | `#2b2b2b` | Graphite |
| Foreground | `#d5cdc0` | Cream |
| Black | `#3c3836` | Warm charcoal |
| Red | `#b85060` | Maroon |
| Green | `#8aaa78` | Moss |
| Yellow | `#daba84` | Tan/Camel |
| Blue | `#6a90aa` | Navy slate |
| Magenta | `#b08090` | Dusty berry |
| Cyan | `#78b098` | Sage green |
| White | `#d5cdc0` | Cream |
| Cursor | `#d4b07a` | Tan |

### OMP Prompt Accents

| Segment | Hex | Name |
|---------|-----|------|
| OS icon / Clock bg | `#E5DCC7` | Cream |
| Git branch bg | `#B1A079` | Khaki |
| Conda / Python bg | `#80A798` | Sage |
| Status check bg | `#675951` | Brown |
| Directory bg | `#5b7e99` | Navy slate |
| Username bg | `#8a8ea0` | Lavender |

## File Map

```
dotfiles/
├── wezterm/.wezterm.lua          # Cross-platform WezTerm config
├── tmux/tmux.conf                # tmux config (Catppuccin + vim-navigator)
├── zsh/.zshrc                    # zsh config (shared, OS-aware)
├── powershell/                   # Windows PowerShell profile
├── omp/earthtone-p10k.omp.json  # Oh My Posh theme
└── scripts/
    ├── setup-macos.sh            # macOS setup (Homebrew)
    └── setup-wsl.sh              # WSL2/Linux setup (apt)
```

## tmux Cheat Sheet

Prefix: `Ctrl+a`

| Action | Keys |
|--------|------|
| Split horizontal | `Ctrl+a` then `\|` |
| Split vertical | `Ctrl+a` then `-` |
| Navigate panes | `Ctrl+a` then `h/j/k/l` |
| Zoom pane | `Ctrl+a` then `m` |
| New window | `Ctrl+a` then `c` |
| Next/prev window | `Ctrl+a` then `n`/`p` |
| Detach | `Ctrl+a` then `d` |
| Reattach | `tmux attach` |
| Reload config | `Ctrl+a` then `r` |
| Install plugins | `Ctrl+a` then `Shift+I` |
