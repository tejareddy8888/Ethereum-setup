# User's Network Setup Documentation

Before running this setup, check that your environment have all required software installed as mentioned in the pre-requisites in `prerequisites.md`

The network setup should be starting after completely the pre-requisities only.

## 1. Retreive the entire submodule of the repository

Retrieve all the submodules of the main git repository using the below command:

```bash
make fetch
```

## 2. Installing Execution Client

### Install Geth

1. To install the Geth from the go-ethereum submodule fetched, run command:

    ```bash
    make setup-geth
    ```

2. You now have a local installation of geth which you can run with geth, try it with:

    ```bash
    geth version
    ```

3. if it does not work, please source your `bashrc` or `zshrc` using:
```source ~/.bashrc``` or ```source ~/.zshrc```

4. It should provide an output like below:

    ```
    Geth
    Version: 1.12.0-stable
    Git Commit: 7136b480fea2635b4da3df2a08c90c2f558f179a
    Git Commit Date: 20230604
    Architecture: amd64
    Go Version: go1.20.2
    Operating System: linux
    GOPATH=/home/ubuntu/go
    GOROOT=/home/ubuntu/.go
    ```

## 3. Installing Consensus Client

### Install Lighthouse

1.  To install the lighthouse from the lighthouse submodule fetched, run command:

    ```bash
    make setup-lighthouse
    ```

2. You now have a local installation of geth which you can run with lighthouse, try it with:

    ```bash
    lighthouse --version
    ```

3. if it does not work, please source your `bashrc` or `zshrc` using:
```source ~/.bashrc``` or ```source ~/.zshrc```

4. It should provide an output like below:

    ```
    Lighthouse v4.2.0-c547a11
    BLS library: blst
    SHA256 hardware acceleration: false
    Allocator: jemalloc
    Specs: mainnet (true), minimal (false), gnosis (false)
    ```

## 4. Initialize GETH with genesis block

Initialize the geth with the genesis json file:

```
geth init --datadir ~/.ethereum/uzhethpos/privnet/ <path-to-repo>/Ethereum-setup/private-network-setup/uzh-pos-genesis.json
```

## 5. Initialize Lighthouse with genesis directory

```bash
source $HOME/Ethereum-setup/private-network-setup/vars.env
cp -r ~/Ethereum-setup/private-network-setup/cl_genesis_dir/*   $TESTNET_DIR
```

## 6. Starting GETH

Use the `start_geth.sh` file in git repository.

```bash
cd $HOME/Ethereum-setup/private-network-setup/scripts/
chmod +x ./start_geth.sh
./start_geth.sh
```

or run using MakeFile in the root directory of the repository

```bash
make start_geth
```

or run using the geth command for custom configuration (only for advance users)

```bash
source $HOME/Ethereum-setup/private-network-setup/vars.env

geth --datadir $GETH_DATADIR \
--networkid 8888 \
--http --http.port 8545 --http.api personal,eth,net,web3,engine,debug,txpool \
--http.addr 0.0.0.0 --http.vhosts "*" --http.corsdomain "*" \
--ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.origins "*" \
--bootnodes $EL_BOOTNODE_ENODE \
--port 30303 \
--authrpc.jwtsecret $GETH_DATADIR/geth/jwtsecret \
--authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost \
--syncmode "full" --gcmode "archive" >  ~/.ethereum/miner.log 2>&1
```

## 7. Starting Lighthouse

### start lighthouse beacon node

Use the `start_lighthouse_beacon_node.sh` file in git repository.

```bash
source <path-to-uzh-pos>/vars.env
chmod +x ./start_lighthouse_beacon_node.sh
./start_lighthouse_beacon_node.sh
```

or run below

```bash
source $HOME/Ethereum-setup/private-network-setup/vars.env
lighthouse \
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
	--target-peers $((BN_COUNT - 1)) \
    --execution-endpoints http://127.0.0.1:8551/ \
    --execution-jwt $GETH_DATADIR/geth/jwtsecret 
```

## start lighthouse validator client

### CREATE VALIDATOR KEYS

### ADD VALIDATOR KEYS 

TODO: Missing Deposit of the 32 ETH and configuring MNEMONIC of the public key of the validator.

### START THE VALIDATOR CLIENT
If you want to run a validator then run below:

Use the `start_lighthouse_validator_client.sh` file in git repository.

```
source <path-to-uzh-pos>/vars.env
chmod +x ./start_lighthouse_validator_client.sh
./start_lighthouse_validator_client.sh
```

or run below

```bash
source $HOME/Ethereum-setup/private-network-setup/vars.env
lighthouse \
    --debug-level $DEBUG_LEVEL \
    vc \
    --datadir $data_dir \
    --testnet-dir $TESTNET_DIR \
    --init-slashing-protection \
    --beacon-nodes $beacon_nodes \
    $VC_ARGS
```

