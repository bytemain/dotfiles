#!/bin/bash

# 获取当前打开的文件夹路径
current_folder=$(pwd)
parent_folder=$(dirname $current_folder)

cd $parent_folder

# 向用户确认是否删除当前打开的文件夹
echo -n "Do you really want to delete the folder $current_folder? [y/N] "
read answer

# 如果用户输入了 y，则删除当前打开的文件夹
if [ "$answer" = "y" ]; then
    rm -r $current_folder
    echo "Folder $current_folder deleted."
else
    echo "Folder $current_folder not deleted."
fi
