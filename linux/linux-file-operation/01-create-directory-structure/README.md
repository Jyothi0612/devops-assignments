1. Create the following directory structure using a single command:
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
