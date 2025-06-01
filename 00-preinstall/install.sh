#!/bin/bash

script_dir=$(dirname $(readlink -f "$0"))

sudo apt update

echo "Preparing"
for script in $script_dir/*.sh; do
    [ -f "$script" ] && [ $(basename "$script") != "install.sh" ] && echo "Running $script" && bash "$script"
done
