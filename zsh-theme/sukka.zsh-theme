# Copy and self modified from ys.zsh-theme, the one of default themes in master repository

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

# Directory info.rez
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}on%{$reset_color%} git:%{$terminfo[bold]$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}(%{$fg[red]%}x%{$fg[white]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}(%{$fg[green]%}o%{$fg[white]%})"


# Prompt format: \n # TIME USER at MACHINE in [DIRECTORY] on git:BRANCH \n $
PROMPT="
%{$fg[white]%}[%*] \
%{$fg[cyan]%}%n@$(box_name) \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%} \
${git_info}
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"

if [[ "$USER" == "root" ]]; then
PROMPT="
%{$fg[red]%}[%*] \
%{$fg[yellow]%}%n@$(box_name) \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[cyan]%}${current_dir}%{$reset_color%}\
${git_info}
%{$fg[red]%}# %{$reset_color%}"
fi
