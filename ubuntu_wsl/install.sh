#!/bin/bash

sukkaEnvVersion="WSL Ubuntu"
sukkaEnvRequired=$(echo -n "
* Using ubuntu on wsl
* Have your /etc/apt/sources.list modified
")

start() {
    clear
    chmod +x ./ubuntu_set_mirror.sh
    sh ./ubuntu_set_mirror.sh
    #winip="127.0.0.1"
    winip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
    export ALL_PROXY="http://${winip}:7890"
    export all_proxy="http://${winip}:7890"
    echo -n "Set Proxy: ${ALL_PROXY}"

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
    echo ""
    echo "  - zsh"
    echo "  - curl"
    echo "  - git"
    echo "  - tree"
    echo "  - android-tools-adb"
    echo "  - android-tools-fastboot"
    echo "  - python2.7"
    echo "  - python3-dev"
    echo "  - python3-pip"
    echo "  - python3-setuptools"
    echo "  - whois"
    echo "  - axel"
    echo "  - iputils-tracepath"
    echo "  - dnsutils"
    echo "-----------------------------------------------------------"

    sudo apt-get update
    sudo apt-get install -y neovim
    sudo apt-get install -y zsh curl git tree android-tools-adb android-tools-fastboot python2.7 python3-dev python3-pip python3-setuptools whois axel iputils-tracepath dnsutils
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
    echo "  - sukka.zsh-theme"
    echo "  - zsh-proxy.zsh-plugin"
    echo "  - openload.zsh-plugin"
    echo "-----------------------------------------------------------"

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}


install-nodejs() {
    install-nvm() {
        echo "-----------------------------------------------------------"
        echo "* Installing NVM..."
        echo "-----------------------------------------------------------"

        curl -o- https://cdn.jsdelivr.net/gh/creationix/nvm@v0.34.0/install.sh | bash

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
        echo "-----------------------------------------------------------"
        echo "* Installing Yarn..."
        echo "-----------------------------------------------------------"

        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        sudo apt-get update && sudo apt-get install --no-install-recommends yarn

        echo "-----------------------------------------------------------"
        echo -n "* Yarn Version: "

        yarn --version
    }

    yarn-global-add() {
        echo "-----------------------------------------------------------"
        echo "* Yarn Global Add those packages:"
        echo ""
        echo "  - http-server"
        echo "  - serve"
        echo "  - hexo-cli"
        echo "  - openload-cli"
        echo "  - now"
        echo "-----------------------------------------------------------"

        yarn global add http-server serve hexo-cli openload-cli now
    }


    echo "==========================================================="
    echo "              Setting up NodeJS Environment"

    install-nvm
    install-node
    install-yarn
    yarn-global-add
}

lazygit() {
    echo "==========================================================="
    echo "                  Installing lazygit                       "
    echo ""
    echo "* Adding lazygit PPA..."
    echo "-----------------------------------------------------------"

    sudo add-apt-repository ppa:lazygit-team/release
    sudo sed -i "s|http://ppa.launchpad.net|https://launchpad.proxy.noc.one|g" /etc/apt/sources.list.d/*.list
    sudo apt-get update

    echo "-----------------------------------------------------------"
    echo "* Installing lazygit..."
    echo "-----------------------------------------------------------"

    sudo apt-get install lazygit -y
}

install-nali() {
    echo "==========================================================="
    echo "                   Installing Nali                         "
    echo ""
    echo "* Cloning SukkaW/Nali"
    echo "-----------------------------------------------------------"

    git clone https://github.com/sukkaw/nali.git --depth=10
    cd ./nali

    echo "-----------------------------------------------------------"
    echo "* Install Nali..."
    echo "-----------------------------------------------------------"
    ./configure
    make && sudo make install
    echo "-----------------------------------------------------------"
    echo "* Updating Nali IP Database..."
    echo "-----------------------------------------------------------"
    sudo nali-update
    cd ..
}

install-ctop() {
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop
}


thefuck() {
    echo "==========================================================="
    echo "                      Install thefuck                      "
    echo "-----------------------------------------------------------"

    sudo pip3 install thefuck
}


micro_editor() {
    echo "==========================================================="
    echo "                Install micro_editor"
    echo "-----------------------------------------------------------"

    cd /usr/local/bin; curl https://getmic.ro | sudo bash
    cd $HOME
    sudo apt-get install -y xclip
    sleep 3
    cd dotfiles
}

zshrc() {
    echo "==========================================================="
    echo "                  Import sukka env zshrc                   "
    echo "-----------------------------------------------------------"
	
    cat ./ubuntu_wsl/wsl-ubuntu.zshrc > $HOME/.zshrc
}

upgrade-packages() {
    echo "==========================================================="
    echo "                      Upgrade packages                     "
    echo "-----------------------------------------------------------"

    sudo apt-get update && sudo apt-get upgrade -y
    pip install --upgrade pip
    npm i -g npm
}

finish() {
    echo "==========================================================="
    echo "> Sukka Enviroment Setup finished!"
    echo "> Do not forget run those things:"
    echo ""
    echo "- chsh -s /usr/bin/zsh"
    echo "- git-config"
    echo "==========================================================="
}

start
install-linux-packages
setup-omz
install-nodejs
lazygit
install-nali
install-ctop
thefuck
micro_editor
zshrc
upgrade-packages
finish
