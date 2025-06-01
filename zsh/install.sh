#!/bin/bash

script_dir=$(dirname $(readlink -f "$0"))

sudo apt install -y zsh

# installing oh-my-zsh
export CHSH=no
export RUNZSH=no
export ZSH=${script_dir}/oh-my-zsh/
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm -rf ${HOME}/.oh-my-zsh
ln -sv ${script_dir}/oh-my-zsh ${HOME}/.oh-my-zsh

# install .zshrc
rm ${HOME}/.zshrc
ln -sv ${script_dir}/zshrc ${HOME}/.zshrc

# install p10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH}custom/themes/powerlevel10k"
rm ${HOME}/.p10k.zsh
ln -sv ${script_dir}/p10k.zsh ${HOME}/.p10k.zsh

# install zsh custom functions
rm ${HOME}/.zsh-customs
ln -sv ${script_dir}/customs ${HOME}/.zsh-customs

# Install nerd font for p10k
sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
sudo wget -P /usr/local/share/fonts https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH}/plugins/zsh-syntax-highlighting

# make zsh as a shell
sudo chsh -s $(which zsh)
