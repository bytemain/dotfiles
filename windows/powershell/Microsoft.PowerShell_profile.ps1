Import-Module oh-my-posh
Import-Module posh-git
Install-GuiCompletion -Key Tab
Import-Module ZLocation
Import-Module posh-docker
Import-Module DockerCompletion

Set-Theme artin-theme

Set-Alias c code-insiders
Set-Alias g git
Set-Alias y yarn
Set-Alias e explorer
Set-Alias p poetry
Set-Alias s scoop
Set-Alias d docker
Set-Alias vim nvim
Set-Alias viq nvim-qt
Set-Alias dc docker-compose
Set-Alias py python
Set-Alias which get-command
Set-Alias lg lazygit
Set-Alias ipy ipython
function vimrc { vim C:\Users\withw\AppData\Local\nvim\init.vim }
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
    Copy-Item ~\AppData\Local\nvim ~\dotfiles\windows -Recurse -Force
    Copy-Item $PROFILE ~\dotfiles\windows\powershell
    Copy-Item $PROFILE\..\PoshThemes ~\dotfiles\windows\powershell -Recurse -Force
}
function vitmp { nvim ~\0Workspace\tmpfile }
function rmrf { rm -Recurse -Force $args[0] }
function u-nvim {
    scoop update neovim-nightly --force
}
$env:term='xterm-256color'
