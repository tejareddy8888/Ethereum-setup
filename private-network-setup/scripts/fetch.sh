#!/bin/bash


function submodules() {
    git submodule status --recursive | sed 's/^.[^ ]* \([^ ]*\).*$/\1/'
}

function checksubmodules() {
    for f in $(submodules); do
        if [ -z "$(ls $f)" ]; then 
            echo $f;
            git submodule update --init --recursive --remote $f
        fi
    done
}

echo "Retrieving Submodules"
checksubmodules
git submodule foreach --recursive 'git fetch --tags'

cd ./go-ethereum

# Checkout to geth version v1.12.0
git checkout e501b3b05db8e169f67dc78b7b59bc352b3c638d


cd ../lighthouse

# Checkout to lighthouse version v4.2.0
git checkout c547a11b0da48db6fdd03bca2c6ce2448bbcc3a9