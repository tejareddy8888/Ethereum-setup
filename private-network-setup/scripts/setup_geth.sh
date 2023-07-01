#!/bin/bash -i

geth_path="$HOME/Ethereum-setup/go-ethereum"
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH

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
    
    make all
    echo "alias geth='$SCRIPTPATH/go-ethereum/build/bin/geth'" >> $shell_profile
    echo "alias el_bootnode='$SCRIPTPATH/go-ethereum/build/bin/bootnode'" >> $shell_profile

    source $shell_profile
  fi
else
  echo "$geth_path does not exist, please run the 'make fetch'."
fi


echo "************ SUCCESSFUL GETH SETUP ************"
