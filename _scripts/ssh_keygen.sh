if [ ! -f  ~/.ssh/id_rsa.pub ]; then
	ssh-keygen -t rsa -C "$1";
fi

if [ -f  ~/.ssh/id_rsa.pub ]; then
	cat ~/.ssh/id_rsa.pub;
fi
