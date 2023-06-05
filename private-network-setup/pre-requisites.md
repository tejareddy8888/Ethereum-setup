# Pre-Requisites 

As most people use a VPS or EC2 with debian or BSD distribution. Most of the below installation adheres to debian OS and it is tested only on Ubuntu but not on any other OS.

## System Requirements
Operating system: 64-bit Linux (i.e. Ubuntu 22.04.1 LTS Server or Desktop)

Memory: minimum 16GB RAM

Storage: minimum 200GB SSD

ETH balance: If you needs to run a validator then have at least 32 ETH and some ETH for deposit transaction fees (TODO: Faucet Link or EMAIL)

## Installation

#### OS level clean installation
```
sudo apt-get update -y && sudo apt dist-upgrade -y
sudo apt-get autoremove
sudo apt-get autoclean
sudo reboot
```

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

#### Synchronizing time with Chrony
```bash
sudo apt-get install chrony -y
```

#### Setting Timezone(if needed)
```bash 
sudo dpkg-reconfigure tzdata
```

## Network Configuration

#### Configure UFW Defaults and Ports
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
# Allow ssh access for remote node
sudo ufw allow 22/tcp comment 'Allow SSH port'

# Geth
sudo ufw allow 8546 comment 'Allow execution client port'
sudo ufw allow 8545 comment 'Allow execution client port'
sudo ufw allow 30303 comment 'Allow execution client port'

# Lighthouse
sudo ufw allow 9000 comment 'Allow consensus client port'

sudo ufw enable
sudo ufw status numbered 
```

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
