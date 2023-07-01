#!/bin/bash -i

source $HOME/Ethereum-setup/private-network-setup/vars.env

mkdir -p $LOG_DIR
for (( bn=1; bn<=$BN_COUNT; bn++ )); do
    touch $LOG_DIR/beacon_node_$bn.log
done
for (( el=1; el<=$BN_COUNT; el++ )); do
    touch $LOG_DIR/geth_$el.log
done
for (( vc=1; vc<=$VC_COUNT; vc++ )); do
    touch $LOG_DIR/validator_node_$vc.log
done

touch $LOG_DIR/PIDS.pid

for (( el=1; el<=$BN_COUNT; el++ )); do
    ./start_geth.sh -d $DEBUG_LEVEL $GETH_DATADIR/geth_datadir$el $((GETH_NETWORK_PORT + $el)) $((GETH_HTTP_PORT + $el)) $((GETH_AUTH_PORT + $el)) $((GETH_WS_PORT + $el)) &>>  $LOG_DIR/geth_$el.log &
    echo "$!" >> $PID_FILE
done

for (( bn=1; bn<=$BN_COUNT; bn++ )); do
    ./start_lighthouse_beaconnode.sh -d $DEBUG_LEVEL  $DATADIR/node_$bn $((LIGHTHOUSE_NETWORK_PORT + $bn))  $((LIGHTHOUSE_HTTP_PORT + $bn)) http://127.0.0.1:$((GETH_AUTH_PORT + $bn)) $GETH_DATADIR/geth_datadir$bn/geth/jwtsecret &>>  $LOG_DIR/beacon_node_$bn.log &
    echo "$!" >> $PID_FILE
done

for (( vc=1; vc<=$VC_COUNT; vc++ )); do
    ./start_lighthouse_validatorclient.sh -d $DEBUG_LEVEL  $DATADIR/node_$vc http://localhost:$((LIGHTHOUSE_HTTP_PORT + $vc))  &>>  $LOG_DIR/lighthouse_vc_$vc.log &
    echo "$!" >> $PID_FILE
done