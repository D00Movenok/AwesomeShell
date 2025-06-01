#!/bin/bash

# apt
sudo apt install -y bat
sudo apt install -y flameshot
sudo apt install -y fzf
sudo apt install -y jq
sudo apt install -y ncdu
sudo apt install -y net-tools
sudo apt install -y plocate
sudo apt install -y ripgrep
sudo apt install -y tree
sudo apt install -y virtualbox
sudo apt install -y xclip

sudo apt install -y fonts-firacode

# snap
sudo apt install -y snapd
sudo service snapd start
sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap*

# Wait until snapd is seeded (ready for snap installs)
while ! snap debug seeding 2>&1 | grep "seeded" | grep -q "true"; do
    echo "Waiting for snapd to finish seeding..."
    sleep 2
done

# store only current and 1 previous revision of app
sudo snap set system refresh.retain=2

sudo snap install brave
sudo snap install code --classic
sudo snap install discord
sudo snap install keepassxc
sudo snap install obs-studio
sudo snap install remmina
sudo snap install telegram-desktop
sudo snap install thunderbird
