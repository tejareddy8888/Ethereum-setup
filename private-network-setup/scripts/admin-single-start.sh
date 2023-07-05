#!/bin/bash -i

source $HOME/Ethereum-setup/private-network-setup/vars.env

mkdir -p $LOG_DIR
for (( el=1; el<=$BN_COUNT; el++ )); do
    touch $LOG_DIR/geth_$el.log
done
for (( bn=1; bn<=$BN_COUNT; bn++ )); do
    touch $LOG_DIR/beacon_node_$bn.log
done
for (( vc=1; vc<=$VC_COUNT; vc++ )); do
    touch $LOG_DIR/validator_node_$vc.log
done

echo "starting geth bootnode"
exec $HOME/Ethereum-setup/go-ethereum/build/bin/bootnode --nodekey ~/.bootnode_prik.txt & &>> $LOG_DIR/el_bootnode.log

echo "starting lighthouse bootnode"
$HOME/Ethereum-setup/private-network-setup/scripts/start_lighthouse_bootnode.sh  &>>  $LOG_DIR/bootnode.log  
sleep 5

for (( el=1; el<=$BN_COUNT; el++ )); do
    echo "starting node $el"
    $HOME/Ethereum-setup/private-network-setup/scripts/start_geth.sh -d $DEBUG_LEVEL $GETH_DATADIR/geth_datadir$el $((GETH_NETWORK_PORT + $el)) $((GETH_HTTP_PORT + $el)) $((GETH_AUTH_PORT + $el)) $((GETH_WS_PORT + $el)) $GETH_GENESIS_FILE &>>  $LOG_DIR/geth_$el.log  
    sleep 1
done

echo "sleeping 20 seconds after start execution engine"
sleep 20

for (( bn=1; bn<=$BN_COUNT; bn++ )); do
    $HOME/Ethereum-setup/private-network-setup/scripts/start_lighthouse_beaconnode.sh -d $DEBUG_LEVEL  $DATADIR/node_$bn $((LIGHTHOUSE_NETWORK_PORT + $bn))  $((LIGHTHOUSE_HTTP_PORT + $bn)) http://127.0.0.1:$((GETH_AUTH_PORT + $bn)) $GETH_DATADIR/geth_datadir$bn/geth/jwtsecret &>>  $LOG_DIR/beacon_node_$bn.log
    sleep 1
done

echo "sleeping 10 seconds for beacon nodes"
sleep 10

for (( vc=1; vc<=$VC_COUNT; vc++ )); do
    $HOME/Ethereum-setup/private-network-setup/scripts/start_lighthouse_validatorclient.sh -d $DEBUG_LEVEL  $DATADIR/node_$vc http://localhost:$((LIGHTHOUSE_HTTP_PORT + $vc))  &>>  $LOG_DIR/validator_node_$vc.log
done