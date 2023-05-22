# Private Network Setup Documentation 

As most people use a VPS or EC2 with debian or BSD distribution. Most of the below installation adheres to Ubuntu and it is tested only on Ubuntu but not on any other OS.

## System Requirements
Operating system: 64-bit Linux (i.e. Ubuntu 22.04.1 LTS Server or Desktop)

Memory: 16GB RAM

Storage: 200GB SSD

ETH balance: If user needs to run a validator then at least 32 ETH and some ETH for deposit transaction fees (TODO: Faucet)

## Installation

### Pre-Requistes
#### Install Dependencies

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

#### Install Docker
```
sudo snap install docker
```
Follow the post-installation steps: https://docs.docker.com/engine/install/linux-postinstall/

and also add 

```
sudo chmod 666 /var/run/docker.sock
```


#### Install Rust

We need to install Rust to create the executables for Lighthouse.  
For Ubuntu-based distributions we can use the following command to install Rust from rustup:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```


### Installing Execution Client
#### Install Geth

You can obtain the installation script using wget:
```git clone "https://****/uzh-pos"```

change directory to the folder uzh-pos-geth:
```cd uzh-pos/geth ```

Then run:
```make install```

You now have a local installation of geth which you can run with geth, try it with:

```geth version```

if it does not work, please source your `bashrc` or `zshrc` using:
```source ~/.bashrc``` or ```source ~/.zshrc```

It should provide an output like below:
```log
Geth
Version: 1.11.7-unstable
Git Commit: 8f373227ac481685148019b21ef9e1478d3ba609
Git Commit Date: 20230427
Architecture: amd64
Go Version: go1.20.3
Operating System: linux
GOPATH=/home/ubuntu/go
GOROOT=
```

<!-- 
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

To Confirm installation of GETH, The above commands install the core Geth software and the following developer tools: clef, devp2p, abigen, bootnode, evm, rlpdump and puppeth. The binaries for each of these tools are saved in `/usr/local/bin/` or `/usr/bin`.  -->

#### Initialize GETH with genesis block 
Initialize the geth with the genesis json file: 
```geth init --datadir ~/.ethereum/uzhethpos/privnet/geth-node-1 <path-to-git-repo>/uzh-pos-genesis.json```

#### Generate a valid account using GETH
Generate a valid account using your favorite tool, take note of the address.  here are 3 options:
    1. `ethkey generate` + geth’s —nodekey
    2. `geth console` + `eth.newAccount`
    3. create a new address in something like metamask.
    4. `geth --datadir ~/.ethereum/uzhethpos/privnet/geth-node-1  account import ${filename which contains key}` , Delete the file with the key after importing

#### Import this account into GETH 
1. Now, copy the private key inside a geth console session (``` geth --datadir ~/.ethereum/uzhethpos/privnet/geth-node-1 console`)```
2. Then run 
```web3.personal.importRawKey("<Private Key>","<Password>") ```

#### Starting GETH
Use the `start_geth.sh` file in git repository.

```bash
chmod +x ./start_geth.sh
./start_geth.sh
```

or run below
```bash 
geth --datadir /home/ubuntu/.ethereum/uzhethpos \
--networkid 8888 \
--http --http.port 8545 --http.api personal,eth,net,web3,engine,debug,txpool  --http.addr 0.0.0.0 --http.vhosts "*" --http.corsdomain "*" \
--ws --ws.addr 0.0.0.0 --ws.port 8546 --ws.origins "*" \
--discovery.dns "" \
--port 30303 \
--mine --miner.etherbase=<address> --miner.threads 1 --miner.gaslimit 1000000000 \
--authrpc.jwtsecret /home/ubuntu/.ethereum/uzhethpos/geth/jwtsecret --authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost \
--unlock "<address>" --password <(echo "password") \
--syncmode "full" --gcmode "archive" >  ~/.ethereum/miner.log 2>&1
```
where `<address>` and `<password>` is the public key of the wallet you created in step `Generate a valid account`


### Installing Consensus Client
#### Install Lighthouse

You can obtain the installation script using wget:
```git clone "https://****/uzh-pos"```

change directory to the folder uzh-pos-geth:
```cd uzh-pos/lighthouse ```

Then run:
```make install```

You now have a local installation of geth which you can run with lighthouse, try it with:

```lighthouse --version```

if it does not work, please source your `bashrc` or `zshrc` using:
```source ~/.bashrc``` or ```source ~/.zshrc```

