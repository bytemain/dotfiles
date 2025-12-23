export GOPATH="$HOME/go"
export TIME_STYLE=iso

#export PATH="$(pwd)/node_modules/.bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"
export PATH="$HOME/dotfiles/bin/git-extras:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:$GOPATH/bin
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts":$PATH
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"
export PATH=$JAVA_HOME/bin:$PATH
export CPLUS_INCLUDE_PATH=/opt/homebrew/include
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/ruby/3.0.0/bin:$PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.moon/bin:$PATH"
export PATH="$HOME/0Workspace/github.com/ax/apk.sh:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

export ABBR_USER_ABBREVIATIONS_FILE="$HOME/dotfiles/_rc/zsh-abbr/user-abbreviations"

export ANDROID_HOME="$HOME/Library/Android/sdk"
if [[ -d "$ANDROID_HOME/ndk" ]]; then
  export NDK_HOME="$ANDROID_HOME/ndk/$(ls -1 $ANDROID_HOME/ndk | tail -1)"
fi

export PATH="$ANDROID_HOME/cmdline-tools/latest/bin":$PATH
export PATH="$ANDROID_HOME/emulator":$PATH

export DYLD_FALLBACK_LIBRARY_PATH="$(xcode-select --print-path)/Toolchains/XcodeDefault.xctoolchain/usr/lib/"
export LDFLAGS=-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib

export DOTFILE_CONFIG_PATH=$HOME/dotfiles/$DOTFILE_NAME
export RUSH_PNPM_STORE_PATH=$HOME/.cache/rush-pnpm-store

# Remove duplicate PATH entries
typeset -U path

alias ls="eza"
alias ll='ls -lh'
alias la='ls -lah'
alias tree='eza --tree'

alias -- -='cd -'

alias md='mkdir -p'
alias mv="mv -iv"
alias cp="cp -riv"
alias mkdir="mkdir -vp"
alias rmcdir="source delete-current-dir.sh"
alias b=brew
alias y=yarn
alias t=trae
alias pn=pnp

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

alias ping="nali-ping"
alias dig="nali-dig"
alias traceroute="nali-traceroute"
alias tracepath="nali-tracepath"
alias nslookup="nali-nslookup"

alias top=htop
alias tk=take
alias cg=cargo

alias g=git
alias gcid="git log | head -1 | awk '{print substr(\$2,1,7)}'"
alias lg=lazygit

alias src="source ~/.zshrc"
alias cpwd="pwd | pbcopy"
alias bru="bun run"
alias yless="jless --yaml"

alias emenv='source "$HOME/0Workspace/emsdk/emsdk_env.sh"'

alias tl="tmux list-sessions"
alias tks="tmux kill-session -t"
alias ta="tmux attach -t"
alias ts="tmux new-session -s"

alias _='sudo '

alias vf=vfox

alias sv='echo http://0.0.0.0:2000 && caddy file-server --listen :2000 --browse'

alias o='open'
alias ow='open -a'

alias chrome-no-sec="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-web-security  --user-data-dir=~/.chrome-temp"

alias d=docker
alias dco="docker-compose"
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"

