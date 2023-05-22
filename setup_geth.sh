#!/bin/bash

geth_path="./go-ethereum"

echo "************ STARTING GETH SETUP ************"

if [ -d "$geth_path" ]; then
  if [ -z "$(ls -A "$geth_path")" ]; then
    echo "$geth_path is empty, please run the 'make fetch'."
  else
    if [ -n "$($SHELL -c 'echo $ZSH_VERSION')" ]; then
        shell_profile="$HOME/.zshrc"
    elif [ -n "$($SHELL -c 'echo $BASH_VERSION')" ]; then
        shell_profile="$HOME/.bashrc"
    fi
    echo "$shell_profile"
    source $shell_profile
    cd go-ethereum
    make geth
    echo "create geth alias"
  fi
else
  echo "$geth_path does not exist, please run the 'make fetch'."
fi


echo "************ SUCCESSFUL GETH SETUP ************"
