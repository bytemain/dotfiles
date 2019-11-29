#winip="127.0.0.1"
winip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
proxy="http://${winip}:7890"
ssh_proxy="${winip}:7891"
git config --global http.https://github.com.proxy ${proxy}
sudo apt-get install -y netcat-openbsd > /dev/null 2>&1
cat ~/dotfiles/_rc/ssh.proxy | sed "s/_ssh_proxy_/$ssh_proxy/g"  > ~/.ssh/config 
