#!/bin/bash -i

source $HOME/Ethereum-setup/private-network-setup/vars.env

geth=$HOME/Ethereum-setup/go-ethereum/build/bin/geth

for (( el=1; el<=$BN_COUNT; el++ )); do
    exec $geth --datadir $GETH_DATADIR/geth_datadir$el \
    --networkid $CHAIN_ID \
    --http --http.port $((GETH_HTTP_PORT + $el)) --http.api personal,eth,net,web3,engine,debug,txpool \
    --http.addr 0.0.0.0 --http.vhosts "*" --http.corsdomain "*" \
    --ws --ws.addr 0.0.0.0 --ws.port $((GETH_WS_PORT + $el)) --ws.origins "*" \
    --bootnodes $EL_BOOTNODE_ENODE \
    --port $((GETH_NETWORK_PORT + $el)) \
    --authrpc.jwtsecret $GETH_DATADIR/geth_datadir$el/geth/jwtsecret \
    --authrpc.addr localhost --authrpc.port $((GETH_AUTH_PORT + $el)) --authrpc.vhosts localhost \
    --syncmode "full" --gcmode "archive" >> ./geth_$el.log &
done