It should provide an output like below:
```log
Lighthouse v4.0.1-1f44c51+
BLS library: blst
SHA256 hardware acceleration: false
Allocator: jemalloc
Specs: mainnet (true), minimal (false), gnosis (false)
```

#### Starting Lighthouse

### start lighthouse boot node:

Use the `start_lighthouse_bootnode.sh` file in git repository.

```bash
source <path-to-uzh-pos>/vars.env
chmod +x ./start_lighthouse_bootnode.sh
./start_lighthouse_bootnode.sh
```

or run below
```bash 
source <path-to-uzh-pos>/vars.env
lighthouse boot_node \
    --testnet-dir $TESTNET_DIR \
    --port $BOOTNODE_PORT \
    --listen-address 127.0.0.1 \
    --disable-packet-filter \
    --network-dir $DATADIR/bootnode
```

### start lighthouse beacon node: 
Use the `start_lighthouse_beacon_node.sh` file in git repository.

```bash
source <path-to-uzh-pos>/vars.env
chmod +x ./start_lighthouse_beacon_node.sh
./start_lighthouse_beacon_node.sh
```

or run below
```bash 
source /home/ubuntu/vars.env
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
    --target-peers 0 \
    --terminal-total-difficulty-override=60000000 \
    --execution-endpoints http://127.0.0.1:8551/ \
    --execution-jwt /home/ubuntu/.ethereum/uzhethpos/geth/jwtsecret \
    --http-allow-sync-stalled
```

### start lighthouse validator client:
If you want to run a validator only then run below:
Use the `start_lighthouse_validator_client.sh` file in git repository.

TODO: Missing Deposit of the 32 ETH and configuring MNEMONIC of the public key of the validator.

```
source <path-to-uzh-pos>/vars.env
chmod +x ./start_lighthouse_validator_client.sh
./start_lighthouse_validator_client.sh
```

or run below
```bash 
source /home/ubuntu/vars.env
lighthouse \
    --debug-level $DEBUG_LEVEL \
    vc \
    --datadir $data_dir \
    --testnet-dir $TESTNET_DIR \
    --init-slashing-protection \
    --beacon-nodes $beacon_nodes \
    $VC_ARGS
```
## Automate the maintain by connecting the commands to system services

First of all, stop both services and define `start_geth.sh` and `start_lighthouse.sh` as given in the files 

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
ExecStart=${PATH}/start_geth.sh

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
ExecStart=${PATH}/start_lighthouse.sh

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

#### Environment variables


## [Optional] Security Requirements

### Enable Automatic Security Updates

Operating System vendors routinely publish updates and security fixes, so it is important that you keep your system up to date with the latest patches.
The easiest way to do this is to enable automatic updates.

Run the following commands on your node machine:

```shell
sudo apt update
sudo apt install -y unattended-upgrades update-notifier-common
```

You can change the auto-update settings by editing `/etc/apt/apt.conf.d/20auto-upgrades`:

```shell
sudo nano /etc/apt/apt.conf.d/20auto-upgrades
```

This is an example of reasonable auto-update settings:

```shell
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";

# This is the most important choice: auto-reboot.
# This should be fine since all services auto-starts on reboot.
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "02:00";
```

After, make sure to load the new settings:

```shell
sudo systemctl restart unattended-upgrades
```

### Protect from DDOS
Protecting yourselves from DDOS attacks DDoS attacks and brute-force connection attempts, you can install `fail2ban`

```shell
sudo apt install -y fail2ban
```
Next, open `/etc/fail2ban/jail.d/ssh.local`:

```shell
sudo nano /etc/fail2ban/jail.d/ssh.local
```

Add the following contents to it:

```bash
[sshd]
enabled = true
banaction = ufw
port = 22
filter = sshd
logpath = %(sshd_log)s
maxretry = 5
```

You can change the `maxretry` setting, which is the number of attempts it will allow before locking the offending address out.

Once you're done, save and exit with `Ctrl+O` and `Enter`, then `Ctrl+X`.

Finally, restart the service:

```shell
sudo systemctl restart fail2ban
```


### Reverse Proxy Setup 
```bash
sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
```

Download nginx signing key 

```bash
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
```

To set up the apt repository for stable nginx packages, run the following command:
```bash
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
```

To install nginx, run the following commands:

```bash
    sudo apt update
    sudo apt install nginx
```

Next, open `/etc/nginx/nginx.conf`:

add below for reverse proxy

```bash

```

## Note: