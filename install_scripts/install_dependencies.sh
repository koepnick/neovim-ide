#!/bin/bash

if [[ ! -f /etc/os-release ]]; then 
    printf "No /etc/os-release file\nExiting\n"
    exit 1
fi
DISTRO=$(grep -e '^ID=' /etc/os-release | cut -d '=' -f2)

arch_install() {
    echo "Let's do it for: Arch"
}

case $DISTRO in
    arch|manjaro)
        arch_install;;
    *)
        echo "$DISTRO is not yet supported";;
esac
