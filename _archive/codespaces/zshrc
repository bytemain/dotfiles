export ZSH="$HOME/.oh-my-zsh"
export EDITOR=vim
export CHEAT_USER_DIR="$HOME/dotfiles/cheat"
export CHEAT_CONFIG_PATH="~/dotfiles/cheat/conf.yml"
export NVM_DIR="$HOME/.nvm"
export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/llvm/lib -Wl,-rpath,/home/linuxbrew/.linuxbrew/opt/llvm/lib,-L/home/linuxbrew/.linuxbrew/opt/python@3.8/lib"
ZSH_THEME="sukka"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
ZSH_DISABLE_COMPFIX=true
DISABLE_CORRECTION=true
plugins=(
    git
    history
    sudo
    z
    poetry
    safe-paste
)
if type brew &>/dev/null; then
      FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# User configuration
source $ZSH/oh-my-zsh.sh
source ~/.zsh_plugins.sh

# alias
unalias grv
alias l="exa -la"
alias ls="exa"
alias la="exa -lah"
alias b=brew
alias vi="vim"
alias vim="nvim"
alias y=yarn
alias py="python3"
alias ipy="ipython"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vizsh="vim ~/.zshrc"
alias vish="vim ~/.config/starship.toml"
alias tli="train-list"
alias trm="trash-rm"
alias tre="trash-restore"
alias tem="trash-empty"
alias tp="trash-put"
alias c=code
alias ci="code-insiders"
alias e="explorer.exe"
alias c.="code-insiders ."
alias e.="explorer.exe ."
alias cdtmp='cd `mktemp -d /tmp/artin-XXXXXX`'
alias ws="cd ~/0Workspace"
alias udtheme="cp -r ~/dotfiles/zsh-theme/. ~/.oh-my-zsh/custom/themes/"
alias cls=clear
alias rmrf="rm -rf"
alias srmrf="sudo rm -rf"
alias vimrc="vim ~/.config/nvim/init.vim"
alias ping="nali-ping"
alias dig="nali-dig"
alias lzd=lazydocker
alias dco="docker-compose"
alias traceroute="nali-traceroute"
alias tracepath="nali-tracepath"
alias nslookup="nali-nslookup"
alias apt-update="sudo apt-get update && sudo apt-get -y upgrade"
alias ncdux="ncdu -X ~/dotfiles/_rc/.ncduignorerc"
alias ct=cheat
alias lg=lazygit
alias pc4=proxychains4
alias top=htop
alias fd=fdfind
alias g=git

alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

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
export PATH="/home/linuxbrew/.linuxbrew/opt/python@3.8/bin:$PATH"
export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/python@3.8/lib/pkgconfig"
export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/python@3.8/include"

# using *
setopt no_nomatch

ip_() {
    https --follow -b https://api.ip.sb/geoip/$1
}

git-config() {
    echo -n "Please input Git Username: "
    read username
    echo -n "Please input Git Email: "
    read email
    echo -n "Done!"
    git config --global user.name "${username}"
    git config --global user.email "${email}"
    git config --global alias.s status
    git config --global alias.sb "status -sb"
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
    git config --global alias.f "fetch"
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


put_win_fonts() {
    # 将windows的字体放入ubuntu里
    sudo mkdir /usr/share/fonts/windows
    sudo cp -r /mnt/c/Windows/Fonts/*.ttf /usr/share/fonts/windows/
    fc-cache
}

bk() {
    cp ~/.zshrc ~/dotfiles/codespaces/zshrc
    cp ~/.zsh_plugins.txt ~/dotfiles/codespaces/zsh_plugins.txt
    cp ~/.config/nvim/init.vim ~/dotfiles/codespaces/init.vim
    cp ~/.condarc ~/dotfiles/codespaces/condarc
}

u-clean() {
    sudo apt-get clean
    sudo apt-get autoclean
    sudo apt-get autoremove
    deborphan | xargs sudo apt-get purge
    deborphan
    sudo aptitude search ?obsolete
    sudo aptitude purge ~o
}

u-update() {
    sudo apt-get update && sudo apt-get -y upgrade
    brew upgrade --verbose
    antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
    nali update -y
    nvm upgrade
    git -C ~/dotfiles/cheat/community/ pull
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
