3. Count how many servers are `running`.

```
grep -w running servers.txt | wc -l
```
```
3
```
`grep` finds the running lines, `|` passes them to `wc -l`, which counts lines.

Shorter, with grep's own count option:
```
grep -wc running servers.txt
```
```
3
```