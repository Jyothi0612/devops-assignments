6. Extract only the server names.

```
awk '{print $1}' servers.txt
```
```
❯ awk '{print $1}' servers.txt
web-server-01
web-server-02
db-server-01
db-server-02
cache-server
```
`$1` is the first column, the server name.