## Assignment — Linux and SSH Setup

1. Launch an Amazon Linux 2023 EC2 instance in HYD region. Generate an SSH key pair. What is the difference between the two files created?

### Enable the Hyderabad region 
1. AWS console → click your account name → Account
2. Scroll to AWS Regions
3. Find Asia Pacific (Hyderabad) ap-south-2 → Enable
4. Status changes from Enabling to Enabled in a few minutes.

### Generate the key pair (on my laptop)
ssh-keygen -f daws-92s

❯ ls -l
total 16
-rw-------  1 sivajyothipamarthy  staff  444 Oct 24 20:12 daws-92s
-rw-r--r--  1 sivajyothipamarthy  staff  124 Oct 24 20:12 daws-92s.pub

### Import the key and launch the instance
1. Switch region to Asia Pacific (Hyderabad)
2. EC2 → Network & Security → Key Pairs → Actions → Import key pair → paste `daws-92s.pub`
3. Launch instance: Amazon Linux 2023, t3.micro, key pair `daws-92s`

![alt text](image.png)

- `daws-92s` → private key. It stays on my laptop and is never shared.
  Permissions are `-rw-------` (only I can read it). I use it to log in:
  `ssh -i daws-92s ec2-user@<public-ip>`

- `daws-hyd.pub` → public key. It goes on the server, in
  `~/.ssh/authorized_keys` of the user I log in as. It's safe to share.
  AWS puts it there automatically when I import it as a key pair and select it while launching the instance.

When I connect, the server checks that my private key matches the public key in `authorized_keys`. Only then does it let me in. 