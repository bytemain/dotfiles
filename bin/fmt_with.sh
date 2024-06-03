#!/bin/bash

# 确保提供了一个包含文件路径的文件名作为参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/file_with_paths"
    exit 1
fi

# 读取文件中的每一行（每个路径）
while IFS= read -r file_path; do
    # 检查路径是否存在且是一个文件
    if [ -f "$file_path" ]; then
        echo "Formatting file: $file_path"
        # 执行dprint fmt命令
        dprint fmt "$file_path"
    else
        echo "Warning: Skipped, '$file_path' does not exist or is not a file."
    fi
done < "$1"
