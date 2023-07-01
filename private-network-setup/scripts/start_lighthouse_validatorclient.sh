#!/usr/bin/bash

source $HOME/Ethereum-setup/private-network-setup/vars.env

lighthouse=/home/ubuntu/.cargo/bin/lighthouse

# Get options
while getopts "d:h" flag; do
  case "${flag}" in
    d) DEBUG_LEVEL=${OPTARG};;
    h)
       echo "Start a geth node"
       echo
       echo "usage: $0 <Options> <DATADIR> <NETWORK-PORT> <HTTP-PORT>"
       echo
       echo "Options:"
       echo "   -h: this help"
       echo
       echo "Positional arguments:"
       echo "  DATADIR       Value for --datadir parameter"
       echo "  Beacon-Endpoint     Value for --http.port"
       exit
       ;;
  esac
done

# Get positional arguments
data_dir=${@:$OPTIND+0:1}
beacon_endpoint=${@:$OPTIND+2:1}

# start validator clients
for (( vc=1; vc<=$VC_COUNT; vc++ )); do
    exec $lighthouse \
        --debug-level $DEBUG_LEVEL \
        vc \
        --datadir $data_dir \
        --testnet-dir $TESTNET_DIR \
        --init-slashing-protection \
        --beacon-nodes $beacon_endpoint \
        --suggested-fee-recipient $VC_FEE_RECEIPENT \
        $VC_ARGS 
done
