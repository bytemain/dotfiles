#!/bin/bash

sukkaEnvVersion="VSCode Codespaces"

start() {
    clear
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
    sudo apt-get install -y python3-dev python3-pip python3-setuptools
    sudo apt-get install -y apt-file aptitude deborphan
    sudo apt-get install -y build-essential libreadline-dev
    sudo apt-get install -y zsh curl wget git tree unzip ncdu tmux trash-cli
    sudo apt-get install -y festival festvox-kallpc16k
    sudo apt-get install -y neofetch screenfetch autojump
    sudo apt-get install -y lsof whois traceroute
    sudo apt-get install -y net-tools iputils-tracepath dnsutils
    sudo apt-get install -y netcat-openbsd
}

setup-omz() {
    echo "==========================================================="
    echo "                      Shells Enviroment"
    echo "-----------------------------------------------------------"
    echo "* Installing Oh-My-Zsh..."
    echo "-----------------------------------------------------------"

    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

    echo "-----------------------------------------------------------"
    echo "* Installing ZSH Custom Plugins & Themes:"
    echo ""
    echo "  - zsh-autosuggestions"
    echo "  - zsh-syntax-highlighting"
    echo "-----------------------------------------------------------"

    cp ~/dotfiles/codespaces/zsh_plugins.txt ~/.zsh_plugins.txt
    cp -r ~/dotfiles/zsh-theme/. ~/.oh-my-zsh/custom/themes/
}

install-linuxbrew(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >>~/.zprofile
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

    brew install gcc git-quick-stats cheat
    brew install ripgrep bat exa neovim git fzf
    brew install getantibody/tap/antibody
    brew install ctop hub onefetch httpie
    brew install jesseduffield/lazygit/lazygit lazydocker
}

install-nvim(){
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    mkdir ~/.config/nvim/
    cp ~/dotfiles/codespaces/init.vim ~/.config/nvim/
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
    cd $HOME/dotfiles
    cat ./codespaces/zshrc > $HOME/.zshrc
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
install-linuxbrew
setup-omz
install-nvim
install-nodejs
zshrc
upgrade-packages
finish
