4. Move `backup.txt` to `/tmp/`. What happens to files there when the server restarts?

```
mv ../backup.txt /tmp/

❯ ls -l /tmp/backup.txt
-rw-r--r--@ 1 sivajyothipamarthy  staff  142 Oct 25 16:47 /tmp/backup.txt
```

### What happens to /tmp on restart?
```
df -h /tmp
```
```
[ec2-user@ip-172-31-3-151 ~]$ df -h /tmp
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           457M     0  457M   0% /tmp
```
On Amazon Linux 2023, `/tmp` is a **tmpfs**: it lives in RAM, so it is
emptied on every reboot. After `sudo reboot`:
```
ls -l /tmp/backup.txt
ls: cannot access '/tmp/backup.txt': No such file or directory
```

On RHEL 9, `/tmp` is on disk instead, and old files are cleaned up after
about 10 days. Either way: `/tmp` is for temporary files only.