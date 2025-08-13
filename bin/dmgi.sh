#!/bin/bash
 
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title dmgi
# @raycast.mode fullOutput
 
# Optional parameters:
# @raycast.icon 🍎
# @raycast.argument1 { "type": "text", "placeholder": "url" }
 
# Documentation:
# @raycast.author acdzh
# @raycast.authorURL https://github.com/acdzh
 
# forked from https://gist.github.com/aslamanver/fb6a4f432d1337c06d3022a53be7c82e#file-adb-url-install-sh
 
# BASEDIR=$(dirname "$0")
 
# 缓存文件夹
# CACHE_DIR="$HOME/Library/Caches/raycast-adbi"
CACHE_DIR="$HOME/Desktop/raycast-dmgi-cache"
echo "缓存目录: $CACHE_DIR"
 
# 不存在缓存文件夹, 创建
if [ ! -d "$CACHE_DIR" ]; then
  echo "缓存目录不存在，正在创建..."
  mkdir -p "$CACHE_DIR"
fi
 
# 如果命令是 clear, 清空缓存文件夹
if [ "$1" = "clear" ]; then
  echo "清理缓存目录..."
  rm -rf "$CACHE_DIR"
  echo "缓存目录清理完成"
  exit 0
fi
 
 
echo ""
 
 
# 获取 $URL
url="$1"
file_path=""
 
if [ -f "$url" ]; then
  echo "路径: $url"
  file_path="$url"
else
  echo "url: $url"
  echo "url md5: $(echo -n "$URL" | md5)"
  # 获取 URL 的 md5 的前六位作为文件名
  file_name="$(echo -n "$url" | md5 | cut -c -6).dmg"
  file_path="$CACHE_DIR/$file_name"
  echo "文件名: $file_name"
  echo "文件路径: $file_path"
  if [[ -f "$file_path" ]]; then
    echo "缓存目录下已存在该文件"
  else
    echo "开始下载..."
    if command -v aria2c >/dev/null 2>&1; then
      aria2c -x 16 -s 16 -c -k 1M --disk-cache=64M -d "$(dirname "$file_path")" -o "$(basename "$file_path")" "$url" --check-certificate=false -l "$file_path.wget.log"
    else
        wget -N "$url" --no-check-certificate -O "$file_path" -o "$file_path.wget.log" # --show-progress
    fi
    echo "下载完成"
  fi
fi
 
# 检查文件是否存在
if [ ! -f "$file_path" ]; then
  echo "文件不存在"
  exit 1
fi
 
 
echo ""
echo "正在挂载 $file_path"
volume_path=$(hdiutil attach "$file_path" | grep -Eo '/Volumes/(.*)')
if [ -z "$volume_path" ]; then
  echo "挂载失败！！"
  exit 1
fi
 
app_full_name=$(ls "$volume_path" | grep .app)
if [ -z "$app_full_name" ]; then
  echo "挂载路径下未找到 .app 文件"
  hdiutil detach "$(echo $volume_path | cut -d ' ' -f 1)"
  exit 1
fi
 
echo "在 $volume_path 下 找到 $app_full_name"
app_name="${app_full_name%.app}"
destination="/Applications/$app_name.app"
 
echo ""
echo "准备安装 $app_name 到 $destination"
 
# 检查应用是否正在运行
echo ""
echo "正在检查 $app_name 是否正在运行"
app_pid=$(pgrep -f "$app_name")
was_running=false
if [ -n "$app_pid" ]; then
    echo "应用 $app_name 正在运行，正在终止..."
    was_running=true
    pkill -9 -f "$app_name"
    echo "已杀死应用 $app_name"
fi
 
# 删除已存在的应用
echo ""
echo "正在删除已存在的 $app_name"
if [ -e "$destination" ]; then
    echo "应用 $app_name 已存在，正在删除..."
    rm -rf "$destination"
    echo "已删除应用 $app_name"
fi
 
# 拷贝应用程序到应用程序目录
echo ""
echo "正在拷贝 $app_name 到 $destination"
cp -R "$volume_path/$app_name.app" /Applications/
echo "拷贝完成"
 
# 卸载 DMG
echo ""
echo "正在卸载 DMG"
hdiutil detach "$volume_path"
echo "已卸载 $volume_path"
 
echo "$app_name 已成功安装"
 
# 重新启动应用程序
# if [ "$was_running" = true ]; then
    echo "启动 $app_name..."
    open "$destination"
    echo "$app_name 已成功启动"
# fi
 
 
 
# Example: ./dmgi.sh "https://someurl.com/some.dmg"