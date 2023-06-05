#!/usr/bin/bash

source $HOME/Ethereum-setup/private-network-setup/vars.env

DEBUG_LEVEL=info
lighthouse=/home/ubuntu/.cargo/bin/lighthouse

# start boot node
exec $lighthouse boot_node \
    --testnet-dir $TESTNET_DIR \
    --port $BOOTNODE_PORT \
    --listen-address 127.0.0.1 \
    --disable-packet-filter \
    --network-dir $DATADIR/bootnode &
sleep 1

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
    --staking \
    --enr-address 127.0.0.1 \
    --enr-udp-port $network_port \
    --enr-tcp-port $network_port \
    --port $network_port \
    --http-address 0.0.0.0 \
    --http-port $http_port \
    --disable-packet-filter \
    --target-peers 0 \
    --eth1 \
    --merge \
    --terminal-total-difficulty-override=60000000 \
    --eth1-endpoints http://127.0.0.1:8545/ \
    --execution-endpoints http://127.0.0.1:8551/ \
    --http-allow-sync-stalled \
    --execution-jwt /home/ubuntu/.ethereum/UZHETH/local-testnet/geth/jwtsecret &

# start validator client
beacon_nodes=http://localhost:8001

exec $lighthouse \
    --debug-level $DEBUG_LEVEL \
    vc \
    --datadir $data_dir \
    --testnet-dir $TESTNET_DIR \
    --init-slashing-protection \
    --beacon-nodes $beacon_nodes \
    $VC_ARGS

