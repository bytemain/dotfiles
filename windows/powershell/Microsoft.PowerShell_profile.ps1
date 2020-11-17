# Install-GuiCompletion -Key Tab

# Set-Theme artin-theme

Set-Alias c code-insiders
Set-Alias g git
Set-Alias y yarn
Set-Alias e explorer
Set-Alias p poetry
Set-Alias s scoop
Set-Alias d docker
Set-Alias w winget
Set-Alias vim nvim
Set-Alias viq nvim-qt
Set-Alias dco docker-compose
Set-Alias py python
Set-Alias which get-command
Set-Alias lg lazygit
Set-Alias lzd lazydocker
Set-Alias ipy ipython
# Set-Alias dig nali-dig
# Set-Alias ping nali-ping
# Set-Alias nslookup nali-nslookup
# Set-Alias traceroute nali-traceroute
# Set-Alias tracepath nali-tracepath
function vimrc { vim "$HOME\AppData\Local\nvim\init.vim" }
function ws {cd "D:\0Workspace"}
function vipro { nvim $PROFILE }
# Open Git Kraken
function krak() {
  $curpath = (get-location).ProviderPath
  $logf = "$env:temp\krakstart.log"
  start-process gitkraken.exe -ArgumentList "--new-window --path $curpath" -redirectstandardoutput $logf
}
function cdtmp {
    $parent = [System.IO.Path]::GetTempPath()
    $name = 'artin-' + $([System.IO.Path]::GetRandomFileName()).Split(".")[0]
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
    cd (Join-Path $parent $name)
}
function shizuku { adb shell sh /data/user_de/0/moe.shizuku.privileged.api/start.sh }
function wshutdown { wsl.exe --shutdown }
function bk {
    Copy-Item $HOME\AppData\Local\nvim\init.vim $HOME\dotfiles\windows\nvim
    Copy-Item $PROFILE $HOME\dotfiles\windows\powershell
    Copy-Item $HOME\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json $HOME\dotfiles\windows\wt_settings.json
    scoop export > $HOME\dotfiles\windows\scoop.list
}
function rmrf { rm -Recurse -Force $args[0] }
function u-nvim {
    scoop update neovim-nightly --force
}
$env:term='xterm-256color'
Invoke-Expression (&starship init powershell)
