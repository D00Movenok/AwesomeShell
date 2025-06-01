#!/bin/bash

# iterate all directories in current and run all install.sh
for dir in */; do
    if [ -d "$dir" ]; then
        if [ -f "$dir/install.sh" ]; then
            echo "Running install.sh in $dir"
            bash  "./$dir/install.sh"
        else
            echo "No install.sh found in $dir"
        fi
    fi
done

echo "Don't forget to reboot :)"
