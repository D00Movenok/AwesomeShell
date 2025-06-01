#!/bin/bash

script_dir=$(dirname $(readlink -f "$0"))

sudo apt install -y git-lfs
git lfs install

sudo apt install -y git-delta

rm ${HOME}/.gitconfig
ln -sv ${script_dir}/gitconfig ${HOME}/.gitconfig
