#!/bin/bash

DISTRO=$(grep -e '^ID=' /etc/os-release | cut -d '=' -f2)

case $DISTRO in
    arch|manjaro)
        echo "Let's do it for: $DISTRO"
    *)
        echo "$DISTRO is not yet supported"
esac
