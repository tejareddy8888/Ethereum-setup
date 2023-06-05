#!/bin/bash

lighthouse_path="./lighthouse"

echo "************ STARTING LIGHTHOUSE SETUP ************"


if [ -d "$lighthouse_path" ]; then
  if [ -z "$(ls -A "$lighthouse_path")" ]; then
    echo "$lighthouse_path is empty, please run the 'make fetch'."
  else
    sudo apt install -y git gcc g++ make cmake pkg-config llvm-dev libclang-dev clang protobuf-compiler

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    cd $lighthouse_path
    source "$HOME/.cargo/env"
    make
    make install-lcli
  fi
else
  echo "$lighthouse_path does not exist, please run the 'make fetch'."
fi

echo "************ SUCCESSFUL LIGHTHOUSE SETUP ************"
