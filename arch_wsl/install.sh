#!/bin/bash

EnvVersion="Arch WSL"

start() {
    clear

    winip="127.0.0.1"
    #winip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
    export ALL_PROXY="http://${winip}:7890"
    export all_proxy="http://${winip}:7890"
    echo -n "Set Proxy: ${ALL_PROXY}"

    echo "==========================================================="
    echo "                !! ATTENTION !!"
    echo "YOU ARE SETTING UP:  (${EnvVersion})"
    echo "==========================================================="
    echo ""
    echo -n "* The setup will begin in 5 seconds... "

    sleep 5

    echo -n "Times up! Here we start!"
    echo ""

    cd $HOME
}

set-mirror() {
    sudo sed -i -e '1a\Server = http://mirrors.163.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
    sudo sed -i -e '1a\Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
    sudo sed -i -e '1a\[archlinuxcn]\Server = https://mirrors.cloud.tencent.com/archlinuxcn/$arch' /etc/pacman.conf
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman -Syy && pacman -S archlinuxcn-keyring
}

install-linux-packages() {
    echo "==========================================================="
    echo "* Install following packages:"
    echo ""
    echo "  - zsh"
    echo "  - curl"
    echo "  - git"
    echo "  - tree"
    echo "  - yay"
    echo "  - net-tools"
    echo "  - dnsutils"
    echo "  - inetutils"
    echo "  - iproute2"
    echo "  - base-devel"
    echo "  - httpie"
    echo "  - whois"
    echo "  - axel"
    echo "  - wslu"
    echo "  - ncdu"
    echo "  - glances"
    echo "  - iputils-tracepath"
    echo "-----------------------------------------------------------"

    sudo pacman -Syy yay
    yay --save --aururl https://aur.tuna.tsinghua.edu.cn
    yay

    sudo pacman -Syy base-devel
    sudo pacman -Syy zsh curl git tree whois 
    sudo pacman -Syy net-tools dnsutils inetutils iproute2 iputils-tracepath
    sudo pacman -Syy httpie

	yay -S hub wslu ncdu

    curl -L https://bit.ly/glances | /bin/bash
    sudo pip install cheat
}

setup-omz() {
    echo "==========================================================="
    echo "                      Shells Enviroment"
    echo "-----------------------------------------------------------"
    echo "* Installing Oh My ZSH and ZSH Custom Plugins & Themes:"
    echo ""
    echo "  - Oh My ZSH"
    echo "  - zsh-autosuggestions"
    echo "  - zsh-syntax-highlighting"
    echo "-----------------------------------------------------------"

    chsh -l
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


    echo "==========================================================="
    echo "                  Import env zshrc                   "
    echo "-----------------------------------------------------------"
	cd ~/dotfiles
    cat ./arch_wsl/wsl1.zshrc > $HOME/.zshrc

    source ~/.zshrc

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

        curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

        echo "-----------------------------------------------------------"
        echo -n "* Yarn Version: "

        yarn --version
    }

    yarn-global-add() {
        echo "-----------------------------------------------------------"
        echo "* Yarn Global Add those packages:"
        echo ""
        echo "  - npm-check-updates"
        echo "  - http-server"
        echo "  - serve"
        echo "  - hexo-cli"
        echo "  - now"
        echo "-----------------------------------------------------------"
		npm install -g mirror-config-china --registry=http://registry.npm.taobao.org
        yarn global add npm-check-updates http-server serve hexo-cli now 
    }


    echo "==========================================================="
    echo "              Setting up NodeJS Environment"

    install-nvm
    install-node
    install-yarn
    yarn-global-add
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


thefuck() {
    echo "==========================================================="
    echo "                      Install thefuck                      "
    echo "-----------------------------------------------------------"

    sudo pip install thefuck
}


micro_editor() {
    echo "==========================================================="
    echo "                Install micro_editor"
    echo "-----------------------------------------------------------"

    yay -S xclip
    yay -S xsel
    cd /usr/local/bin; curl https://getmic.ro | sudo bash
    cd $HOME

    sleep 3
    cd dotfiles
}

upgrade-packages() {
    echo "==========================================================="
    echo "                      Upgrade packages                     "
    echo "-----------------------------------------------------------"

    sudo pacman -Syy
    yay
    pip install --upgrade pip
    npm i -g npm
}

chmod() {
    sudo chmod u+s /bin/ping
    sudo chmod u+s /usr/sbin/traceroute
}

finish() {
    echo "==========================================================="
    echo "> Sukka Enviroment Setup finished!"
    echo "> Do not forget run those things:"
    echo ""
    echo "- chsh -s /usr/bin/zsh"
    echo "- ci-edit-update"
    echo "- git-config"
    echo "==========================================================="
}

start
set-mirror
install-linux-packages
setup-omz
install-nodejs
install-nali
thefuck
micro_editor
zshrc
chmod
upgrade-packages
finish
wslfetch
