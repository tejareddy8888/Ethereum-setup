## 

As most people use a VPS or EC2 with debian or BSD distribution. Most of the below installation adheres to Ubuntu and it is tested only on Ubuntu but not on any other OS.

## System Requirements

### Install Dependencies

```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  cmake \
  protobuf-compiler \
  libprotobuf-dev \
  libclang-dev \
  libssl-dev \
  openssl \
  pkg-config \
  librust-openssl-dev
```

### Install Geth

> Ubuntu via PPAs

The easiest way to install Geth on Ubuntu-based distributions is with the built-in launchpad PPAs (Personal Package Archives). A single PPA repository is provided, containing stable and development releases for Ubuntu versions xenial, trusty, impish, focal, bionic.

The following command enables the launchpad repository:

```bash
sudo add-apt-repository -y ppa:ethereum/ethereum
```

Then, to install the stable version of go-ethereum:

```bash 
sudo apt-get update
sudo apt-get install ethereum
```

To Confirm installation of GETH, The above commands install the core Geth software and the following developer tools: clef, devp2p, abigen, bootnode, evm, rlpdump and puppeth. The binaries for each of these tools are saved in `/usr/local/bin/` or `/usr/bin`. 


### Install Rust

We need to install Rust to create the executables for Lighthouse.  
For Ubuntu-based distributions we can use the following command to install Rust from rustup:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```


## Procedure


### Create the Execution Layer (EL)


The genesis file used for the current setup can be seen at [`genesis.json`](./genesis.json).

We use [Ethereum-genesis-generator](https://github.com/ethpandaops/ethereum-genesis-generator) and follow the steps as below.


1. clone the repo
```bash
git clone git@github.com:ethpandaops/ethereum-genesis-generator.git
```

2. create a folder data by replicating config-examples
```bash
cp -r config-example data
```

3. edit the values in the `data/el/genesis-config.yaml` , changes the values manually or else the values from `values.env` overrides them.
```bash
docker run --rm -it -u $UID -v $PWD/data:/data -p 127.0.0.1:8000:8000 \
  -v $PWD/data/el/genesis-config.yaml:/config/el/genesis-config.yaml \
  ethpandaops/ethereum-genesis-generator:latest el
```
4. copy file `genesis.json` from `custom_config_data` folder and Check the genesis file `genesis.json` - verify clique is not present.
There should not exist a key named clique in the JSON file, if so delete the corresponding JSON entry. Also, make sure that the variables from `values.env`, e.g. the CHAIN_ID, is properly set.
In the example [`genesis.json`](./genesis.json) the CHAIN_ID = 8888.

5. override the `terminalTotalDifficulty` to `60000000` or some other value that is bigger than 0. Make sure that you make a mental note of this value so that we can reuse it when setting up the CL, in this case the Lighthouse.

6. initialize the geth with the genesis json file: `geth init --datdir ~/.ethereum/${folder-Name}/privnet/geth-node-1 genesis.json`

7. Generate a valid account using your favorite tool, take note of the address.  here are 3 options:
    1. `ethkey generate` + geth’s —nodekey
    2. geth console + eth.newAccount
    3. create a new address in something like metamask.
   
8. Now, copy the private key inside a geth console session (`geth --datadir ~/.ethereum/${folder-Name}/privnet/geth-node-1 console`) and then run `web3.personal.importRawKey("<Private Key>","<Password>")`

9. Check the node starts to mine and kill it quickly. You only have 100 blocks until fork is enabled and 400 blocks until node stops mining
```bash 
geth --datadir ~/.ethereum/local-testnet/testnet/geth-node-1 --networkid 8888 --http --http.port 8545 --http.api \
personal,eth,net,web3,engine,debug --discovery.dns "" --port 30303 --mine --miner.etherbase=<address> --miner.threads 1 \
--miner.gaslimit 1000000000 --authrpc.jwtsecret ~/.ethereum/local-testnet/testnet/geth-node-1/geth/jwtsecret --authrpc.addr localhost \
--authrpc.port 8551 --authrpc.vhosts localhost --unlock "<address>" --password <(echo "<password>") \
 --allow-insecure-unlock > ~/.ethereum/miner.log 2>&1