gig() { curl -L -s https://www.gitignore.io/api/$@;}

take() {
  mkdir -p $@ && cd ${@:$#}
}

add_path() {
    export PATH=$1:$PATH
}

use_npm_mirror() {
    export NPM_CONFIG_REGISTRY=https://registry.npmmirror.com
}

init_shell() {
    setopt -x;
    npm install -g nali-cli trash-cli zx yarn stream.pipeline-shim
    npm install -g live-server

    brew install vfox

    setopt +x;
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
    curl -s "https://api.ip.sb/geoip/$1" -A Mozilla | jq .
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
  sudo xattr -d com.apple.quarantine $@
}

upg() {
  zinit self-update
  zinit update --parallel 5
  brew upgrade
}

serv() {
  live-server . --port=8080 --host=0.0.0.0
}

cdat() {
  mkdir -p ~/0CodeRunner/tmp && cd `mktemp -d ~/0CodeRunner/tmp/artin-XXXXXX`
}

cdtmp() {
  mkdir -p ~/0CodeRunner/tmp/
  cd `mkdir -p ~/0CodeRunner/tmp/$(date +"%Y%m%d_%H%M%S")`
}

cdt() {
  take "~/0CodeRunner/tmp/$1"
}

setup_file_associations() {
    _cmd_exists duti || brew install duti

    duti -s com.trae.ide .js all
    duti -s com.trae.ide .ts all
    duti -s com.trae.ide .json all
    duti -s com.trae.ide .html all
    duti -s com.trae.ide .css all
    duti -s com.trae.ide .md all
    duti -s com.trae.ide .yaml all
    duti -s com.trae.ide .yml all
    duti -s com.trae.ide .py all
    duti -s com.trae.ide .sh all
    duti -s com.trae.ide .zsh all
    duti -s com.trae.ide .rs all
    duti -s com.trae.ide .go all
    duti -s com.trae.ide .java all
}

bk() {
    cp ~/.zshrc $DOTFILE_CONFIG_PATH/zshrc
    brew bundle dump --describe --force --brews --casks --taps --mas --no-upgrade --file="$DOTFILE_CONFIG_PATH/Brewfile"

    cp ~/.vimrc ~/dotfiles/_rc/vimrc
    cp $HOME/Library/Rime/default.custom.yaml ~/dotfiles/rime/default.custom.yaml
    cp $HOME/Library/Rime/double_pinyin_flypy.custom.yaml ~/dotfiles/rime/double_pinyin_flypy.custom.yaml
}

sync-zsh() {
    cp ~/.zshrc ~/.zshrc.bak
    cp $DOTFILE_CONFIG_PATH/zshrc ~/.zshrc
}

function rlp() {
   sudo rm -rf /Library/Caches/com.apple.iconservices.store/
   killall Dock
}

function f() {
  find . -name "$1"
}
function grepf() {
  ll | grep $1
}
function _cmd_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Quick backup with timestamp
bak() {
  for file in "$@"; do
    cp -r "$file" "${file}.bak.$(date +%Y%m%d_%H%M%S)"
  done
}

# Quick note taking
note() {
  local note_file="$HOME/.notes/$(date +%Y%m%d).md"
  mkdir -p "$(dirname "$note_file")"
  if [ $# -eq 0 ]; then
    ${EDITOR:-vim} "$note_file"
  else
    echo "$(date +%H:%M:%S) - $*" >> "$note_file"
  fi
}

# Find largest files/directories
largest() {
  du -ah ${1:-.} | sort -rh | head -n ${2:-20}
}

# Git commit with timestamp
gitcp() {
  git add -A && git commit -m "${1:-Update: $(date +%Y-%m-%d\ %H:%M:%S)}" && git push
}

# Search running processes
psgrep() {
  ps aux | grep -v grep | grep -i -e VSZ -e "$@"
}

# Create directory and cd into it (enhanced)
mkcd() {
  mkdir -p "$@" && cd "${@: -1}"
}

# Quick file search (case-insensitive)
ff() {
  find . -iname "*$1*"
}

# Colored man pages
man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

# Show PATH in readable format
path() {
  echo $PATH | tr ':' '\n' | nl
}

# Quick Git status for multiple repos
gstatus() {
  for dir in */; do
    if [ -d "$dir/.git" ]; then
      echo "\n📁 $dir"
      (cd "$dir" && git status -s)
    fi
  done
}

# Countdown timer
countdown() {
  local seconds=${1:-10}
  while [ $seconds -gt 0 ]; do
    echo -ne "⏱  $seconds\033[0K\r"
    sleep 1
    : $((seconds--))
  done
  echo "✅ Time's up!"
}

# Show disk usage of current directory
duf() {
  du -sh ${1:-.}/* | sort -rh | head -n ${2:-20}
}

# URL encode/decode
urlencode() {
  node -e "console.log(encodeURIComponent(process.argv[1]))" "$1"
}

urldecode() {
  node -e "console.log(decodeURIComponent(process.argv[1]))" "$1"
}

# JSON pretty print from clipboard
jsonpp() {
  pbpaste | jq '.' | pbcopy && echo "✅ JSON formatted and copied to clipboard"
}

# Quick benchmark command
bench() {
  time ( for i in {1..10}; do "$@" > /dev/null 2>&1; done )
}

# Search command history
h() {
  if [ $# -eq 0 ]; then
    history 50
  else
    history | grep -i "$@"
  fi
}

# Calculate math expressions
calc() {
  node -e "console.log($*)"
}

# Remove PATH duplicates
dedupe_path() {
  export PATH=$(echo -n $PATH | awk -v RS=: -v ORS=: '!x[$0]++' | sed 's/:$//')
}

function _cache() {
  emulate -L zsh
  local -r cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
  autoload -Uz _store_cache compinit
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path $cache_dir/.zcompcache
  [[ -f $cache_dir/.zcompcache/.make-cache-dir ]] || _store_cache .make-cache-dir
  compinit -C -d $cache_dir/.zcompdump
}
_cache

autoload -U compinit && compinit

setopt interactivecomments
# Switching directories for lazy people
setopt autocd
# See: http://zsh.sourceforge.net/Intro/intro_6.html
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
setopt no_share_history

# Disable correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"


# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# /opt/homebrew/opt/fzf/install install first
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit light "paulirish/git-open"
zinit light "mfaerevaag/wd"

# Load pure theme
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

omz_libs=(
    lib/history.zsh
    lib/git.zsh
    lib/clipboard.zsh
    lib/grep.zsh
    plugins/npm
    plugins/git
    plugins/sudo
    plugins/extract
    plugins/yarn
)
for lib in ${omz_libs[@]}; do
    zinit snippet OMZ::$lib
done

omz_completions=(
    extract/_extract
    yarn/_yarn
)

for comp in ${omz_completions[@]}; do
    zi ice as"completion"
    zi snippet OMZP::$comp
done

setopt RE_MATCH_PCRE   # _fix-omz-plugin function uses this regex style

# Workaround for zinit issue#504: remove subversion dependency. Function clones all files in plugin
# directory (on github) that might be useful to zinit snippet directory. Should only be invoked
# via zinit atclone"_fix-omz-plugin"
_fix-omz-plugin() {
  if [[ ! -f ._zinit/teleid ]] then return 0; fi
  if [[ ! $(cat ._zinit/teleid) =~ "^OMZP::.*" ]] then return 0; fi
  local OMZP_NAME=$(cat ._zinit/teleid | sed -n 's/OMZP:://p')
  git clone --quiet --no-checkout --depth=1 --filter=tree:0 https://github.com/ohmyzsh/ohmyzsh
  cd ohmyzsh
  git sparse-checkout set --no-cone plugins/$OMZP_NAME
  git checkout --quiet
  cd ..
  local OMZP_PATH="ohmyzsh/plugins/$OMZP_NAME"
  local file
  for file in ohmyzsh/plugins/$OMZP_NAME/*~(.gitignore|*.plugin.zsh)(D); do
    local filename="${file:t}"
    echo "Copying $file to $(pwd)/$filename..."
    cp $file $filename
  done
  rm -rf ohmyzsh
}

zle_highlight=('paste:none')

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit wait lucid for \
  atpull"%atclone" atclone"_fix-omz-plugin" \
    OMZP::colored-man-pages \
  atpull"%atclone" atclone"_fix-omz-plugin" \
    OMZP::aliases \

unsetopt RE_MATCH_PCRE

unalias zi > /dev/null  2>&1 || true

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
##### WHAT YOU WANT TO DISABLE FOR WARP - BELOW

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##### WHAT YOU WANT TO DISABLE FOR WARP - ABOVE
fi

if [[ $TERM_PRODUCT != "Trae" ]]; then
##### WHAT YOU WANT TO DISABLE FOR Trae - BELOW


##### WHAT YOU WANT TO DISABLE FOR Trae - ABOVE
fi

# iTerm2-specific settings
if [[ "$__CFBundleIdentifier" == "com.googlecode.iterm2" ]]; then
  export MCFLY_LIGHT=TRUE
fi
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_KEY_SCHEME=vim

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

[ -f $HOME/.config/broot/launcher/bash/br ] && source $HOME/.config/broot/launcher/bash/br

unalias x > /dev/null  2>&1 || true
[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.

# CN mirror start
export ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/"
export VFOX_PYTHON_MIRROR=https://mirrors.huaweicloud.com/python/
export VFOX_NODEJS_MIRROR=https://cdn.npmmirror.com/binaries/node
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
# CN mirror end

_cmd_exists zoxide && eval "$(zoxide init zsh)"
_cmd_exists vfox && eval "$(vfox activate zsh)"
_cmd_exists direnv && eval "$(direnv hook zsh)"
_cmd_exists fx && source <(fx --comp zsh)
_cmd_exists prog && eval "$(prog shell zsh)"
_cmd_exists mcfly && eval "$(mcfly init zsh)"

source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-abbr:$FPATH

  autoload -Uz compinit
  compinit
fi

[ -f ~/.private.zshrc ] && source ~/.private.zshrc
