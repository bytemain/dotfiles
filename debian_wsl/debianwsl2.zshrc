echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf > /dev/null 2>&1
sudo sysctl -p  > /dev/null 2>&1
sudo sysctl --system > /dev/null 2>&1

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export PATH="/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:$PATH"
export PATH="/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:$PATH"
export PATH="/mnt/c/Program Files/Microsoft VS Code/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export CHEAT_USER_DIR="$HOME/dotfiles/_cheat"
export EDITOR=micro
export UPDATE_ZSH_DAYS=13
export FZF_BASE=/usr/bin

ZSH_THEME="sukka"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_DISABLE_COMPFIX=true

plugins=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    git
    history
    last-working-dir
    autojump
    sudo
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


# User configuration
setopt no_nomatch


# Proxy configuration
#winip="127.0.0.1"
winip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }' | cut -d/ -f1)
wslip=$(ip addr show eth0 | grep 'inet\b' | awk '{print $2}' | cut -d/ -f1)

PROXY_HTTP="http://${winip}:7890"
PROXY_SOCKS5="socks5://${winip}:7891"

alias winip_="echo ${winip}"
alias wslip_="echo ${wslip}"

ip_() {
	curl https://ip.cn/$1
    http --follow -b https://api.ip.sb/geoip/$1
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

	sh /home/artin/dotfiles/debian_wsl/git_proxy.sh
	ip_
}

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
}

mc-update() {
	echo -n "Please input download url!"
	read _url
	curl -L "${_url}" > micro.tar.gz
	mkdir microd
	tar -xvzf micro.tar.gz -C microd --strip-components 1
	mv microd/micro /usr/local/bin/micro  
	rm micro.tar.gz 
	rm -rf microd
}

ssh_start() {
  sshd_status=$(service ssh status)
  if [[ $sshd_status = *"is not running"* ]]; then
  sudo service ssh --full-restart
  fi
}

bk() {
    cp ~/.zshrc ~/dotfiles/debian_wsl/debianwsl2.zshrc
    cp ~/.SpaceVim.d/init.toml ~/dotfiles/_rc/Space.Vim.toml
    cp ~/.config/micro/settings.json ~/dotfiles/_rc/micro.settings.json
}

install-bat() {

    
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

cdlast() {
  cd -
  ls -lrth --color=auto | tail
  zle reset-prompt
}
zle -N cdlast
bindkey '^Q' cdlast

alias ohmyzsh="micro ~/.oh-my-zsh"
alias vizsh="micro ~/.zshrc"
alias rezsh="source ~/.zshrc"
alias rezshc="source ~/.zshrc && cls"
alias c.="code ."
alias e.="explorer.exe ."
alias cdtmp='cd `mktemp -d /tmp/artin-XXXXXX`'
alias ws="cd ~/0Workspace"
alias udtheme="cp -r ~/dotfiles/zsh-theme/. ~/.oh-my-zsh/custom/themes/ && source ~/.zshrc"
alias cls=clear
alias rmrf="rm -rf"

alias gitcm="git commit -m"
alias gitp="git push"
alias gita="git add -a"
alias gitall="git add ."

alias ping="nali-ping"
alias dig="nali-dig"
alias traceroute="nali-traceroute"
alias tracepath="nali-tracepath"
alias dig="nali-dig"
alias nslookup="nali-nslookup"
alias nali-update="sudo nali-update"

alias ncdux="ncdu -X /home/artin/dotfiles/_rc/.ncduignorerc"
alias ct=cheat
alias mc=micro
alias vi=nvim
alias vim=nvim
alias lg=lazygit
alias pc4=proxychains4
alias top=htop
alias fd=fdfind

alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'
alias -s py=micro
alias -s html=micro

alias gcid="git log | head -1 | awk '{print substr(\$2,1,7)}' | clip.exe"

eval $(thefuck --alias)

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
