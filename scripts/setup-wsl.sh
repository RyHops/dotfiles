#!/usr/bin/env bash
set -e

echo "=== WSL2/Linux Dev Environment Setup ==="
echo ""

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

# --- Core packages ---
echo "[1/8] Installing zsh and core tools..."
sudo apt-get update -qq
sudo apt-get install -y zsh git curl wget unzip tmux

# --- fd & bat ---
echo "[2/8] Installing fd and bat..."
sudo apt-get install -y fd-find bat

# --- eza ---
echo "[3/8] Installing eza..."
if ! command -v eza &>/dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg
    sudo apt-get update -qq
    sudo apt-get install -y eza
else
    echo "  Already installed"
fi

# --- fzf ---
echo "[4/8] Installing fzf..."
if ! command -v fzf &>/dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null || true
    ~/.fzf/install --all --no-bash --no-fish
else
    echo "  Already installed"
fi

# --- zoxide ---
echo "[5/8] Installing zoxide..."
if ! command -v zoxide &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
else
    echo "  Already installed"
fi

# --- yazi ---
echo "[6/8] Installing yazi..."
if ! command -v yazi &>/dev/null; then
    YAZI_URL=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep "browser_download_url.*x86_64-unknown-linux-gnu.zip" | head -1 | cut -d'"' -f4)
    if [ -n "$YAZI_URL" ]; then
        wget -q "$YAZI_URL" -O /tmp/yazi.zip
        unzip -oq /tmp/yazi.zip -d /tmp/yazi
        sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
        sudo mv /tmp/yazi/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
        rm -rf /tmp/yazi /tmp/yazi.zip
    fi
else
    echo "  Already installed"
fi

# --- Powerlevel10k + zsh plugins ---
echo "[7/8] Installing Powerlevel10k and zsh plugins..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k 2>/dev/null || echo "  p10k already installed"
mkdir -p ~/.zsh
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions 2>/dev/null || echo "  autosuggestions already installed"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting 2>/dev/null || echo "  syntax-highlighting already installed"

# --- TPM ---
echo "[8/8] Installing TPM..."
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || echo "  tpm already installed"

echo ""
echo "=== Linking config files ==="

# tmux
ln -sf "$DOTFILES/tmux/tmux.conf" ~/.tmux.conf
echo "  ~/.tmux.conf -> linked"

# zsh
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
echo "  ~/.zshrc -> linked"

# Set zsh as default shell
echo ""
echo "=== Setting zsh as default shell ==="
sudo chsh -s /usr/bin/zsh $(whoami)

echo ""
echo "=== DONE! ==="
echo ""
echo "Next steps:"
echo "  1. Open a new terminal / restart WSL"
echo "  2. Powerlevel10k wizard will launch — pick 'rainbow' style, disable transient prompt"
echo "  3. In tmux (Ctrl+a), press Shift+I to install plugins"
echo ""
