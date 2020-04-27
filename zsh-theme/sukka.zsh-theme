# Copy and self modified from ys.zsh-theme, the one of default themes in master repository
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# 2018-12-07 - Sukka
# 2020-04-27 - Artin

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

# Directory info.rez
local current_dir='${PWD/#$HOME/~}'

# VCS
YS_VCS_PROMPT_PREFIX1="%{$fg[white]%}on%{$reset_color%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%} "
YS_VCS_PROMPT_DIRTY="%{$fg[white]%}(%{$fg[red]%}✗%{$fg[white]%})"
YS_VCS_PROMPT_CLEAN="%{$fg[white]%}(%{$fg[green]%}✓%{$fg[white]%})"

# Git info.
local git_info='$(git_prompt_info)'
local git_last_commit='$(git log --pretty=format:"%h %s" -1 2> /dev/null)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"


# Prompt format: \n # TIME USER at MACHINE in [DIRECTORY] on git:BRANCH STATE \n $
PROMPT="%{$fg[cyan]%}[%*] \
%{$fg[green]%}%n@$(box_name) \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[blue]%}${current_dir}%{$reset_color%}\
${git_info}
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"

if [[ "$USER" == "root" ]]; then
PROMPT="%{$fg[red]%}[%*] \
%{$fg[yellow]%}%n@$(box_name) \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[cyan]%}${current_dir}%{$reset_color%}\
${git_info}
%{$terminfo[bold]$fg[red]%}# %{$reset_color%}"
fi
