## Assignment — Linux User Management

## 1. Create a user `alice`. What primary group was automatically created for her?

```
sudo useradd alice
id alice
```
```
uid=1001(alice) gid=1001(alice) groups=1001(alice)
```

Linux creates a group with the same name as the user, `alice`, and makes it her primary group. This is called a user private group: files she creates belong to her own group, not a shared one.

---

## 2. Set a password for `alice`. Configure the server to allow password-based SSH and connect as `alice`.

```
sudo passwd alice
```

Password login is turned off by default. The setting can be in the main file **and** in `sshd_config.d/`, and the first value sshd reads wins, so check both:

```
sudo grep -ri passwordauthentication /etc/ssh/sshd_config /etc/ssh/sshd_config.d/
```
```
[ec2-user@ip-172-31-3-151 ~]$ sudo grep -ri passwordauthentication /etc/ssh/sshd_config /etc/ssh/sshd_config.d/
/etc/ssh/sshd_config:# Explicitly disable PasswordAuthentication. By presetting it, we
/etc/ssh/sshd_config:PasswordAuthentication no
/etc/ssh/sshd_config:# PasswordAuthentication.  Depending on your PAM configuration,
/etc/ssh/sshd_config:# PAM authentication, then enable this but set PasswordAuthentication
```

Set it to `yes` everywhere it says `no`, then test the config and restart sshd:

```
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sshd -t
sudo systemctl restart sshd
```

From my laptop:

```
ssh alice@18.60.107.113
```
```
ssh alice@18.60.107.113
The authenticity of host '18.60.107.113 (18.60.107.113)' can't be established.
ED25519 key fingerprint is: SHA256:hiuCu3likI6Uz1n9gkrXlOGBwZqYgkVjGHGhAD1rjEE
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '18.60.107.113' (ED25519) to the list of known hosts.
alice@18.60.107.113's password: 
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
[alice@ip-172-31-3-151 ~]$ 
```

`sshd -t` checks the config for errors before the restart. A broken config with a restart can lock everyone out.

---

## 3. Create a group `devops-team`. Add `alice` as a secondary member. Verify.

```
sudo groupadd devops-team
sudo usermod -aG devops-team alice
id alice
```
```
uid=1001(alice) gid=1001(alice) groups=1001(alice),1002(devops-team)
```

- `-G` sets the secondary groups
- `-a` means append. Without `-a`, `usermod -G` would remove alice from every other secondary group.

---

## 4. Create a user `bob`. Add both `alice` and `bob` to `devops-team`.

```
sudo useradd bob
sudo usermod -aG devops-team bob
getent group devops-team
```
```
[ec2-user@ip-172-31-3-151 ~]$ getent group devops-team
devops-team:x:1002:alice,bob
```

`alice` is already a member from task 3. `getent group` lists every member of the group in the last field.

---

## 5. Give `alice` sudo access. Verify she can run commands as root.

On Amazon Linux and RHEL, members of the `wheel` group can use sudo (`%wheel ALL=(ALL) ALL` in `/etc/sudoers`).

```
sudo usermod -aG wheel alice
sudo su - alice
sudo whoami
```
```
[ec2-user@ip-172-31-3-151 ~]$ id alice
uid=1001(alice) gid=1001(alice) groups=1001(alice),10(wheel),1002(devops-team)
[ec2-user@ip-172-31-3-151 ~]$ sudo su - alice
Last login: Mon Oct 26 18:37:09 UTC 2026 from 37.250.204.81 on pts/1
[alice@ip-172-31-3-151 ~]
```

`sudo whoami` prints `root`. Group changes apply at a new login, which is why I switch to alice with `su -` after adding her.

---

## 6. Remove `alice`'s sudo access. Confirm she can no longer run sudo commands.

```
sudo gpasswd -d alice wheel
sudo su - alice
sudo whoami
```
```
[alice@ip-172-31-3-151 ~]$ sudo gpasswd -d alice wheel
Removing user alice from group wheel
[alice@ip-172-31-3-151 ~]$ sudo su - alice
Last login: Mon Oct 26 18:54:37 UTC 2026 on pts/2
[alice@ip-172-31-3-151 ~]$ sudo whoami
[sudo] password for alice: 
alice is not in the sudoers file.
[alice@ip-172-31-3-151 ~]$ 
```

sudo now refuses with `alice is not in the sudoers file`, and the attempt is logged.

---

## 7. Allow only `devops-team` to run `useradd` and `usermod`, nothing else.

Always edit sudo rules with `visudo`: it checks the syntax before saving, and a broken sudoers file can block all sudo access. I put the rule in its own file:

```
sudo visudo -f /etc/sudoers.d/devops-team
```
```
%devops-team ALL=(root) /usr/sbin/useradd, /usr/sbin/usermod
```

- `%devops-team` = the group (`%` means group)
- `ALL=(root)` = on any host, run as root
- full paths are required (`which useradd` shows `/usr/sbin/useradd`)

### Verify
```
sudo -l -U bob
```
```
[ec2-user@ip-172-31-3-151 ~]$ sudo -l -U bob
Matching Defaults entries for bob on ip-172-31-3-151:
    !visiblepw, always_set_home, match_group_by_gid, always_query_group_plugin, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS",
    env_keep+="MAIL QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE", env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep+="LC_MONETARY LC_NAME
    LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/var/lib/snapd/snap/bin

User bob may run the following commands on ip-172-31-3-151:
    (root) /usr/sbin/useradd, /usr/sbin/usermod
```

As `bob`, `sudo useradd test1` works, but `sudo cat /etc/shadow` is refused.
