Set-Alias c code-insiders
Set-Alias g git
Set-Alias y yarn
Set-Alias e explorer
Set-Alias p poetry
Set-Alias s scoop
Set-Alias d docker
Set-Alias w winget
Set-Alias u ubuntu
Set-Alias vim nvim
Set-Alias viq nvim-qt
Set-Alias dco docker-compose
Set-Alias py python
Set-Alias which get-command
Set-Alias lg lazygit
Set-Alias lzd lazydocker
Set-Alias ipy ipython
Set-Alias touch New-Item

function vimrc { vim "$HOME\AppData\Local\nvim\init.vim" }
function ws {cd "D:\0Workspace"}
function le {cd "D:\0learn-everything"}
function qbot {cd "cd D:\0ArtinD\qbot"}
function vipro { nvim $PROFILE }
# Open Git Kraken
function krak() {
  $curpath = (get-location).ProviderPath
  & gitkraken.exe --new-window --path $curpath
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
    Copy-Item $HOME\.config\starship.toml $HOME\dotfiles\_rc\starship.toml
    scoop export > $HOME\dotfiles\windows\scoop.list
}
function rmrf { rm -Recurse -Force $args[0] }
Function Set-Ownership()
{
    $file = $args[0]
	# The takeown.exe file should already exist in Win7 - Win10 
	try { & takeown /f $file }
	catch { Write-Output "Failed to take ownership of $file" }
}

Function Set-Permissions($file)
{
    $file = $args[0]
	$ACL = Get-Acl $file
	$AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "Allow")
	$ACL.SetAccessRule($AccessRule)
	$ACL | Set-Acl $file
}

function ding() {
    $port = $args[0]
    $DingPath = "D:\0Workspace\pierced\windows_64"
    & "$DingPath\ding.exe" -config="$DingPath\ding.cfg" -subdomain=artin $port
}

function mcd() {
    $path = $args[0]
    mkdir "$path"
    cd "$path"
}

$env:term='xterm-256color'
Invoke-Expression (&starship init powershell)
