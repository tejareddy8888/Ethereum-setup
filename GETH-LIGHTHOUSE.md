## 

As most people use a VPS or EC2 with debian or BSD distribution. Most of the below installation adheres to Ubuntu and it is tested only on Ubuntu but not on any other OS.

## System Requirements

## Procedure

#### Install Geth 
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

#### Create execution layer' genesis file
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
4. copy file `geth.json` from `custom_config_data` folder and Check the genesis file `geth.json` - verify clique is not present. it is probably generated anyways - delete the corresponding JSON entry.


5. Generate a valid account using your favorite tool, take note of the address.  here are 3 options:
    1. `ethkey generate` + geth’s —nodekey
    2. geth console + eth.newAccount
    3. create a new address in something like metamask.
   
6. Now, copy the private key inside a geth console session (`geth --datadir ~/.ethereum/${folder-Name}/privnet/geth-node-1 console`) and then run `web3.personal.importRawKey("<Private Key>","<Password>")`

7. Check the node starts to mine and kill it quickly. You only have 100 blocks until fork is enabled and 400 blocks until node stops mining
```bash 
geth --datadir ~/.ethereum/local-testnet/testnet/geth-node-1 --networkid 4242 --http --http.port 8545 --http.api \
personal,eth,net,web3,engine,debug --discovery.dns "" --port 30303 --mine --miner.etherbase=<address> --miner.threads 1 \
--miner.gaslimit 1000000000 --authrpc.jwtsecret ~/.ethereum/local-testnet/testnet/geth-node-1/geth/jwtsecret --authrpc.addr localhost \
--authrpc.port 8551 --authrpc.vhosts localhost --unlock "<address>" --password <(echo "<password>") \
 --allow-insecure-unlock > ~/.ethereum/miner.log 2>&1
```
where `<address>` is the public key of the wallet you created in step

#### Environment variables



## Note: 