#!/bin/bash
set -e

echo "=== macOS Dev Environment Setup ==="
echo "Based on: https://www.josean.com/posts/how-to-setup-wezterm-terminal"
echo ""

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
    echo "[0/8] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Load brew into current session (Apple Silicon vs Intel)
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
    fi
fi

# --- Core packages ---
echo "[1/8] Installing core packages..."
brew install git zsh tmux

# --- Font ---
echo "[2/8] Installing JetBrainsMono Nerd Font..."
brew install --cask font-jetbrains-mono-nerd-font

# --- WezTerm ---
echo "[3/8] Installing WezTerm..."
brew install --cask wezterm

# --- CLI tools ---
echo "[4/8] Installing CLI tools (fzf, fd, eza, zoxide, bat, yazi)..."
brew install fzf fd eza zoxide bat yazi

# --- zsh plugins ---
echo "[5/8] Installing zsh plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting

# --- Powerlevel10k ---
echo "[6/8] Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 2>/dev/null || echo "  Already installed"

# --- TPM ---
echo "[7/8] Installing TPM (tmux plugin manager)..."
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || echo "  Already installed"

# --- Oh My Posh ---
echo "[8/8] Installing Oh My Posh..."
brew install jandedobbeleer/oh-my-posh/oh-my-posh

echo ""
echo "=== Linking config files ==="

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

# WezTerm
ln -sf "$DOTFILES/wezterm/.wezterm.lua" ~/.wezterm.lua
echo "  ~/.wezterm.lua -> linked"

# tmux
ln -sf "$DOTFILES/tmux/tmux.conf" ~/.tmux.conf
echo "  ~/.tmux.conf -> linked"

# zsh (shared config with OS detection built in)
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
echo "  ~/.zshrc -> linked"

# OMP theme
mkdir -p ~/.config/omp
ln -sf "$DOTFILES/omp/earthtone-p10k.omp.json" ~/.config/omp/earthtone-p10k.omp.json
echo "  ~/.config/omp/ -> linked"

echo ""
echo "=== DONE! ==="
echo ""
echo "Next steps:"
echo "  1. Open WezTerm"
echo "  2. Powerlevel10k wizard will launch — pick 'rainbow' style, disable transient prompt"
echo "  3. In tmux (Ctrl+a), press Shift+I to install plugins"
echo "  4. Restart terminal to see all changes"
echo ""
