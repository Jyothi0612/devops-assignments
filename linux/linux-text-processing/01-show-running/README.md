1. Show only lines where the server is `running`.

```
grep -w running servers.txt
```
```
❯ grep -w running servers.txt
web-server-01 192.168.1.10 running
db-server-01  192.168.1.20 running
db-server-02  192.168.1.21 running
```

`-w` matches `running` as a whole word only.