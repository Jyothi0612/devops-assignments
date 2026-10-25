2. Inside `batch-92s/`, create a file called `notes.txt`. Write three lines into it, then append two more. Read it to verify.

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