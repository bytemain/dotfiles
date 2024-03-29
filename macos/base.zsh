export GOPATH="$HOME/go"
export TIME_STYLE=iso

#export PATH="$(pwd)/node_modules/.bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"
export PATH="$HOME/dotfiles/bin/git-extras:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH=$NPM_CONFIG_PREFIX/bin:$PATH
export PATH="$HOME/.poetry/bin:$PATH"
export PATH=$PATH:/opt/local/bin
export PATH="$PATH:$HOME/.local/bin"
export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:$GOPATH/bin
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export PATH=$JAVA_HOME/bin:$PATH
# export PATH=$HOME/depot_tools:$PATH
export CPLUS_INCLUDE_PATH=/opt/homebrew/include
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/ruby/3.0.0/bin:$PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.moon/bin:$PATH"

# alias
alias ls="exa"
alias ll='ls -lh'
alias la='ls -lah'
alias tree='exa --tree'
alias cat='bat'

alias -- -='cd -'

alias o=open
alias md='mkdir -p'
alias mv="mv -v"
alias cp="cp -v"
alias mkdir="mkdir -v"
alias rmcdir="source delete-current-dir.sh"
alias b=brew
alias y=yarn
alias t=tnpm
alias pn=pnpm
alias p=projj
alias pf="projj find"
alias py="python3"
alias ipy="ipython"
alias vizsh="vim ~/.zshrc"
alias cozsh="code ~/.zshrc"
alias vibzsh="vim ~/dotfiles/macos/base.zsh"
alias cobzsh="code ~/dotfiles/macos/base.zsh"
alias vimrc="vim ~/.vimrc"
alias c="code"
alias ws="cd ~/0Workspace"
alias cr="cd ~/0CodeRunner"
alias crt="cd ~/0CodeRunner/tmp"
alias cls=clear
alias rmrf="rm -rf"
alias rmt="trash"
alias d=docker
alias dco="docker-compose"
alias ping="nali-ping"
alias dig="nali-dig"
alias traceroute="nali-traceroute"
alias tracepath="nali-tracepath"
alias nslookup="nali-nslookup"
alias top=htop
alias g=git
alias tk=take
alias cg=cargo
alias gcid="git log | head -1 | awk '{print substr(\$2,1,7)}'"
alias src="source ~/.zshrc"
alias cpwd="pwd | pbcopy"
alias bru="bun run"
alias yless="jless --yaml"
alias myip="echo Your ip is; dig +short myip.opendns.com @resolver1.opendns.com;"

alias emenv='source "$HOME/0Workspace/emsdk/emsdk_env.sh"'

alias tl="tmux list-sessions"
alias tks="tmux kill-session -t"
alias ta="tmux attach -t"
alias ts="tmux new-session -s"

alias _='sudo '

alias doh='dog -H @https://dns.alidns.com/dns-query'

alias vf=vfox

alias sv='caddy file-server --listen :2000 --browse'

alias -g dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias -g o='open'
alias -g ow='open -a'

alias cobi='cd "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Craft"'

alias -g chrome-no-sec="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome   --disable-web-security  --user-data-dir=~/.chromeTemp"

alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"

alias gl="git log --pretty=format:\"%C(auto)%h %C(magenta)<%ad> %C(green)[%an] %C(blue normal bold)| %Creset%s%C(auto)%d\" --graph --date=short"

alias get_idf='. $HOME/esp2/esp-idf/export.sh'

# completion detail
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files

# case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# process completion
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

