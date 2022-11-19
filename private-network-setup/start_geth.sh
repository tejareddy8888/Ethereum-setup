#!/usr/bin/env bash

address=

geth --datadir /home/ubuntu/.ethereum/UZHETH/local-testnet \
--networkid 8888 \
--http --http.port 8545 --http.api personal,eth,net,web3,engine,debug,txpool  --http.addr 0.0.0.0 --http.vhosts "*" \
--ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.origins "*" \
--discovery.dns "" \
--port 30303 \
--mine --miner.etherbase=$address --miner.threads 1 --miner.gaslimit 1000000000 \
--authrpc.jwtsecret /home/ubuntu/.ethereum/UZHETH/local-testnet/geth/jwtsecret --authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost \
--unlock "$address" \
--password <(echo "test") --allow-insecure-unlock \
--syncmode "full" --gcmode "archive"
