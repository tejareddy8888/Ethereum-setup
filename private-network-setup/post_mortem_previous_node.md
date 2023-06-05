As the geth, lighthouse are configured to emit logs on systemctl  they usually fill the var/log/syslog. As the system log are growing immensively. It completely ate up the storage.

### Steps followed to clear the logs
 
1. Safely clear the logs: after looking at (or backing up) the logs to identify your system's problem, clear them by typing 

```sh
$ > /var/log/syslog
```

2. Later, update the logrotate's config file with below provide configuration. Choose the rotate value and the maxsize as desired. open file `/etc/logrotate/rsyslog`

```bash
/var/log/syslog
{
    rotate 7
    daily
    maxsize 1G
    missingok
    notifempty
    delaycompress
    compress
    postrotate
        /usr/lib/rsyslog/rsyslog-rotate
    endscript
}
```

3. Provide access for root user to `/var/log` folder 
```bash
$ chmod 755 /var/log/ && chown root:root /var/log/
```

4.  As logrotate does not fetch the config automatically, use the below command to update the logrotate.
```bash
$ logrotate /etc/logrotate.d/rsyslog
```

5. To check the storage of the file system use: 
```sh 
df -h /
```

6. To check which file directory was consuming more space use:

```sh
du -h / | sort -h
```

7. If you see it is `/var/lib/docker/*/*` or `/var/lib/overlay%/*` , this is mostly due to docker container logs, there are set of basic docker command which can improve to remove the unused volumes or unused container or images by below:

```sh
docker container prune

docker image prune

docker volume prune

docker system prune -a
```

8. check if the storage has any impact, follow the below commands

```sh 

du -shc /var/lib/docker/containers/*/*.log | sort -h 

(or)

du -shc /var/lib/docker/overlay2/*/diff | sort -h
```

9. In the above command, you will receive the list of logs in descending order of the storage space they occupy, pick the heaviest one or heaviest file and copy the FILENAME or FOLDERID. Now in the below command place the folder id and find out which container or image is causing the issue. 
   
```sh
docker inspect $(docker container ls -q) | grep ‘FOLDERIDHERE’ -B 100 -A 100
```

10. Once you see the image name or container name.

```sh
docker ps 
```

11. Out of the list of the application fetch the container id of the application which was causing the issue.
```sh
docker inspect --format='{{.LogPath}}' CONTAINER_ID_HERE

sudo sh -c 'echo "" > $(docker inspect --format="{{.LogPath}}" CONTAINER_ID_HERE)'
```

12. Open the Docker daemon configuration file  `/var/snap/docker/current/etc/docker/daemon.json` using a text editor of your choice. If the file does not exist, create it.

```sh
sudo vi /var/snap/docker/current/etc/docker/daemon.json
```

13. Docker logging drivers, including json-file, have optional log rotation support 

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "5"
  }
}
```

14. Restart the Docker daemon to apply the change

```sh
sudo service docker restart
```