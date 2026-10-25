2. Show only lines where the server is NOT `running`.

```
grep -w -v running servers.txt
```

```
❯ grep -w -v running servers.txt
web-server-02 192.168.1.11 stopped
cache-server  192.168.1.30 stopped
```

`-v` inverts the match: it shows lines that do **not** contain `running`.