typeset -U PATH
export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim
export CHEAT_USER_DIR="$HOME/dotfiles/cheat"
export CHEAT_CONFIG_PATH="~/dotfiles/cheat/conf.yml"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export JRE_HOME=$JAVA_HOME/jre
export JAVA_BIN=$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export NVM_DIR="$HOME/.nvm"
LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/llvm/lib -Wl,-rpath,/home/linuxbrew/.linuxbrew/opt/llvm/lib"

NEOVIM_WIN_DIR="/mnt/c/Users/withw/scoop/apps/neovim/current"
ZSH_THEME="sukka"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_DISABLE_COMPFIX=true
source ~/.zsh_plugins.sh

plugins=(
    git
    history
    autojump
    sudo
    docker
    poetry
)

source $ZSH/oh-my-zsh.sh

# ------------------------------ NVM
nvm-update() {
    (
        cd "$NVM_DIR"
        git fetch --tags origin
        git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && \. "$NVM_DIR/nvm.sh"
}

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/artin/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/artin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/artin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/artin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# User configuration

# using *
setopt no_nomatch

# Proxy configuration
winip=$(ip route | grep default | awk '{print $3}')
wslip=$(hostname -I | awk '{print $1}')

PROXY_HTTP="http://${winip}:7890"
PROXY_SOCKS5="socks5://${winip}:7891"

alias winip_="echo ${winip}"
alias wslip_="echo ${wslip}"

x11() {
    if [ ! $1 ]; then
        # null
        export DISPLAY=${winip}:0.0
    else
        export DISPLAY=${winip}:$1.0
    fi
    echo $DISPLAY
    export XDG_SESSION_TYPE=x11
    export XDG_RUNTIME_DIR=/tmp/runtime-root
    export PULSE_SERVER=tcp:$winip
}
ip_() {
    curl https://ip.cn/$1
    # http --follow -b https://api.ip.sb/geoip/$1
    echo "WIN ip: ${winip}"
    echo "WSL ip: ${wslip}"
}

proxy_npm() {
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

proxy () {
    # pip can read http_proxy & https_proxy
    # http_proxy
    export http_proxy="${PROXY_HTTP}"
    export HTTP_PROXY="${PROXY_HTTP}"

    # https_proxy
    export https_proxy="${PROXY_HTTP}"
    export HTTPS_proxy="${PROXY_HTTP}"

    # ftp_proxy
    export ftp_proxy="${PROXY_HTTP}"
    export FTP_PROXY="${PROXY_HTTP}"

    # rsync_proxy
    export rsync_proxy="${PROXY_HTTP}"
    export RSYNC_PROXY="${PROXY_HTTP}"

    # all_proxy
    export ALL_PROXY="${PROXY_SOCKS5}"
    export all_proxy="${PROXY_SOCKS5}"

    sh $HOME/dotfiles/ubuntu_wsl/git_proxy.sh
    if [ ! $1 ]; then
        ip_
    fi
}
proxy 1
unpro () {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset ftp_proxy
    unset FTP_PROXY
    unset rsync_proxy
    unset RSYNC_PROXY
    unset ALL_PROXY
    unset all_proxy
    ip_
}

# functions
git-config() {
    echo -n "Please input Git Username: "
    read username
    echo -n "Please input Git Email: "
    read email
    echo -n "Done!"
    git config --global user.name "${username}"
    git config --global user.email "${email}"
    git config --global alias.s status
    git config --global alias.d diff
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.last "log -1 HEAD"
    git config --global alias.cane "commit --amend --no-edit"
    git config --global alias.pr "pull --rebase"
    git config --global alias.lo "log --oneline -n 10"
    git config --global alias.a "add ."
    git config --global alias.cm "commit -m"
    git config --global alias.rh "reset --hard"
}

ssh_start() {
  sshd_status=$(service ssh status)
  if [[ $sshd_status = *"is not running"* ]]; then
    sudo service ssh --full-restart
  fi
}

set_max_user_watches() {
    if ! grep -qF "max_user_watches" /etc/sysctl.conf ; then
        echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    fi
    sudo sysctl -p >/dev/null 2>&1
    sudo sysctl --system >/dev/null 2>&1
}

expose_local(){
    sudo sysctl -w net.ipv4.conf.all.route_localnet=1 >/dev/null 2>&1
    sudo iptables -t nat -I PREROUTING -p tcp -j DNAT --to-destination 127.0.0.1
}

put_win_fonts() {
    # 将windows的字体放入ubuntu里
    sudo mkdir /usr/share/fonts/windows
    sudo cp -r /mnt/c/Windows/Fonts/*.ttf /usr/share/fonts/windows/
    fc-cache
}

bk() {
    cp ~/.zshrc ~/dotfiles/ubuntu_wsl/ubuntuwsl2.zshrc
    cp ~/.zsh_plugins.txt ~/dotfiles/ubuntu_wsl/zsh_plugins.txt
    cp ~/.config/nvim/init.vim ~/dotfiles/_rc/init.vim
    cp ~/.condarc ~/dotfiles/_rc/condarc
    cp ~/.zprofile ~/dotfiles/_rc/zprofile
}

v2() {
  declare q="$*";
  curl --user-agent curl "https://v2en.co/${q// /%20}";
}

v2-sh() {
  while echo -n "v2en> ";
  read -r input;
    [[ -n "$input" ]];
    do v2 "$input";
    done;
}

anki() {
    export ANKI_SYNC_DATA_DIR=~/anki-sync-server-docker-data
    docker run -it \
       --mount type=bind,source="$ANKI_SYNC_DATA_DIR",target=/app/data \
       -p 27701:27701 \
       --name anki-container \
       --rm \
       kuklinistvan/anki-sync-server:latest
}

rezsh() {
    source ~/.zshrc
    source ~/.zprofile
}

u-update() {
    sudo apt-get update && sudo apt-get -y upgrade
    brew upgrade --verbose
    antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
}

zsh_history_fix() {
    mv ~/.zsh_history ~/.zsh_history_bad
    strings ~/.zsh_history_bad > ~/.zsh_history
    fc -R ~/.zsh_history
    rm ~/.zsh_history_bad
}

cdlast() {
  cd -
  ls -lrth --color=auto | tail
  zle reset-prompt
}
zle -N cdlast
bindkey '^Q' cdlast

# alias
unalias grv
alias y=yarn
alias py="python3"
alias ipy="ipython"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vizsh="vim ~/.zshrc"

alias c.="code ."
alias e.="explorer.exe ."
alias cdtmp='cd `mktemp -d /tmp/artin-XXXXXX`'
alias ws="cd ~/0Workspace"
alias udtheme="cp -r ~/dotfiles/zsh-theme/. ~/.oh-my-zsh/custom/themes/ && rezsh"
alias cls=clear
alias rmrf="rm -rf"
alias vimrc="vim ~/.config/nvim/init.vim"

alias ping="nali-ping"
alias dig="nali-dig"
alias traceroute="nali-traceroute"
alias tracepath="nali-tracepath"
alias dig="nali-dig"
alias nslookup="nali-nslookup"

alias nali-update="sudo nali-update"
alias apt-update="sudo apt-get update && sudo apt-get -y upgrade"
alias ncdux="ncdu -X /home/artin/dotfiles/_rc/.ncduignorerc"
alias ct=cheat
alias vi=nvim
alias vim=nvim
alias lg=lazygit
alias pc4=proxychains4
alias top=htop
alias fd=fdfind
alias g=git
alias ls="exa"
alias l="exa -la"
alias sdocker="sudo service docker start"
alias gcid="git log | head -1 | awk '{print substr(\$2,1,7)}' | clip.exe"
alias wshutdown="wsl.exe --shutdown"

alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

# Created by mirror-config-china
export IOJS_ORG_MIRROR=https://npm.taobao.org/mirrors/iojs
export NODIST_IOJS_MIRROR=https://npm.taobao.org/mirrors/iojs
export NVM_IOJS_ORG_MIRROR=https://npm.taobao.org/mirrors/iojs
export NVMW_IOJS_ORG_MIRROR=https://npm.taobao.org/mirrors/iojs
export NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
export NODIST_NODE_MIRROR=https://npm.taobao.org/mirrors/node
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
export NVMW_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
export NVMW_NPM_MIRROR=https://npm.taobao.org/mirrors/npm
# End of mirror-config-china

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    export PATH="$HOME/.local/bin:$PATH"
fi


eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

export PATH="~/.npm-global/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

eval $(thefuck --alias --enable-experimental-instant-mode)

