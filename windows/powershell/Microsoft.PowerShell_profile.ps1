# Import-Module oh-my-posh
Import-Module posh-git
Import-Module ZLocation
Import-Module PSReadLine

Install-GuiCompletion -Key Tab

# Set-Theme artin-theme

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
Set-Alias dig nali-dig
Set-Alias ping nali-ping
Set-Alias nslookup nali-nslookup
Set-Alias traceroute nali-traceroute
Set-Alias tracepath nali-tracepath
function vimrc { vim C:\Users\withw\AppData\Local\nvim\init.vim }
function ws {cd "D:\0Workspace"}
function vipro { nvim $PROFILE }
function vish { nvim C:\Users\withw\.config\starship.toml }
function cdtmp {
    $parent = [System.IO.Path]::GetTempPath()
    $name = 'artin-' + [System.IO.Path]::GetRandomFileName()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
    cd (Join-Path $parent $name)
}
function wshutdown { wsl.exe --shutdown }
function bk {
    Copy-Item ~\AppData\Local\nvim\init.vim ~\dotfiles\windows\nvim
    Copy-Item ~\.config\starship.toml ~\dotfiles\_rc
    Copy-Item $PROFILE ~\dotfiles\windows\powershell
    Copy-Item $PROFILE\..\PoshThemes ~\dotfiles\windows\powershell -Recurse -Force
}
function vitmp { nvim ~\0Workspace\tmpfile }
function rmrf { rm -Recurse -Force $args[0] }
function u-nvim {
    scoop update neovim-nightly --force
}
function r-sh {
    Copy-Item ~\dotfiles\_rc\starship.toml ~\.config
}
$env:term='xterm-256color'

Set-PSReadLineOption -HistorySearchCursorMovesToEnd

Set-PSReadLineKeyHandler -Key F7 `
                         -BriefDescription History `
                         -LongDescription 'Show command history' `
                         -ScriptBlock {
    $pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
    if ($pattern)
    {
        $pattern = [regex]::Escape($pattern)
    }

    $history = [System.Collections.ArrayList]@(
        $last = ''
        $lines = ''
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadLineOption).HistorySavePath))
        {
            if ($line.EndsWith('`'))
            {
                $line = $line.Substring(0, $line.Length - 1)
                $lines = if ($lines)
                {
                    "$lines`n$line"
                }
                else
                {
                    $line
                }
                continue
            }

            if ($lines)
            {
                $line = "$lines`n$line"
                $lines = ''
            }

            if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
            {
                $last = $line
                $line
            }
        }
    )
    $history.Reverse()

    $command = $history | Out-GridView -Title History -PassThru
    if ($command)
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
    }
}
Invoke-Expression (&starship init powershell)
