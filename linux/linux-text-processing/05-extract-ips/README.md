5. Extract only the IP addresses.

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