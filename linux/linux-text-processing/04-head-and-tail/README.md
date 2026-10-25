4. Show the first 3 lines. Then show the last 2.

```
head -n 3 servers.txt
```
```
❯ head -n 3 servers.txt
web-server-01 192.168.1.10 running
web-server-02 192.168.1.11 stopped
db-server-01  192.168.1.20 running
```

```
tail -n 2 servers.txt
```
```
❯ tail -n 2 servers.txt
db-server-02  192.168.1.21 running
cache-server  192.168.1.30 stopped
```

`tail -f` keeps the file open and prints new lines as they are added.
I use it to watch logs live, e.g. `tail -f /var/log/nginx/error.log`
(like `journalctl -f` for services).