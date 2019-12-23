#winip="127.0.0.1"
winip=$(cat /etc/resolv.conf | grep nameserver | awk '{ print $2 }')
proxy="http://${winip}:7890"
ssh_proxy="${winip}:7891"
git config --global http.https://github.com.proxy ${proxy}
if ! grep -qF "Host github.com" ~/.ssh/config ; then
    cat ~/dotfiles/_rc/ssh.proxy | sed "s/_ssh_proxy_/$ssh_proxy/g"  >> ~/.ssh/config
else
    lino=$(($(awk '/Host github.com/{print NR}'  ~/.ssh/config)+2))
    sed -i "${lino}c\    ProxyCommand nc -X 5 -x $ssh_proxy %h %p" ~/.ssh/config
fi


