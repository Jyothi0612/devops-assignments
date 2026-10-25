5. Delete the `devops/` directory and everything inside it.

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