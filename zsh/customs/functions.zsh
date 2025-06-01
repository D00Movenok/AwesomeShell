# System
system-update() {
    echo "Updating system packages..."
    sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt clean

    echo "Updating snap packages..."
    sudo snap refresh

    if command -v pipx >/dev/null 2>&1; then
        echo "Updating pipx packages..."
        pipx upgrade-all
    fi

    if command -v gup >/dev/null 2>&1; then
        echo "Updating go packages..."
        gup update
    fi
}
