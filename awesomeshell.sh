#!/bin/sh

CONFIGURE_ZSH=${CONFIGURE_ZSH:-no}
CONFIGURE_VIM=${CONFIGURE_VIM:-no}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

install_dependencies() {
    echo "Checking dependencies..."

    packages=""

    if ! command_exists curl; then
        echo "CURL is not installed!"
        packages="$packages curl"
        req_install=1
    fi

    if ! command_exists git; then
        echo "GIT is not installed!"
        packages="$packages git"
        req_install=1
    fi

    if [ "$CONFIGURE_VIM" = "yes" ]; then
        packages="$packages vim-gtk"
        req_install=1
    fi

    if [ "$CONFIGURE_VIM" = "yes" ]; then
        packages="$packages exuberant-ctags"
        req_install=1
    fi

    if ! command_exists zsh && [ "$CONFIGURE_ZSH" = "yes" ]; then
        echo "ZSH is not installed!"
        packages="$packages zsh"
        req_install=1
    fi

    if ! command_exists fzf && [ "$CONFIGURE_ZSH" = "yes" ]; then
        echo "FZF is not installed!"
        packages="$packages fzf"
        req_install=1
    fi

    if ! command_exists batcat && [ "$CONFIGURE_ZSH" = "yes" ]; then
        echo "BAT is not installed!"
        packages="$packages bat"
        req_install=1
    fi

    if ! command_exists tree && [ "$CONFIGURE_ZSH" = "yes" ]; then
        packages="$packages tree"
        req_install=1
    fi

    if ! command_exists tmux && [ "$CONFIGURE_TMUX" = "yes" ]; then
        echo "TMUX is not installed!"
        packages="$packages tmux"
        req_install=1
    fi

    if ! command_exists powerline && [ "$CONFIGURE_TMUX" = "yes" ]; then
        echo "POWERLINE is not installed!"
        packages="$packages powerline"
        req_install=1
    fi

    if [ -n "$req_install" ]; then
        echo "Installing dependencies..."
        sudo apt update || {
            echo "Can't update"
            exit 1
        }
        sudo apt install -y $packages || {
            echo "Can't install dependencies"
            exit 1
        }
    fi
}

zsh_as_default() {
  if ! command_exists chsh; then
    echo "chsh does not exist, change shell manually"
    return
  fi

  # Check if we're running on Termux
  case "$PREFIX" in
    *com.termux*) termux=true; zsh=zsh ;;
    *) termux=false ;;
  esac

  if [ "$termux" != true ]; then
    # Test for the right location of the "shells" file
    if [ -f /etc/shells ]; then
      shells_file=/etc/shells
    elif [ -f /usr/share/defaults/etc/shells ]; then # Solus OS
      shells_file=/usr/share/defaults/etc/shells
    else
      echo "could not find /etc/shells file. Change your default shell manually."
      return
    fi

    # Get the path to the right zsh binary
    # 1. Use the most preceding one based on $PATH, then check that it's in the shells file
    # 2. If that fails, get a zsh path from the shells file, then check it actually exists
    if ! zsh=$(command -v zsh) || ! grep -qx "$zsh" "$shells_file"; then
      if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -1) || [ ! -f "$zsh" ]; then
        echo "no zsh binary found or not present in '$shells_file'"
        echo "change your default shell manually."
        return
      fi
    fi
  fi

  # We're going to change the default shell, so back up the current one
  if [ -n "$SHELL" ]; then
    echo "$SHELL" > ~/.shell.pre-oh-my-zsh
  else
    grep "^$USERNAME:" /etc/passwd | awk -F: '{print $7}' > ~/.shell.pre-oh-my-zsh
  fi

  # Actually change the default shell to zsh
  if ! chsh -s "$zsh"; then
    echo "chsh command unsuccessful. Change your default shell manually."
  else
    export SHELL="$zsh"
    echo "Shell successfully changed to '$zsh'."
  fi
}


configure_zsh() {
    echo "Configuring ZSH:"

    echo "Installing ohmyzsh..."
    # CHSH=no to interactivity (not echo beacuse install.sh doesnt change it without tty)
    CHSH=no RUNZSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
            echo "Can't install ohmyzsh"
            exit 1
        }
    zsh_as_default
    curl -fLo $HOME/.zshrc https://raw.githubusercontent.com/D00Movenok/AwesomeShell/main/dotfiles/.zshrc

    echo "Installing  ohmyzsh plugins..."
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || {
            echo "Can't clone zsh-autosuggestions"
            exit 1
        }
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || {
            echo "Can't clone zsh-syntax-highlighting"
            exit 1
        }
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate || {
            echo "Can't clone autoupdate-oh-my-zsh-plugins"
            exit 1
        }

    echo "Installing theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k || {
            echo "Can't clone powerlevel10k"
            exit 1
        }
    curl -fLo $HOME/.p10k.zsh https://raw.githubusercontent.com/D00Movenok/AwesomeShell/main/dotfiles/.p10k.zsh

    echo "ZSH configured successfully!"

    exec zsh -l
}

configure_vim() {
    echo "Configuring VIM:"

    echo "Installing vim-plug..."
    curl -fLo $HOME/.vim/autoload/plug.vim \
        --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim  || {
            echo "Can't curl vim-plug"
            exit 1
        }
    curl -fLo $HOME/.vimrc https://raw.githubusercontent.com/D00Movenok/AwesomeShell/main/dotfiles/.vimrc
    # dirty trick to skip "Press ENTER blah-blah"
    echo "" | vim +PlugInstall +qall

    echo "VIM configured successfully!"
}

configure_tmux() {
    echo "Configuring TMUX:"

    curl -fLo $HOME/.tmux.conf https://raw.githubusercontent.com/D00Movenok/AwesomeShell/main/dotfiles/.tmux.conf

    echo "TMUX configured successfully!"
}

main() {
    while [ $# -gt 0 ]; do
        case $1 in
            -z)
                CONFIGURE_ZSH=yes
            ;;
            -v)
                CONFIGURE_VIM=yes
            ;;
            -t)
                CONFIGURE_TMUX=yes
            ;;
        esac
        shift
    done

    if [ "$CONFIGURE_ZSH" = "no" ] && [ "$CONFIGURE_VIM" = "no" ] && [ "$CONFIGURE_TMUX" = "no" ]; then
        echo "Default value: vim and zsh will be configured..."
        CONFIGURE_ZSH=yes
        CONFIGURE_VIM=yes
        CONFIGURE_TMUX=yes
    fi

    install_dependencies

    if [ "$CONFIGURE_VIM" = "yes" ]; then
        configure_vim
    fi

    if [ "$CONFIGURE_ZSH" = "yes" ]; then
        configure_zsh
    fi

    if [ "$CONFIGURE_TMUX" = "yes" ]; then
        configure_tmux
    fi
}

main "$@"
