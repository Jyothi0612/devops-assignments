# Linux File Operations

---

## 1. Create the following directory structure using a single command:
   ```
   devops/
   └── projects/
       └── batch-92s/
   ```


```
mkdir -p devops/projects/batch-92s
```

`-p` creates all missing parent folders (`devops`, then `projects`) in one go,
and gives no error if they already exist.

```
❯ find devops
devops
devops/projects
devops/projects/batch-92s
```

---

## 2. Inside `batch-92s/`, create a file called `notes.txt`. Write three lines into it, then append two more. Read it to verify.

```
cd devops/projects/batch-92s

echo "I am a DevOps engineer" > notes.txt
echo "I work with Linux every day" >> notes.txt
echo "I automate tasks with shell scripts" >> notes.txt
```

Append two more lines:
```
echo "I deploy applications on AWS" >> notes.txt
echo "I keep learning every day" >> notes.txt
```

### Verify
```
cat notes.txt
```
```
I am a DevOps engineer
I work with Linux every day
I automate tasks with shell scripts
I deploy applications on AWS
I keep learning every day
```

| Symbol | Does |
|---|---|
| `>` | creates the file, or overwrites it if it exists |
| `>>` | appends to the end of the file |

---

## 3. Copy `notes.txt` to `projects/` and rename the copy to `backup.txt`. Verify both exist.

From inside `batch-92s/` (`..` = the parent folder, `projects/`):
```
cp notes.txt ../backup.txt
```
`cp` copies and renames in one step: the copy goes to `projects/` with the new name.

### Verify both exist
```
ls -l notes.txt ../backup.txt

-rw-r--r--@ 1 sivajyothipamarthy  staff  142 Oct 25 16:47 ../backup.txt
-rw-r--r--@ 1 sivajyothipamarthy  staff  142 Oct 25 16:46 notes.txt
```

---

## 4. Move `backup.txt` to `/tmp/`. What happens to files there when the server restarts?

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

---

## 5. Delete the `devops/` directory and everything inside it.

```
cd ~
rm -rf devops
```
- `-r` deletes the folder and everything inside it
- `-f` doesn't ask for confirmation

### Verify
```
ls devops
ls: cannot access 'devops': No such file or directory
```

`rm -rf` can't be undone: there is no recycle bin in Linux. I check the
path with `pwd` and `ls` before running it.

---

## 6. List the contents of `/var/log/` sorted by time. What do you notice? Why would a DevOps engineer check this directory?


```
cd /var/log
ls -ltr
```
```
total 296
drwxr-x---. 2 root   root                 6 Jul 14 17:05 sssd
-rw-------. 1 root   root                 0 Oct 23 23:56 tallylog
drwx------. 2 root   root                 6 Oct 23 23:56 private
-rw-rw----. 1 root   utmp                 0 Oct 23 23:56 btmp
lrwxrwxrwx. 1 root   root                39 Oct 23 23:56 README -> ../../usr/share/doc/systemd/README.logs
drwxr-sr-x+ 3 root   systemd-journal     46 Oct 25 19:52 journal
drwx------. 2 root   root                23 Oct 25 19:52 audit
drwxr-xr-x. 2 root   root                18 Oct 25 19:52 sa
drwxr-xr-x. 3 root   root                17 Oct 25 19:52 amazon
drwxr-x---. 2 chrony chrony              72 Oct 25 19:52 chrony
-rw-r-----. 1 root   adm               6248 Oct 25 19:55 cloud-init-output.log
-rw-r-----. 1 root   adm             265338 Oct 25 19:55 cloud-init.log
-rw-r--r--. 1 root   root               116 Oct 25 19:55 dnf.rpm.log
-rw-r--r--. 1 root   root              1889 Oct 25 19:55 dnf.librepo.log
-rw-r--r--. 1 root   root               120 Oct 25 19:55 hawkey.log
-rw-r--r--. 1 root   root              2354 Oct 25 19:55 dnf.log
-rw-rw-r--. 1 root   utmp            292292 Oct 25 19:56 lastlog
-rw-rw-r--. 1 root   utmp              6912 Oct 25 19:56 wtmp
```

`-l` long list, `-t` sort by time, `-r` reverse, so the newest is at the bottom.

### What I noticed
- The timestamps show the instance's life:
  - **Jul 14 / Oct 23:** files that came with the AMI image (`sssd`, `tallylog`, `btmp`)
  - **Oct 25 19:52:** the instance booted (`journal`, `audit`, `chrony`)
  - **19:55:** first-boot setup finished (`cloud-init.log`) and packages were checked (`dnf.log`)
  - **19:56, newest:** my SSH login was recorded (`wtmp`, `lastlog`)
- **Login records:** `wtmp` = successful logins (`last`), `btmp` = failed logins
  (`sudo lastb`). `btmp` is still empty on this new instance.
- **Mostly root-only:** `audit` and `private` are `drwx------`;
  `cloud-init.log` is readable only by root and the `adm` group.
- **No `messages` or `secure` file:** Amazon Linux 2023 keeps system logs
  in the journal (`journal/`), read with `journalctl`.

### Why a DevOps engineer checks /var/log
- **Troubleshooting:** when a service fails, the reason is in its log
  (e.g. `/var/log/nginx/error.log`, or my own script logs in `/var/log/roboshop/`)
- **Security:** who logged in or tried to: `last`, `sudo lastb`, `sudo journalctl -u sshd`
- **Disk space:** logs can fill the disk and crash services: `sudo du -sh /var/log`
