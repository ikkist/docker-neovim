#!/bin/sh

cmd() {
    # $1: name
    # $2: value
    # $3: output file
    echo "$1=$2 >> $3"
    echo "$1=$2" >> $3
}

rm -f .env
cmd UID $(id -u) .env
cmd GID $(id -g) .env