gig() { curl -L -s https://www.gitignore.io/api/$@;}

take() {
  mkdir -p $@ && cd ${@:$#}
}

ding() {
    DING_PATH="$HOME/0Workspace/pierced/mac_64"
    command="$DING_PATH/ding -config=$DING_PATH/ding.cfg -subdomain=artin $1"
    eval "$command"
}

add_path() {
    export PATH=$1:$PATH
}

init_npm() {
    npm install -g nali-cli trash-cli zx yarn
    npm install -g @githubnext/github-copilot-cli
    npm install -g projj
}

init_vfox() {
  brew tap version-fox/tap
  brew install vfox
}

zsh_history_fix() {
    mv ~/.zsh_history ~/.zsh_history_bad
    strings ~/.zsh_history_bad > ~/.zsh_history
    fc -R ~/.zsh_history
    rm ~/.zsh_history_bad
}

ss() {
    set -a # automatically export all variables
    source $1
    set +a
}

# Kills a process running on a specified tcp port
killport() {
  for port in "$@"
  do
    lsof -i tcp:$port | awk 'NR!=1 {print $2}' | xargs kill -9
  done
}

# Move and make parent directories
mvp() {
    source="$1"
    target="$2"
    target_dir="$(dirname "$target")"
    mkdir -p $target_dir; mv $source $target
}

touchp() {
    target="$1"
    target_dir="$(dirname "$target")"
    mkdir -p $target_dir; touch $target
}

function depot_tools_mirror() {
  export PATH=$HOME/depot_tools_mirror:$PATH
}

function confirm() {
  local message="$1"
  local prompt="Are you sure you want to continue? (y/n)"
  if [ -n "$message" ]; then
    prompt="$message $prompt"
  fi

  echo "$prompt"
  read confirm

  if [ "$confirm" = "y" ]; then
    echo "Continuing..."
    return 0
  else
    echo "Operation canceled."
    return 1
  fi
}


cleantmp() {
  confirm || return
  sudo find /tmp -type f -atime +10 -delete
}

cleanoutdate() {
  confirm || return
  sudo find . -type d -mtime +7d -ls -delete -print
}

# Proxy configuration
getIp() {
    export PROXY_SOCKS5="socks5://127.0.0.1:7891"
    export PROXY_HTTP="http://127.0.0.1:7890"
}

ip_() {
    getIp
    https --follow -b https://api.ip.sb/geoip/$1
}

proxy_npm() {
    getIp
    npm config set proxy ${PROXY_HTTP}
    npm config set https-proxy ${PROXY_HTTP}
    yarn config set proxy ${PROXY_HTTP}
    yarn config set https-proxy ${PROXY_HTTP}
}

unpro_npm() {
    npm config delete proxy
    npm config delete https-proxy
    yarn config delete proxy
    yarn config delete https-proxy
}

proxy() {
    getIp
    export_proxy
    ip_
}

export_proxy() {
    export https_proxy=${PROXY_HTTP}
    export http_proxy=${PROXY_HTTP}
    export all_proxy=${PROXY_SOCKS5}
}

unpro() {
    unset https_proxy
    unset http_proxy
    unset all_proxy
    ip_
}

flushdns() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    sudo killall mDNSResponderHelper
}

docker_deep_clean() {
    echo "Removing exited containers..."
    echo "============================="
    docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v
    echo ""
    echo "Removing unused images..."
    echo "========================="
    docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs docker rmi
    echo ""
    echo "Removing unused volumes..."
    echo "=========================="
    docker volume ls -qf dangling=true | xargs docker volume rm
    echo ""
    echo "Done."
}
docker_clean() {
    docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep $1)
}
ar() {
    mv -i "$@" "$HOME/0Archive/"
}
sxattr() {
  sudo xattr -d com.apple.quarantine /Applications/$@
}

upg() {
  zinit self-update
  zinit update
  brew upgrade
}

serv_sfz() {
  sfz . --cors -b 0.0.0.0 -p 3002
}
serv() {
  live-server . --port=8080 --host=0.0.0.0
}

cdtmp() {
  mkdir -p ~/0CodeRunner/tmp/$(date +"%Y%m%d_%H%M%S") && cd `mktemp -d ~/0CodeRunner/tmp/$(date +"%Y%m%d_%H%M%S")/artin-XXXXXX`
}

cdtt() {
  mkdir -p ~/0CodeRunner/tmp/ && cd `mktemp -d ~/0CodeRunner/tmp/$(gdate +"%Y%m%d_%H%M%S_%3N")`
}

cdt() {
  take "~/0CodeRunner/tmp/$1"
}

function f() {
  find . -name "$1"
}
function grepf() {
  ll | grep $1
}

autoload -U compinit && compinit

eval "$(vfox activate zsh)"

eval "$(github-copilot-cli alias -- "$0")"
which projj >/dev/null 2>&1 && eval "$(projj completion)"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# /opt/homebrew/opt/fzf/install install first
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit load "paulirish/git-open"

# Load pure theme
zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/clipboard.zsh
# zinit snippet OMZ::lib/termsupport.zsh


omz_plugins=(
    git
    npm
    yarn
    sudo
    extract
)
for plugin in ${omz_plugins[@]}; do
    zinit snippet OMZP::$plugin
done

# Switching directories for lazy people
setopt autocd
# See: http://zsh.sourceforge.net/Intro/intro_6.html
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

# Disable correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
##### WHAT YOU WANT TO DISABLE FOR WARP - BELOW

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##### WHAT YOU WANT TO DISABLE FOR WARP - ABOVE
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(zoxide init zsh)"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

source $HOME/.config/broot/launcher/bash/br

export PATH="$HOME/.detaspace/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/0Common/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/0Common/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/0Common/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/0Common/google-cloud-sdk/completion.zsh.inc'; fi
