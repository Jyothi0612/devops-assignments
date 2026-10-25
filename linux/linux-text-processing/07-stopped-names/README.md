7. Show only the names of `stopped` servers — in one command.

```
❯ grep -w stopped servers.txt | awk '{print $1}'
web-server-02
cache-server
```
`grep` keeps the stopped lines, then `awk` prints only the name column.
Only the first command reads the file; `awk` reads what comes through the pipe.

With `awk` alone:
```
❯ awk '$3 == "stopped" {print $1}' servers.txt
web-server-02
cache-server
```
For lines where column 3 is `stopped`, print column 1.