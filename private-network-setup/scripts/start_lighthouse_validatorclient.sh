#!/usr/bin/bash

source /home/ubuntu/vars.env

DEBUG_LEVEL=debug
lighthouse=/home/ubuntu/.cargo/bin/lighthouse
data_dir=$DATADIR/node_1

# start validator client
beacon_nodes=http://localhost:8001

exec $lighthouse \
    --debug-level $DEBUG_LEVEL \
    vc \
    --datadir $data_dir \
    --testnet-dir $TESTNET_DIR \
    --init-slashing-protection \
    --beacon-nodes $beacon_nodes \
    --suggested-fee-recipient $VC_FEE_RECEIPENT
    $VC_ARGS

