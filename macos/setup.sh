current_file=$(readlink -f "$0")
current_directory=$(dirname "$current_file")


mv ~/.zshrc ~/.zshrc.bak
ln -s $current_directory/zshrc ~/.zshrc
