#!/bin/bash

__file__=$(basename $0)
__dirname=$(dirname $0)

git config --global url."git@github.com:".insteadOf "https://github.com/"

# https://blog.gitbutler.com/why-is-git-autocorrect-too-fast-for-formula-one-drivers/
git config --global help.autocorrect prompt

# https://blog.gitbutler.com/how-git-core-devs-configure-git/
git config --global column.ui "auto"
git config --global branch.sort "-committerdate"
git config --global tag.sort "version:refname"
git config --global init.defaultBranch "main"
git config --global diff.algorithm "histogram"
git config --global diff.colorMoved "plain"
git config --global diff.mnemonicPrefix "true"
git config --global diff.renames "true"
git config --global push.default "simple"
git config --global push.autoSetupRemote "true"
git config --global push.followTags "true"
git config --global fetch.prune "true"
git config --global fetch.pruneTags "true"
git config --global fetch.all "true"
git config --global help.autocorrect "prompt"
git config --global commit.verbose "true"
git config --global rerere.enabled "true"
git config --global rerere.autoupdate "true"
git config --global rebase.autoSquash "true"
git config --global rebase.autoStash "true"
git config --global rebase.updateRefs "true"

source $__dirname/setup-gitconfig.generated.sh

cp $__dirname/../_rc/gitignore_global ~/.gitignore_global
