Import-Module posh-git
Import-Module oh-my-posh
Import-Module ZLocation

Install-GuiCompletion -Key Tab

Set-Theme artin-theme

Set-Alias c code
Set-Alias g git
Set-Alias y yarn
Set-Alias e explorer
Set-Alias p poetry
Set-Alias s scoop
Set-Alias d docker
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
function vimrc { vim ~\AppData\Local\nvim\init.vim }
function ws {cd "D:\0Workspace"}
function vipro { nvim $PROFILE }
function cdtmp {
    $parent = [System.IO.Path]::GetTempPath()
    $name = 'artin-' + [System.IO.Path]::GetRandomFileName()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
    cd (Join-Path $parent $name)
}
function wshutdown { wsl.exe --shutdown }
function bk {
    Copy-Item ~\AppData\Local\nvim\init.vim ~\dotfiles\windows\nvim
    Copy-Item $PROFILE ~\dotfiles\windows\powershell
    Copy-Item $PROFILE\..\PoshThemes ~\dotfiles\windows\powershell -Recurse -Force
    Copy-Item ~\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json ~\dotfiles\windows\wt_settings.json
}
function vitmp { nvim ~\0Workspace\tmpfile }
function rmrf { rm -Recurse -Force $args[0] }
function u-nvim {
    scoop update neovim-nightly --force
}
$env:term='xterm-256color'
