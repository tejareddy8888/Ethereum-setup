#!/usr/bin/bash

source $HOME/Ethereum-setup/private-network-setup/vars.env

DEBUG_LEVEL=debug
lighthouse=$HOME/.cargo/bin/lighthouse

# start beacon node 

for (( bn=1; bn<=$BN_COUNT; bn++ )); do
    exec $lighthouse \
        --debug-level $DEBUG_LEVEL \
        bn \
        --subscribe-all-subnets \
        --datadir $DATADIR/node_$bn \
        --testnet-dir $TESTNET_DIR \
        --enable-private-discovery \
        --disable-peer-scoring \
        --staking \
        --enr-address 127.0.0.1 \
        --enr-udp-port  $((LIGHTHOUSE_NETWORK_PORT + $bn)) \
        --enr-tcp-port  $((LIGHTHOUSE_NETWORK_PORT + $bn)) \
        --port $((LIGHTHOUSE_NETWORK_PORT + $bn)) \
        --http-address 0.0.0.0 \
        --http-port $((LIGHTHOUSE_HTTP_PORT + $bn)) \
        --disable-packet-filter \
        --target-peers $((BN_COUNT - 1)) \
        --execution-endpoints http://127.0.0.1:$((GETH_AUTH_PORT + $bn)) \
        --execution-jwt $GETH_DATADIR/geth_datadir$el/geth/jwtsecret >> ./lighthouse_beacon_$bn.log &
done