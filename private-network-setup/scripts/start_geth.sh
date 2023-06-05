#!/bin/bash -i

source $HOME/Ethereum-setup/private-network-setup/var.env

address=0x35b855e98fd56e5055e39ae6feca999b8dd9235f
geth=$HOME/Ethereum-setup/go-ethereum/build/bin/geth

echo $EL_BOOTNODE_ENODE

exec $geth --datadir $GETH_DATADIR \
--networkid $CHAIN_ID \
--http --http.port 8545 --http.api personal,eth,net,web3,engine,debug,txpool \
--http.addr 0.0.0.0 --http.vhosts "*" --http.corsdomain "*" \
--ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.origins "*" \
--bootnodes $EL_BOOTNODE_ENODE \
--port 30303 \
--authrpc.jwtsecret $GETH_DATADIR/geth/jwtsecret \
--authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost \
--syncmode "full" --gcmode "archive"
