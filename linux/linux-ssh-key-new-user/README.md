## Assignment — Key-Based SSH for a New User

## 1. Create a user `deploy` with no password.

```
sudo useradd deploy
sudo passwd -S deploy
```
```
[ec2-user@ip-172-31-3-151 ~]$ sudo useradd deploy
[ec2-user@ip-172-31-3-151 ~]$ sudo passwd -S deploy
deploy LK 2026-10-26 0 99999 7 -1 (Password locked.)
[ec2-user@ip-172-31-3-151 ~]$ 
```

Without a password the account is **locked for password login** (`passwd -S` shows it as locked). It can still log in with an SSH key, which is what a deploy account should use.

---

## 2. Generate a new SSH key pair for this user on my local machine.

On the laptop:

```
ssh-keygen -t ed25519 -f ~/.ssh/deploy_key
ls -l ~/.ssh/deploy_key*
```
```
❯ ls -l ~/.ssh/deploy_key*
-rw-------  1 sivajyothipamarthy  staff  444 Oct 26 21:14 /Users/sivajyothipamarthy/.ssh/deploy_key
-rw-r--r--  1 sivajyothipamarthy  staff  124 Oct 26 21:14 /Users/sivajyothipamarthy/.ssh/deploy_key.pub
```

- `deploy_key` = private key, stays on my laptop (never in this repo)
- `deploy_key.pub` = public key, goes to the server

---

## 3. Set up `.ssh/` and `authorized_keys` for `deploy` with the correct permissions and ownership.

Copy the public key line on the laptop:

```
cat ~/.ssh/deploy_key.pub
```

On the server:

```
sudo mkdir -p /home/deploy/.ssh
echo "<paste the deploy_key.pub line>" | sudo tee /home/deploy/.ssh/authorized_keys
sudo chmod 700 /home/deploy/.ssh
sudo chmod 600 /home/deploy/.ssh/authorized_keys
sudo chown -R deploy:deploy /home/deploy/.ssh
sudo ls -la /home/deploy/.ssh
```
```
[ec2-user@ip-172-31-3-151 ~]$ sudo chmod 700 /home/deploy/.ssh
[ec2-user@ip-172-31-3-151 ~]$ sudo chmod 600 /home/deploy/.ssh/authorized_keys
[ec2-user@ip-172-31-3-151 ~]$ sudo chown -R deploy:deploy /home/deploy/.ssh
[ec2-user@ip-172-31-3-151 ~]$ sudo ls -la /home/deploy/.ssh
total 4
drwx------. 2 deploy deploy  29 Oct 26 20:20 .
drwx------. 3 deploy deploy  74 Oct 26 20:19 ..
-rw-------. 1 deploy deploy 124 Oct 26 20:20 authorized_keys
[ec2-user@ip-172-31-3-151 ~]$ 
```

| Path | Permission | Owner |
|---|---|---|
| `/home/deploy/.ssh` | `700` (`drwx------`) | `deploy:deploy` |
| `/home/deploy/.ssh/authorized_keys` | `600` (`-rw-------`) | `deploy:deploy` |

sshd refuses keys if these files are owned by someone else or writable by others. That is the most common cause of `Permission denied (publickey)` for a new user.

---

## 4. Connect as `deploy` using the private key.

```
ssh -i ~/.ssh/deploy_key deploy@<public-ip>
whoami
```
```
[deploy@ip-172-31-3-151 ~]$ whoami
deploy
[deploy@ip-172-31-3-151 ~]$ 
```

---

## 5. Try connecting without specifying the key. What happens and why?

```
ssh deploy@<public-ip>
```
```
<paste output>
```

Without `-i`, ssh only offers my **default** keys (`~/.ssh/id_ed25519`, `~/.ssh/id_rsa` …). None of them is in deploy's `authorized_keys`, so the server rejects them. It may then fall back to a password, but deploy has none, so the login fails with `Permission denied`.

(If the key was added to the ssh-agent with `ssh-add`, ssh offers it automatically and the login works.)

---

## 6. Disable password authentication. Verify a password login is rejected. Why does it matter for production?

Find every place the setting is defined, set it to `no`, test the config, restart:

```
sudo grep -ri passwordauthentication /etc/ssh/sshd_config /etc/ssh/sshd_config.d/
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config         # PasswordAuthentication no
sudo sshd -t
sudo systemctl restart sshd
```

Test from the laptop, forcing ssh to skip keys:

```
ssh -o PubkeyAuthentication=no alice@<public-ip>
```
```
❯ ssh -o PubkeyAuthentication=no alice@18.60.107.113
alice@18.60.107.113: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

The server answers `Permission denied (publickey…)` without even asking for a password.

### Why it matters for production
- Bots try passwords on every server with port 22 open, all day
- Passwords can be guessed, reused or leaked; a private key can't be guessed
- With keys, access is given and removed per person by editing `authorized_keys`
- I keep my own SSH session open while testing, so a mistake can't lock me out
