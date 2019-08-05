#!/usr/bin bash

set -e
set -u
set -o pipefail

function githubLatestTag {
    finalUrl=$(curl "https://github.com/$1/releases/latest" -s -L -I -o /dev/null -w '%{url_effective}')
    echo "${finalUrl##*v}"
}


platform=''
machine=$(uname -m)

if [[ "$OSTYPE" == "linux"* ]]; then
  if [[ "$machine" == "arm"* || "$machine" == "aarch"* ]]; then
    platform='linux-arm'
  elif [[ "$machine" == *"86" ]]; then
    platform='linux32'
  elif [[ "$machine" == *"64" ]]; then
    platform='amd64'
  fi
fi

if test "x$platform" = "x"; then
  echo "no platform, please input platform: amd64"
  read -rp "> " platform
else
  echo "Detected platform: $platform"
fi

TAG=$(githubLatestTag sharkdp/bat)

echo "Downloading https://github.com/sharkdp/bat/releases/download/v${TAG}/bat_${TAG}_${platform}.deb"

curl -L "https://github.com/sharkdp/bat/releases/download/v${TAG}/bat_${TAG}_${platform}.deb" > bat.deb
sudo dpkg -i bat.deb
rm bat.deb
