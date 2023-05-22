#!/usr/bin/bash

source $HOME/vars.env

DEBUG_LEVEL=debug
lighthouse=$HOME/.cargo/bin/lighthouse

# start beacon node 
data_dir=$DATADIR/node_1
network_port=9001
http_port=8001

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
    --http-address 0.0.0.0 \
    --http-port $http_port \
    --disable-packet-filter \
    --target-peers 0 \
    --terminal-total-difficulty-override=60000000 \
    --execution-endpoints http://127.0.0.1:8551/ \
    --execution-jwt $HOME/.ethereum/UZHETHPOS/geth/jwtsecret \
    --http-allow-sync-stalled