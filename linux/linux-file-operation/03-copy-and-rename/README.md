3. Copy `notes.txt` to `projects/` and rename the copy to `backup.txt`. Verify both exist.

From inside `batch-92s/` (`..` = the parent folder, `projects/`):
```
cp notes.txt ../backup.txt
```
`cp` copies and renames in one step: the copy goes to `projects/` with the new name.

### Verify both exist
```
ls -l notes.txt ../backup.txt

-rw-r--r--@ 1 sivajyothipamarthy  staff  142 Oct 25 16:47 ../backup.txt
-rw-r--r--@ 1 sivajyothipamarthy  staff  142 Oct 25 16:46 notes.txt