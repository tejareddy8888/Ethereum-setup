
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
