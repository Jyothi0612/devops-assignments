## Assignment — File Permissions and Ownership

> I work in `/tmp/perm-lab`. My home folder `/home/ec2-user` is `drwx------`, so another user would be blocked by the folder before the file permissions even matter.

```
mkdir -p /tmp/perm-lab && cd /tmp/perm-lab
```

## 1. Create `secret.txt` with some content. Who can read it by default?

```
echo "db_password=Test@123" > secret.txt
ls -l secret.txt
umask
```
```
[ec2-user@ip-172-31-3-151 perm-lab]$ echo "db_password=Test@123" > secret.txt
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -l secret.txt
-rw-r--r--. 1 ec2-user ec2-user 21 Oct 26 19:14 secret.txt
[ec2-user@ip-172-31-3-151 perm-lab]$ umask
0022
```

New files get `666` minus the `umask`. With umask `0002` that is `rw-rw-r--` (664), with `0022` it is `rw-r--r--` (644). Either way the last `r` means **others can read it**: every user on the server.

---

## 2. Only the owner can read and write. Switch to another user and try to read it.

```
chmod 600 secret.txt
ls -l secret.txt
sudo su - bob
cat /tmp/perm-lab/secret.txt
```
```
[ec2-user@ip-172-31-3-151 perm-lab]$ chmod 600 secret.txt
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -l secret.txt
-rw-------. 1 ec2-user ec2-user 21 Oct 26 19:14 secret.txt
[ec2-user@ip-172-31-3-151 perm-lab]$ sudo su - bob
Last login: Mon Oct 26 19:07:48 UTC 2026 on pts/2
[bob@ip-172-31-3-151 ~]$ cat /tmp/perm-lab/secret.txt
cat: /tmp/perm-lab/secret.txt: Permission denied
[bob@ip-172-31-3-151 ~]$ 

```

`600` = `rw-------`: owner read and write, nobody else anything. bob gets `Permission denied`.

---

## 3. Create `deploy.sh`, executable by the owner only. Numeric value for owner read+write+execute?

```
echo 'echo "Deploying..."' > deploy.sh
chmod 744 deploy.sh
ls -l deploy.sh
./deploy.sh
```
```
[ec2-user@ip-172-31-3-151 perm-lab]$ echo 'echo "Deploying..."' > deploy.sh
[ec2-user@ip-172-31-3-151 perm-lab]$ chmod 744 deploy.sh
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -l deploy.sh
-rwxr--r--. 1 ec2-user ec2-user 20 Oct 26 19:17 deploy.sh
[ec2-user@ip-172-31-3-151 perm-lab]$ ./deploy.sh
Deploying...
[ec2-user@ip-172-31-3-151 perm-lab]$ 
```

**Owner read+write+execute = 7** (read 4 + write 2 + execute 1). `744` = `rwxr--r--`: only the owner can execute. `700` would also hide it from everyone else.

| Permission | Value |
|---|---|
| read `r` | 4 |
| write `w` | 2 |
| execute `x` | 1 |

---

## 4. Create `shared/`: owner full access, group read and execute, others nothing (numeric).

```
mkdir shared
chmod 750 shared
ls -ld shared
```
```
[ec2-user@ip-172-31-3-151 perm-lab]$ mkdir shared
[ec2-user@ip-172-31-3-151 perm-lab]$ chmod 750 shared
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -ld shared
drwxr-x---. 2 ec2-user ec2-user 40 Oct 26 19:18 shared
```

`750` = `rwxr-x---`. On a folder, `r` lists the files and `x` lets you enter it (`cd`), so the group can look inside but not create or delete files.

---

## 5. Change the owner of `secret.txt` to `alice` and the group to `devops-team`.

```
sudo chown alice:devops-team secret.txt
ls -l secret.txt
```
```
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -l secret.txt
-rw-------. 1 alice devops-team 21 Oct 26 19:14 secret.txt
```

`chown` needs sudo: a normal user can't give their files away to someone else.

---

## 6. Create `project/` with 3 files. Change ownership of everything to `alice:devops-team` in one command.

```
mkdir project
touch project/app.py project/config.yml project/README.md
sudo chown -R alice:devops-team project
ls -lR project
```
```
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -lr project
total 0
-rw-r--r--. 1 ec2-user ec2-user 0 Oct 26 19:58 config.yml
-rw-r--r--. 1 ec2-user ec2-user 0 Oct 26 19:58 app.py
-rw-r--r--. 1 ec2-user ec2-user 0 Oct 26 19:58 README.md
[ec2-user@ip-172-31-3-151 perm-lab]$ sudo chown -R alice:devops-team project
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -lr project
total 0
-rw-r--r--. 1 alice devops-team 0 Oct 26 19:58 config.yml
-rw-r--r--. 1 alice devops-team 0 Oct 26 19:58 app.py
-rw-r--r--. 1 alice devops-team 0 Oct 26 19:58 README.md
[ec2-user@ip-172-31-3-151 perm-lab]$ 
```

`-R` (recursive) changes the folder and everything inside it in one command.

---

## 7. Check the permissions on `/etc/shadow`. Why is it set that way?

```
ls -l /etc/shadow
```
```
[ec2-user@ip-172-31-3-151 perm-lab]$ ls -l /etc/shadow
----------. 1 root root 1044 Oct 26 19:07 /etc/shadow
```

`/etc/shadow` holds every user's **password hash**. On Amazon Linux and RHEL it is `----------` (000), owned by root: no normal user can read it. root can still read it because root bypasses file permissions. If anyone could read the hashes, they could copy them and try to crack the passwords offline.

### Clean up
```
cd ~ && sudo rm -rf /tmp/perm-lab
```
