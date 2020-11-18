#!/bin/bash

sukkaEnvVersion="WSL Ubuntu"
sukkaEnvRequired=$(echo -n "
* Using ubuntu on wsl
* Have your /etc/apt/sources.list modified
")

start() {
    clear
    winip=$(ip route | grep default | awk '{print $3}')
    export ALL_PROXY="http://${winip}:7890"
    export all_proxy="http://${winip}:7890"
    echo "Set Proxy: ${ALL_PROXY}"
    curl ip.gs
    echo ""
    echo "==========================================================="
    echo "   _____       _    _            ______                    "
    echo "  / ____|     | |  | |          |  ____|                   "
    echo " | (___  _   _| | _| | ____ _   | |__   ______   __        "
    echo "  \___ \| | | | |/ / |/ / _\` |  |  __| |  _ \\ \\ / /     "
    echo "  ____) | |_| |   <|   < (_| |  | |____| | | \\ V /        "
    echo " |_____/ \__,_|_|\\_\\_|\\_\\__,_|  |______|_| |_|\\_/     "
    echo "                                                           "
    echo "==========================================================="
    echo "                !! ATTENTION !!"
    echo "YOU ARE SETTING UP: Sukka Environment (${sukkaEnvVersion})"
    echo "Before start, please make sure you are:"
    echo "${sukkaEnvRequired}"
    echo "==========================================================="
    echo ""
    echo -n "* The setup will begin in 5 seconds... "
    sleep 5
    echo -n "Times up! Here we start!"
    echo ""

    cd $HOME
}

install-linux-packages() {
    echo "==========================================================="
    echo "* Install following packages:"
    echo "-----------------------------------------------------------"

    sudo apt-get update
    sudo apt-get install -y deborphan aptitude apt-file
    sudo apt-get install -y python3-dev python3-pip python3-setuptools
    sudo apt-get install -y build-essential libreadline-dev
    sudo apt-get install -y zsh curl wget git tree unzip ncdu tmux trash-cli
    sudo apt-get install -y festival festvox-kallpc16k
    sudo apt-get install -y neofetch screenfetch autojump
    sudo apt-get install -y lsof whois traceroute
    sudo apt-get install -y net-tools iputils-tracepath dnsutils
    sudo apt-get install -y netcat-openbsd fonts-noto fonts-noto-hinted fonts-noto-cjk
}

setup-omz() {
    echo "-----------------------------------------------------------"
    echo "* Installing ZSH Custom Plugins & Themes:"
    echo ""
    echo "  - zsh-autosuggestions"
    echo "  - zsh-syntax-highlighting"
    echo "-----------------------------------------------------------"

    cp ~/dotfiles/ubuntu_wsl/zsh_plugins.txt ~/.zsh_plugins.txt
    cp -r $HOME/dotfiles/zsh-theme/** ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/
}

install-linuxbrew(){
    brew install gcc git-quick-stats cheat
    brew install ripgrep bat exa git neovim fzf
    brew install getantibody/tap/antibody
    brew install ctop hub onefetch httpie
    brew install jesseduffield/lazygit/lazygit lazydocker
}

install-nvim(){
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    mkdir ~/.config/nvim/
    cp ~/dotfiles/ubuntu_wsl/init.vim ~/.config/nvim/
}

install-nodejs() {
    install-nvm() {
        echo "-----------------------------------------------------------"
        echo "* Installing NVM..."
        echo "-----------------------------------------------------------"

        curl -o- https://cdn.jsdelivr.net/gh/creationix/nvm/install.sh | bash

        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        echo "-----------------------------------------------------------"
        echo -n "* NVM Verision: "
        command -v nvm
    }

    install-node() {
        echo "-----------------------------------------------------------"
        echo "* Installing NodeJS..."
        echo "-----------------------------------------------------------"

        nvm install node
        nvm use node
        echo "-----------------------------------------------------------"
        echo -n "* NodeJS Version: "

        node -v
    }

    install-yarn() {
        yarn --version
    }

    yarn-global-add() {
        echo "-----------------------------------------------------------"
        echo "* Yarn Global Add those packages:"
        echo "-----------------------------------------------------------"
        npm install -g mirror-config-china --registry=http://registry.npm.taobao.org
        yarn config set registry https://registry.npm.taobao.org/
        yarn global add npm-check-updates nali-cli
        yarn global add http-server serve
        yarn global add what-is-x liyu wtf
        yarn global add typescript ts-node
    }


    echo "==========================================================="
    echo "              Setting up NodeJS Environment"

    install-nvm
    install-node
    install-yarn
    yarn-global-add
}

zshrc() {
    echo "==========================================================="
    echo "                  Import zshrc                   "
    echo "-----------------------------------------------------------"
    cat $HOME/dotfiles/ubuntu_wsl/zshrc > $HOME/.zshrc
}

upgrade-packages() {
    echo "==========================================================="
    echo "                      Upgrade packages                     "
    echo "-----------------------------------------------------------"

    sudo apt-get update && sudo apt-get upgrade -y
}

finish() {
    echo "==========================================================="
    echo "> Do not forget run those things:"
    echo ""
    echo "- chsh -s /usr/bin/zsh"
    echo "- git-config"
    echo "- set up neovim"
    echo "- u-update"
    echo "==========================================================="
}

start
install-linux-packages
setup-omz
install-nvim
install-nodejs
zshrc
upgrade-packages
finish
