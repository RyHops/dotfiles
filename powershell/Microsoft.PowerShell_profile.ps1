# --- Directory shortcuts ---
function docs { Set-Location ([Environment]::GetFolderPath('MyDocuments')) }
function desk { Set-Location ([Environment]::GetFolderPath('Desktop')) }
function home { Set-Location $HOME }
function dl   { Set-Location (Join-Path $HOME 'Downloads') }

# --- Autocomplete (carapace) ---
Set-PSReadLineOption -PredictionSource None
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
if (Get-Command carapace -ErrorAction SilentlyContinue) {
    $env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
    carapace _carapace | Out-String | Invoke-Expression
}

# --- Chocolatey ---
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# --- Fix PSStyle colors (Earthtone) ---
$PSStyle.FileInfo.Directory    = "$($PSStyle.Background.Default)$($PSStyle.Foreground.FromRgb(0x5B7E99))"  # navy slate
$PSStyle.FileInfo.Executable   = "$($PSStyle.Background.Default)$($PSStyle.Foreground.FromRgb(0x7A9A6A))"  # moss
$PSStyle.FileInfo.SymbolicLink = "$($PSStyle.Background.Default)$($PSStyle.Foreground.FromRgb(0x6A9E8A))"  # sage

# --- Oh My Posh prompt (Earthtone P10k) ---
oh-my-posh init pwsh --config "$HOME/.config/omp/earthtone-p10k.omp.json" | Invoke-Expression

# --- CLI Tools ---

# eza (better ls)
Set-Alias ls eza
function la { eza --icons=always -la @args }
function lt { eza --icons=always --tree --level=2 @args }

# bat (better cat)
$env:BAT_THEME = 'Catppuccin Mocha'
Set-Alias cat bat

# zoxide (smart cd)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Set-Alias cd z -Option AllScope

# fzf (fuzzy finder)
$env:FZF_DEFAULT_COMMAND = 'fd --hidden --strip-cwd-prefix --exclude .git'
$env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
$env:FZF_ALT_C_COMMAND = 'fd --type=d --hidden --strip-cwd-prefix --exclude .git'
$env:FZF_DEFAULT_OPTS = '--color=fg:#c8bfb0,bg:#2b2b2b,hl:#c06070,fg+:#ddd5c8,bg+:#383838,hl+:#c06070,info:#5b7e99,prompt:#6a9e8a,pointer:#d4b07a,marker:#d4b07a,spinner:#6a9e8a,header:#5b7e99'

# yazi (terminal file manager) — changes cwd on exit
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content $tmp -ErrorAction SilentlyContinue
    if ($cwd -and $cwd -ne (Get-Location).Path) {
        Set-Location $cwd
    }
    Remove-Item $tmp -ErrorAction SilentlyContinue
}
