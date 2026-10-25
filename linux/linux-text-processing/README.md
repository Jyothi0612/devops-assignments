# Linux Text Processing

All tasks use `servers.txt`:

```
web-server-01 192.168.1.10 running
web-server-02 192.168.1.11 stopped
db-server-01  192.168.1.20 running
db-server-02  192.168.1.21 running
cache-server  192.168.1.30 stopped
```

---

## 1. Show only lines where the server is `running`.

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

---

## 2. Show only lines where the server is NOT `running`.

```
grep -w -v running servers.txt
```

```
❯ grep -w -v running servers.txt
web-server-02 192.168.1.11 stopped
cache-server  192.168.1.30 stopped
```

`-v` inverts the match: it shows lines that do **not** contain `running`.

---

## 3. Count how many servers are `running`.

```
grep -w running servers.txt | wc -l
```
```
3
```
`grep` finds the running lines, `|` passes them to `wc -l`, which counts lines.

Shorter, with grep's own count option:
```
grep -wc running servers.txt
```
```
3
```

---

## 4. Show the first 3 lines. Then show the last 2.

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

---

## 5. Extract only the IP addresses.

```
awk '{print $2}' servers.txt
```
```
❯ awk '{print $2}' servers.txt
192.168.1.10
192.168.1.11
192.168.1.20
192.168.1.21
192.168.1.30
```

`awk` splits each line into columns: `$1` = name, `$2` = IP, `$3` = status.
It treats several spaces as one separator, so the lines with double spaces still work.
`cut -d' ' -f2` would give empty lines for those, because it counts every space.

---

## 6. Extract only the server names.

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

---

## 7. Show only the names of `stopped` servers — in one command.

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
