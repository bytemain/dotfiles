Import-Module posh-git
Import-Module oh-my-posh
Set-PSReadlineKeyHandler -Key Tab -ScriptBlock { Invoke-GuiCompletion }

(& "D:\Miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression

Set-Theme artin-theme

Set-Alias c code
Set-Alias g git
Set-Alias e explorer
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias lg lazygit
Set-Alias which get-command

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
    Copy-Item ~\OneDrive\bin\wsl2.ps1 ~\dotfiles\windows
    Copy-Item ~\AppData\Local\nvim\init.vim ~\dotfiles\windows
    Copy-Item $PROFILE ~\dotfiles\windows\powershell
    Copy-Item $PROFILE\..\PoshThemes ~\dotfiles\windows\powershell -Recurse -Force
}
function vitmp { nvim ~\0Workspace\tmpfile }
function udwsl { sudo powershell -ExecutionPolicy ByPass -File "~\OneDrive\bin\wsl2.ps1" }


$env:TERM='xterm-256color'

