#!/bin/bash

sukkaEnvVersion="WSL Ubuntu"
sukkaEnvRequired=$(echo -n "
* Using ubuntu on wsl
* Have your /etc/apt/sources.list modified
")

start() {
    clear
    #winip="127.0.0.1"
    winip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
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
    sudo apt-get install -y python2.7 python3-dev python3-pip python3-setuptools
    sudo apt-get install -y build-essential libreadline-dev apt-file
    sudo apt-get install -y zsh curl wget git tree unzip ncdu tmux
    sudo apt-get install -y w3m lynx w3m-img zhcon
    sudo apt-get install -y festival festvox-kallpc16k 
    sudo apt-get install -y wamerican lua5.3 ctags
    sudo apt-get install -y neofetch screenfetch autojump
    sudo apt-get install -y android-tools-adb android-tools-fastboot
    sudo apt-get install -y lsof whois httpie
    sudo apt-get install -y net-tools iputils-tracepath dnsutils
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

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    cp -r ../zsh-theme/** ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/
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
        echo "-----------------------------------------------------------"
        npm install -g mirror-config-china --registry=http://registry.npm.taobao.org
        yarn global add npm-check-updates
        yarn global add http-server serve
        yarn global add fanyi liyu
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
    sudo apt-get update

    echo "-----------------------------------------------------------"
    echo "* Installing lazygit..."
    echo "-----------------------------------------------------------"

    sudo apt-get install lazygit -y
}
install-nvim() {
    echo "=========================================================="
    echo "                   Installing nvim                        "
    echo ""
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
    sudo apt-get install -y python-dev python-pip python3-dev python3-pip
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
    cd ..
}

other-package() {
    echo "==========================================================="
    echo "                Install other package                      "
    echo "-----------------------------------------------------------"

    sudo pip3 install thefuck
    sudo pip3 install cheat
}


micro-editor() {
    echo "==========================================================="
    echo "                Install micro_editor"
    echo "-----------------------------------------------------------"

    cd /usr/local/bin; curl https://getmic.ro | sudo bash
    cd $HOME
    sudo apt-get install -y xclip
    sudo apt-get install -y xsel
    sleep 3
    cd dotfiles
}

zshrc() {
    echo "==========================================================="
    echo "                  Import zshrc                   "
    echo "-----------------------------------------------------------"
    cd $HOME/dotfiles
    cat ./ubuntu_wsl/ubuntuwsl2.zshrc > $HOME/.zshrc
}

install-ctop() {
    sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64 -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop 
}

upgrade-packages() {
    echo "==========================================================="
    echo "                      Upgrade packages                     "
    echo "-----------------------------------------------------------"

    sudo apt-get update && sudo apt-get upgrade -y
}

finish() {
    echo "==========================================================="
    echo "> Sukka Enviroment Setup finished!"
    echo "> Do not forget run those things:"
    echo ""
    echo "- chsh -s /usr/bin/zsh"
    echo "- git-config"
	  echo "- sudo nali-update"
    echo "==========================================================="
}

start
install-linux-packages
setup-omz
install-nodejs
install-nvim
install-nali
install-ctop
other-package
lazygit
micro-editor
zshrc
upgrade-packages
finish
