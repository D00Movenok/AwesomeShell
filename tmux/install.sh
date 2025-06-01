#!/bin/bash

script_dir=$(dirname $(readlink -f "$0"))

rm -rf ${HOME}/.tmux.conf
ln -sv ${script_dir}/tmux.conf ${HOME}/.tmux.conf
