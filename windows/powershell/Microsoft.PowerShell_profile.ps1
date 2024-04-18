sal c code
sal g git
sal y yarn
sal e explorer
sal p poetry
sal s scoop
sal d docker
sal w winget
sal u ubuntu
sal vim nvim
sal viq nvim-qt
sal dco docker-compose
sal py python
sal which get-command
sal lg lazygit
sal lzd lazydocker
sal ipy ipython
sal touch New-Item
sal gpg (join-path (scoop prefix git) 'usr\bin\gpg.exe')

function vimrc { vim "$HOME\AppData\Local\nvim\init.vim" }
function ws {cd "D:\0Workspace"}
function le {cd "D:\0learn-everything"}
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
Import-Module ZLocation
