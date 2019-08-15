#!/bin/bash

sudo sed -i 's|http://archive.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list
sudo sed -i 's|http://archive.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list.d/*.list

sudo sed -i 's|http://security.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list
sudo sed -i 's|http://security.ubuntu.com|https://mirrors.aliyun.com|g' /etc/apt/sources.list.d/*.list

sudo sed -i 's|http://ppa.launchpad.net|https://launchpad.proxy.noc.one|g' /etc/apt/sources.list
sudo sed -i 's|http://ppa.launchpad.net|https://launchpad.proxy.noc.one|g' /etc/apt/sources.list.d/*.list

sudo sed -i 's|http://downloads-distro.mongodb.org|https://mongodb-distro.mirror.noc.one|g' /etc/apt/sources.list.d/*.list


# Original: https://raw.githubusercontent.com/SukkaW/dotfiles/master/set-mirror.sh
