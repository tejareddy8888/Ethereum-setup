#!/usr/bin/bash

source $HOME/Ethereum-setup/private-network-setup/vars.env

lighthouse=$HOME/.cargo/bin/lighthouse


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
       echo "  EXECUTION-ENDPOINT     Value for --execution-endpoint"
       echo "  EXECUTION-JWT     Value for --execution-jwt"
       exit
       ;;
  esac
done

# Get positional arguments
data_dir=${@:$OPTIND+0:1}
network_port=${@:$OPTIND+1:1}
http_port=${@:$OPTIND+2:1}
execution_endpoint=${@:$OPTIND+3:1}
execution_jwt=${@:$OPTIND+4:1}


# start beacon node 
exec $lighthouse \
    --debug-level $DEBUG_LEVEL \
    bn \
    --subscribe-all-subnets \
    --datadir $data_dir \
    --testnet-dir $TESTNET_DIR \
    --enable-private-discovery \
    --disable-peer-scoring \
    --staking \
    --enr-address 127.0.0.1 \
    --enr-udp-port $network_port \
    --enr-tcp-port $network_port \
    --port $network_port \
    --http-port $http_port \
    --http-address 0.0.0.0 \
    --disable-packet-filter \
    --target-peers $((BN_COUNT - 1)) \
    --execution-endpoint $execution_endpoint \
    --execution-jwt $execution_jwt &
