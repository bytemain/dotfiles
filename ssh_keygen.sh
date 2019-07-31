if [ ! -f  ~/.ssh/id_rsa.pub ]; then
	ssh-keygen -t rsa -C "lengthmin@gmail.com";
fi

if [ -f  ~/.ssh/id_rsa.pub ]; then
	cat ~/.ssh/id_rsa.pub;
fi