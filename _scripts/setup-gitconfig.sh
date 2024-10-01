#!/bin/bash

__file__=$(basename $0)
__dirname = $(dirname $0)

git config --global url.ssh://git@github.com/.insteadOf https://github.com/

source $__dirname/setup-gitconfig.generated.sh

cp $__dirname/../_rc/gitignore_global ~/.gitignore_global
