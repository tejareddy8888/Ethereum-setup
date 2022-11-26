
# Full Node Setup

## Install GETH


```bash
sudo add-apt-repository -y ppa:ethereum/ethereum
```

Then, to install the stable version of go-ethereum:

```bash 
sudo apt-get update
sudo apt-get install ethereum
```

To Confirm installation of GETH, The above commands install the core Geth software and the following developer tools: clef, devp2p, abigen, bootnode, evm, rlpdump and puppeth. The binaries for each of these tools are saved in `/usr/local/bin/` or `/usr/bin`. 


## Create jwtsecret for Authentication

```sh
openssl rand -hex 32 > jwtsecret
```

## Setup the Geth 
We are trying to use goerli with snap sync mode in this you can choose to differ

```sh
geth --goerli  --datadir "/home/ubuntu/.ethereum" \
--http --http.port 8545 --http.api personal,eth,net,web3,engine,debug,txpool  --http.addr 0.0.0.0 --http.vhosts "*" --http.corsdomain "*" \
--ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.origins "*" \
--authrpc.addr="localhost" --authrpc.jwtsecret="/home/ubuntu/jwtsecret" --maxpeers=30
```


## Install lighhouse 


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

### Install Rustup

We need to install Rust to create the executables for Lighthouse.  
For Ubuntu-based distributions we can use the following command to install Rust from rustup:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
use rustup verison 1.64, higher fail to compile lighthouse

### Setup the lighthouse
We used lighthouse checkpoint to start sycning, you can tend to differ if the you need full syncing

```sh
lighthouse beacon_node  --network goerli        --datadir "~/.ethereum"         --http          --execution-endpoint http://127.0.0.1:8551      --execution-jwt jwtsecret         --checkpoint-sync-url=https://goerli.checkpoint-sync.ethpandaops.io
```

## Check the Setup
Check the above logs and verify the setup by below methods

Now attach the geth ipc url and check eth.syncing status


```sh
geth attach ${ipc_url}
```

## Automate the maintain by connecting the commands to system services

cd /etc/systemd/system

Create a file named geth.service and include the following:

```service
[Unit]
Description=Go Ethereum Client
After=network.target
Wants=network.target

[Service]
User=ubuntu
Group=ubuntu
Type=simple
Restart=always
RestartSec=5
ExecStart=geth --goerli     --datadir "/home/ubuntu/.ethereum"     --http --http.api="personal,eth,net,web3,engine,debug"     --ws --ws.api="personal,eth,net,web3,engine,debug"    --authrpc.addr="localhost" --authrpc.jwtsecret="/home/ubuntu/jwtsecret" --maxpeers=30

[Install]
WantedBy=default.target
```

Create a file named lighthouse.service and include the following:
```service
[Unit]
Description=Lighthouse Client
After=network.target
Wants=network.target

[Service]
User=ubuntu
Group=ubuntu
Type=simple
Restart=always
RestartSec=5
ExecStart=/home/ubuntu/.cargo/bin/lighthouse beacon_node  --network goerli  --datadir "/home/ubuntu/.ethereum"         --http          --execution-endpoint http://127.0.0.1:8551      --execution-jwt="/home/ubuntu/jwtsecret"         --checkpoint-sync-url=https://goerli.checkpoint-sync.ethpandaops.io

[Install]
WantedBy=default.target
```

Reload the service files to include the new service.
```
sudo systemctl daemon-reload
```

Start the services
```
sudo systemctl start geth.service
sudo systemctl start lighthouse.service
```

To check the status of the service
```
sudo systemctl status geth.service
sudo systemctl status lighthouse.service
```

To check the logs of the service
```
sudo journalctl -fu geth.service
sudo journalctl -fu lighthouse.service
```

To enable your service on every reboot
```
sudo systemctl enable geth.service
sudo systemctl enable lighthouse.service
```

To disable your service on every reboot
```
sudo systemctl disable geth.service
sudo systemctl disable lighthouse.service
```