## Assignment — wget, curl, and Pipes

```
https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt
```

## 1. Download the following file to your EC2 instance and save it as `session-notes.txt`:

```
wget -O session-notes.txt https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt
```

```
[ec2-user@ip-172-31-3-151 ~]$ wget -O session-notes.txt https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt
--2026-10-25 21:54:09--  https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.108.133, 185.199.110.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2993 (2.9K) [text/plain]
Saving to: ‘session-notes.txt’

session-notes.txt                         100%[===================================================================================>]   2.92K  --.-KB/s    in 0s      

2026-10-25 21:54:10 (36.8 MB/s) - ‘session-notes.txt’ saved [2993/2993]
```

`-O` (capital O) sets the name of the saved file. Without it, wget keeps the original name `session-02.txt`.

```
ls -l session-notes.txt

[ec2-user@ip-172-31-3-151 ~]$ ls -l session-notes.txt
-rw-r--r--. 1 ec2-user ec2-user 2993 Oct 25 21:54 session-notes.txt
```
```
head -5 session-notes.txt

[ec2-user@ip-172-31-3-151 ~]$ head -5 session-notes.txt
Regions and AZ

HYD -> Region
North HYD -> AZ-1
South HYD -> AZ-2
```

---

## 2. Fetch the file with `curl` and count its lines, without saving it.

```
curl -s https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt | wc -l
```
```
134
```

`curl` prints the file to the screen (nothing is saved), `|` passes it to `wc -l`, which counts the lines. `-s` hides curl's progress meter.

---

## 3. Fetch the file and print only lines containing `Linux`, in one command.

```
curl -s https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt | grep -w Linux
```
```
[ec2-user@ip-172-31-3-151 ~]$ curl -s https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt | grep -w Linux
OS -> Embedded Linux -> Bridge between user and hardware
Windows vs Linux
User interface is heavy in windows -> slow, Linux is super speed
Linux is more secure than windows
        Linux is open source -> almost free
Linux -> Kernel
Linus Torvalds -> Git, Linux
Linux -> using C language from the scratch -> Unix Principles
Linux is kernel
Redhat Enterprise Linux -> RHEL == centos == AWS Linux == fedora ==> RedHat family
AWS Linux 2023 -> 
SSH -> Secure shell -> protocol to connect Linux servers terminal access
Linux commands
```

`curl` fetches the file and `grep -w Linux` keeps only the lines that contain the word `Linux`.
grep is case-sensitive, so lines with lowercase `linux` are not shown. `grep -i linux` would show them too (15 lines).

---

## 4. Run this and explain what `$NF` means.

```
echo "https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt" | awk -F "/" '{print $NF}'
```
```
session-02.txt
```

`-F "/"` splits the line at every `/`. `NF` is the number of fields (9 here), so `$NF` is the last field, which is the filename.

---

## 5. Fetch the file, filter lines containing `ssh`, then count how many matched, using two pipes.

```
curl -s https://raw.githubusercontent.com/daws-90s/notes/refs/heads/main/session-02.txt | grep -w ssh | wc -l
```
```
5
```

`curl` fetches the file, `grep` keeps only the lines with `ssh`, and `wc -l` counts them.
grep is case-sensitive, so `grep -i ssh` would also count the 2 lines that use uppercase `SSH` (7 total).