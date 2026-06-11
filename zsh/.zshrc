# --- PATH ---
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.fzf/bin:$PATH"

# Oh My Posh prompt (earthtone theme — matches Windows)
eval "$(oh-my-posh init zsh --config ~/.config/omp/earthtone-p10k.omp.json)"

# Sparse lines — blank line before each prompt (like P10k sparse mode)
precmd() { echo }

# --- History ---
HISTFILE=$HOME/.zhistory
SAVEHIST=5000
HISTSIZE=5000
setopt share_history hist_expire_dups_first hist_ignore_dups hist_verify

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# --- Plugins (OS-aware paths) ---
if [[ "$OSTYPE" == "darwin"* ]]; then
  BREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
  [[ -d "$BREW_PREFIX" ]] || BREW_PREFIX="/usr/local"
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- fzf (OS-aware init) ---
if [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(fzf --zsh)"
else
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# fzf Earthtone theme
fg="#c8bfb0"; bg="#2b2b2b"; bg_highlight="#383838"
purple="#a07080"; blue="#5b7e99"; cyan="#6a9e8a"
export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# fd/bat command names differ (Debian: fdfind/batcat, macOS: fd/bat)
if command -v fdfind &>/dev/null; then
  alias fd="fdfind"
  export FZF_DEFAULT_COMMAND="fdfind --hidden --strip-cwd-prefix --exclude .git"
else
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND/ --hidden/ --type=d --hidden}"

if command -v batcat &>/dev/null; then
  alias cat="batcat"
  show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else batcat -n --color=always --line-range :500 {}; fi"
else
  show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
fi
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# --- Aliases ---
alias ls="eza --icons=always"
alias la="eza --icons=always -la"
alias lt="eza --icons=always --tree --level=2"

# --- bat ---
export BAT_THEME="Catppuccin Mocha"

# --- yazi (changes cwd on exit) ---
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

export EDITOR="nvim"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# --- zoxide (MUST stay last in this file) ---
# zoxide's doctor warns when anything reinitializes the shell after its init —
# conda's shell hook above wraps `cd`, which clobbers the `cd=z` alias and
# trips the warning. Keep this block as the LAST thing in .zshrc.
# _ZO_DOCTOR=0: Claude Code's shell snapshot restores functions/aliases but not
# zsh hook arrays, so the doctor false-alarms in agent shells. Config is correct.
export _ZO_DOCTOR=0
eval "$(zoxide init zsh)"
alias cd="z"

