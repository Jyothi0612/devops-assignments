## Assignment — /etc/passwd Deep Dive

## 1. How many user accounts exist on the system?

```
wc -l /etc/passwd
```
```
28 /etc/passwd
```

Each line in `/etc/passwd` is one account, so counting lines counts accounts. This includes system accounts, not just human users.

---

## 2. Extract only the usernames.

```
awk -F ":" '{print $1}' /etc/passwd
```
```
[ec2-user@ip-172-31-3-151 ~]$ awk -F ":" '{print $1} ' /etc/passwd
root
bin
daemon
adm
lp
sync
shutdown
halt
mail
operator
games
ftp
nobody
dbus
systemd-network
systemd-oom
systemd-resolve
rpc
libstoragemgmt
systemd-coredump
systemd-timesync
sshd
chrony
ec2-instance-connect
stapunpriv
rpcuser
tcpdump
ec2-user
```

`-F ":"` splits each line at `:`, and `$1` is the first field, which is the username.

---

## 3. Show only users with UID greater than 999.

```
awk -F ":" '$3 > 999 {print $1, $3}' /etc/passwd
```
```
[ec2-user@ip-172-31-3-151 ~]$ awk -F ":" '$3 > 999 {print $1, $3}' /etc/passwd
nobody 65534
ec2-user 1000
```

`$3 > 999` is the condition: awk prints only the lines where the UID (field 3) is above 999. UIDs 1000 and up are normal users; lower ones are system accounts.

This prints the username and UID. If you'd rather show the whole line, use {print $0} (or just {print})

---

## 4. Find the entry for `ec2-user`. What is their home directory?

```
grep -w ec2-user /etc/passwd
```
```
[ec2-user@ip-172-31-3-151 ~]$ grep -w ec2-user /etc/passwd
ec2-user:x:1000:1000:EC2 Default User:/home/ec2-user:/bin/bash
```

```
grep -w ec2-user /etc/passwd | awk -F ":" '{print $6}'
```
```
/home/ec2-user
```

`grep` finds the ec2-user line, and field 6 (`$6`) is the home directory.

---

## 5. List all unique login shells assigned to users on the system.

```
awk -F ":" '{print $7}' /etc/passwd | sort | uniq
```
```
/bin/bash
/bin/sync
/sbin/halt
/sbin/nologin
/sbin/shutdown
/usr/sbin/nologin
```

With counts:
```
awk -F ":" '{print $7}' /etc/passwd | sort | uniq -c
```
```
      2 /bin/bash
      1 /bin/sync
      1 /sbin/halt
     16 /sbin/nologin
      1 /sbin/shutdown
      7 /usr/sbin/nologin
```

Field 7 is the login shell. `sort` puts repeats next to each other and `uniq` removes them (`-c` counts them). Only 2 accounts use `/bin/bash`; system accounts use `nologin` so nobody can log in as them.