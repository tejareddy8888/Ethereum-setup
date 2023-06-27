#!/usr/bin/bash

source $HOME/Ethereum-setup/private-network-setup/vars.env

lighthouse=/home/ubuntu/.cargo/bin/lighthouse

# start validator clients
for (( vc=1; vc<=$VC_COUNT; vc++ )); do
    exec $lighthouse \
        --debug-level $DEBUG_LEVEL \
        vc \
        --datadir $DATADIR/node_$vc \
        --testnet-dir $TESTNET_DIR \
        --init-slashing-protection \
        --beacon-nodes http://localhost:$((LIGHTHOUSE_HTTP_PORT + $vc)) \
        --suggested-fee-recipient $VC_FEE_RECEIPENT \
        $VC_ARGS  >> ./lighthouse_vc_$vc.log
done
