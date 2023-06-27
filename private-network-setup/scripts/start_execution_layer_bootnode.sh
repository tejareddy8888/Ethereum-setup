#!/usr/bin/env bash

#
# Starts a bootnode from the generated enr.
#

set -Eeuo pipefail
source $HOME/Ethereum-setup/private-network-setup/vars.env

exec $EL_BOOTNODE_BINARY --nodekey $EL_BOOTNODE_PRIV_KEY
