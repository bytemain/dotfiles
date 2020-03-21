Import-Module oh-my-posh
Import-Module posh-git
Import-Module posh-docker
Install-GuiCompletion -Key Tab
Import-Module DockerCompletion

Set-Theme artin-theme

Set-Alias c code-insiders
Set-Alias g git
Set-Alias y yarn
Set-Alias e explorer
Set-Alias p poetry
Set-Alias py python
Set-Alias vim nvim
Set-Alias vimq nvim-qt
Set-Alias vi nvim
Set-Alias viq nvim-qt
Set-Alias which get-command
Set-Alias dco docker-compose
Set-Alias dc docker
Set-Alias lg lazygit
Set-Alias ipy ipython
function vimrc { vim ~\AppData\Local\nvim\init.vim }
function ws {cd "D:\0Workspace"}
function vipro { nvim $PROFILE }
function cdtmp {
    $parent = [System.IO.Path]::GetTempPath()
    $name = 'artin-' + [System.IO.Path]::GetRandomFileName()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
    cd (Join-Path $parent $name)
}
function bk {
    Copy-Item ~\AppData\Local\nvim\init.vim ~\dotfiles\windows
    Copy-Item $PROFILE ~\dotfiles\windows\powershell
    Copy-Item $PROFILE\..\PoshThemes ~\dotfiles\windows\powershell -Recurse -Force
}
function vitmp { nvim ~\0Workspace\tmpfile }


$env:term='xterm-256color'
