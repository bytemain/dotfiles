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
L_PARE="%{$fg[white]%}("
R_PARE="$fg[white]%})"
ZSH_THEME_GIT_PROMPT_ADDED="${L_PARE}%{$fg[cyan]%} ✈${R_PARE}"
ZSH_THEME_GIT_PROMPT_MODIFIED="${L_PARE}%{$fg[yellow]%} ✭${R_PARE}"
ZSH_THEME_GIT_PROMPT_DELETED="${L_PARE}%{$fg[red]%} ✗${R_PARE}"
ZSH_THEME_GIT_PROMPT_RENAMED="${L_PARE}%{$fg[blue]%} ➦${R_PARE}"
ZSH_THEME_GIT_PROMPT_UNMERGED="${L_PARE}%{$fg[magenta]%} ✂${R_PARE}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${L_PARE}%{$fg[grey]%} ✱${R_PARE}"
ZSH_THEME_GIT_PROMPT_DIRTY="${L_PARE}%{$fg[red]%}✗${R_PARE}"
ZSH_THEME_GIT_PROMPT_CLEAN="${L_PARE}%{$fg[green]%}✓${R_PARE}"

# Git info.
local git_info='$(git_prompt_info)'
local git_last_commit='$(git log --pretty=format:"%h %s" -1 2> /dev/null)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}on%{$reset_color%} git:%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "


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
 $(git_prompt_info)
%{$terminfo[bold]$fg[red]%}# %{$reset_color%}"
fi
