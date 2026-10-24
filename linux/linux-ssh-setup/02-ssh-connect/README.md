2. Connect to your EC2 instance using SSH. Confirm you are connected by checking the hostname, current directory, and logged-in username.

### Connect to the instance with SSH

```
❯ ssh -i daws-92s ec2-user@18.60.212.15
The authenticity of host '18.60.212.15 (18.60.212.15)' can't be established.
ED25519 key fingerprint is: SHA256:kIagEp1kRRnYB85+6AKr0oD2VuBJaIIxnmBSvZwb+AI
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '18.60.212.15' (ED25519) to the list of known hosts.
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
[ec2-user@ip-172-31-3-60 ~]$ whoami
ec2-user
[ec2-user@ip-172-31-3-60 ~]$ pwd
/home/ec2-user
[ec2-user@ip-172-31-3-60 ~]$ hostname
ip-172-31-3-60.ap-south-2.compute.internal
```
- On the first connection SSH asks to trust the server's host key
(`ED25519 key fingerprint ...`). After `yes`, it is saved in `~/.ssh/known_hosts`
and not asked again for this IP.

┌────────────────────────┬───────────────────┬──────────────────────────┬─────────────────────────────────────────┐
│          File          │       Where       │          Holds           │                 Answers                 │
├────────────────────────┼───────────────────┼──────────────────────────┼─────────────────────────────────────────┤
│ ~/.ssh/known_hosts     │ your laptop       │ the server's fingerprint │ "Is this the same server as last time?" │
├────────────────────────┼───────────────────┼──────────────────────────┼─────────────────────────────────────────┤
│ ~/.ssh/authorized_keys │ the server        │ your public key          │ "Is this person allowed to log in?"     │
└────────────────────────┴───────────────────┴──────────────────────────┴─────────────────────────────────────────┘

- `ec2-user` is the default user on Amazon Linux
- `/home/ec2-user` is its home folder
- the hostname is built from the private IP (`172.31.3.60`), and `ap-south-2` confirms the Hyderabad region



