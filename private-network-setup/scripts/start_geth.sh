#!/bin/bash -i

source $HOME/Ethereum-setup/private-network-setup/vars.env
geth=$HOME/Ethereum-setup/go-ethereum/build/bin/geth

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
       echo "  NETWORK-PORT  Value for --port"
       echo "  HTTP-PORT     Value for --http.port"
       echo "  AUTH-PORT     Value for --authrpc.port"
       echo "  WS-PORT       Value for --ws.port"
       exit
       ;;
  esac
done

# Get positional arguments
data_dir=${@:$OPTIND+0:1}
network_port=${@:$OPTIND+1:1}
http_port=${@:$OPTIND+2:1}
auth_port=${@:$OPTIND+3:1}
ws_port=${@:$OPTIND+4:1}


exec $geth --datadir $data_dir \
--networkid $CHAIN_ID \
--http --http.port $http_port --http.api personal,eth,net,web3,engine,debug,txpool \
--http.addr 0.0.0.0 --http.vhosts "*" --http.corsdomain "*" \
--ws --ws.addr 0.0.0.0 --ws.port $ws_port --ws.origins "*" \
--bootnodes $EL_BOOTNODE_ENODE \
--port $network_port \
--authrpc.jwtsecret $data_dir/geth/jwtsecret \
--authrpc.addr localhost --authrpc.port $auth_port --authrpc.vhosts localhost \
--syncmode "full" --gcmode "archive"