```
where `<address>` is the public key of the wallet you created in step


### Create the Consensus Layer (CL)

The environment variables for setting up the CL can be seen at [`vars.env`](./vars.env).

We use the [Lighthouse](https://github.com/sigp/lighthouse) and follow the steps as below.


1. clone the repo
```bash
git clone git@github.com:sigp/lighthouse.git
```

2. Go to `scripts/local_testnet`
    1. Modify vars.env:
        1. Set `ETH1_NETWORK_MNEMONIC`, `DEPOSIT_CONTRACT_ADDRESS`, `GENESIS_FORK_VERSION` to be the same as in PoW’s config (GENESIS_FORK_VERSION is in `ethereum-genesis-generator/data/cl/config.yaml`)
        2. Set `GENESIS_DELAY` to 30
        3. Set `ALTAIR_FORK_EPOCH` to 1
        4. Add `MERGE_FORK_EPOCH=1`
        5. Adjust `SECONDS_PER_SLOT`, `SECONDS_PER_ETH1_BLOCK`, `BN_COUNT` to your preference
            1. There seem to be some issues with multiple beacon nodes using the same EL, if it does not work set `BN_COUNT` to 1
        6. Do not change `VALIDATOR_COUNT`, `GENESIS_VALIDATOR_COUNT` to less than 64
        7. modify VC_ARGS line to `VC_ARGS="--suggested-fee-recipient <address>"`, where \<address> is the same public key that you registered in the `geth` command #8 above
    2. Modify scripts/local_testnet/beacon_node.sh:
        1. Add merge options to the end of the `exec lighthouse` command at the bottom: `--eth1 --merge --terminal-total-difficulty-override=60000000 --eth1-endpoints http://127.0.0.1:8545/ --execution-endpoints http://127.0.0.1:8551/ --http-allow-sync-stalled --execution-jwt ~/.ethereum/local-testnet/testnet/geth-node-1/geth/jwtsecret` .  (don't forget to add `\` between newlines, if any.  confirm that the jwtsecret path is the one used by `geth` - you may need to expand the `~`)  
        If you have entered a `terminalTotalDifficulty` other than `60000000` in #5 above.

        2. Allow all subnets, with the line `SUBSCRIBE_ALL_SUBNETS="--subscribe-all-subnets"`

    3. Modify scripts/local_testnet/setup.sh:
        1. Add `--merge-fork-epoch $MERGE_FORK_EPOCH`
    4. Modify start_local_testnet.sh:
        1. Remove/comment ganache [`https://github.com/sigp/lighthouse/blob/stable/scripts/local_testnet/start_local_testnet.sh#L93`](https://github.com/sigp/lighthouse/blob/stable/scripts/local_testnet/start_local_testnet.sh#L93)

3. install lighthouse and lcli:
    1. make
      - in this process you may encounter some compiling issues from rust, follow the instructions to solve it (e.g. adding `#![recursion_limit="256"]` to the source code)
    2. make install-lcli  


### Run and hope for the best

1. Run geth, wait until you see blocks in the logs
2. Run lighthouse’s `start_local_testnet.sh`. If fails make sure to read the log. If it complains about lack of funds check that geth mines blocks and retry.
3. Monitor the logs, PoS will kick in once `mergeForkBlock` is reached but you should see beacon and validator nodes being active before that (just not finalizing any epochs and not producing blocks and not voting before `mergeForkBlock`)
4. Once geth reaches `terminal_total_difficulty` it stops mining eth1 blocks (`60000000` ~12 min) and should be used by beacon nodes to create PoS payloads.


#### Environment variables


## Note: 