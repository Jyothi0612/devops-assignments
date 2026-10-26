## Assignment — Vim Editor

## 1. Create practice.txt with vim, add 10 lines, save and exit

```
vim practice.txt
```
- `i` → insert mode, then type the 10 lines
- `Esc` → back to normal mode
- `:wq` → write (save) and quit

### Verify
```
❯ cat -n practice.txt
     1        roboshop frontend runs nginx on port 80
     2        roboshop catalogue runs nodejs on port 8080
     3        roboshop user runs nodejs on port 8080
     4        roboshop cart runs nodejs on port 8080
     5        roboshop shipping runs java on port 8080
     6        roboshop payment runs python on port 8080
     7        roboshop dispatch runs golang with no port
     8        roboshop mongodb listens on port 27017
     9        roboshop redis listens on port 6379
    10        roboshop mysql listens on port 3306
```
`cat -n` shows line numbers, so it's easy to check there are 10 lines.

---

## 2. Line numbers, jump to line 7, delete line 3, save and exit

```
vim practice.txt
```
- `:set nu` → show line numbers
- `7G` (or `:7`) → jump to line 7
- `:3` → go to line 3
- `dd` → delete the current line (line 3)
- `:wq` → save and exit

### Verify
```
❯ cat -n practice.txt
     1        roboshop frontend runs nginx on port 80
     2        roboshop catalogue runs nodejs on port 8080
     3        roboshop cart runs nodejs on port 8080
     4        roboshop shipping runs java on port 8080
     5        roboshop payment runs python on port 8080
     6        roboshop dispatch runs golang with no port
     7        roboshop mongodb listens on port 27017
     8        roboshop redis listens on port 6379
     9        roboshop mysql listens on port 3306
```
The `user` line (old line 3) is gone, and the file now has 9 lines.

---

## 3. Search for a word, move through matches, clear the highlight

```
vim practice.txt
```
- `/nodejs` → search forward for `nodejs`, then Enter
- `n` → next match
- `N` → previous match
- `:noh` → clear the search highlight (short for `:nohlsearch`)
- `:q` → quit (nothing changed, so no save needed)

`?nodejs` searches backwards instead of forwards.

---

## 4. Replace every occurrence of a word in one command

```
vim practice.txt
```
- `:%s/roboshop/fika/g` → replace `roboshop` with `fika` everywhere
- `:wq` → save and exit

| Part | Meaning |
|---|---|
| `%` | every line in the file (without it, only the current line) |
| `s` | substitute |
| `/roboshop/fika/` | find `roboshop`, replace with `fika` |
| `g` | every match on a line, not just the first |

Vim shows how many were changed, e.g. `9 substitutions on 9 lines`.

### Verify
```
❯ cat -n practice.txt
     1        fika frontend runs nginx on port 80
     2        fika catalogue runs nodejs on port 8080
     3        fika cart runs nodejs on port 8080
     4        fika shipping runs java on port 8080
     5        fika payment runs python on port 8080
     6        fika dispatch runs golang with no port
     7        fika mongodb listens on port 27017
     8        fika redis listens on port 6379
     9        fika mysql listens on port 3306
```

`:%s/roboshop/fika/gc` does the same but asks before each change (`y` / `n`).

---

## 5. Go to the bottom, add 3 lines, undo the last one, save

```
vim practice.txt
```
- `G` → jump to the last line
- `o` → open a new line below and enter insert mode, type line 1, `Esc`
- `o` → type line 2, `Esc`
- `o` → type line 3, `Esc`
- `u` → undo the last change, which removes line 3 only
- `:wq` → save and exit

Lines added:
```
fika rabbitmq listens on port 5672
fika basket runs python on port 8080
fika kitchen runs golang with no port    ← removed by u
```

Each line is added in its own insert (`o` … `Esc`), because vim counts one
insert session as one change. Typing all 3 lines in one insert and pressing `u`
would remove all 3.

### Verify
```
❯ cat -n practice.txt
     1        fika frontend runs nginx on port 80
     2        fika catalogue runs nodejs on port 8080
     3        fika cart runs nodejs on port 8080
     4        fika shipping runs java on port 8080
     5        fika payment runs python on port 8080
     6        fika dispatch runs golang with no port
     7        fika mongodb listens on port 27017
     8        fika redis listens on port 6379
     9        fika mysql listens on port 3306
    10        fika rabbitmq listens on port 5672
    11        fika basket runs python on port 8080
```
11 lines: 9 from before + 2 that were kept.

`Ctrl+r` redoes what `u` undid.

---

## 6. Copy one line and paste it 5 times in a single step

```
vim practice.txt
```
- `gg` → go to line 1
- `yy` → copy the whole line
- `5p` → paste it 5 times below the cursor
- `:wq` → save and exit

**The command: `yy` then `5p`.** A number before a vim command repeats it,
so `5p` = paste 5 times.

### Verify
```
❯ cat -n practice.txt
     1        fika frontend runs nginx on port 80
     2        fika frontend runs nginx on port 80
     3        fika frontend runs nginx on port 80
     4        fika frontend runs nginx on port 80
     5        fika frontend runs nginx on port 80
     6        fika frontend runs nginx on port 80
     7        fika catalogue runs nodejs on port 8080
     8        fika cart runs nodejs on port 8080
     9        fika shipping runs java on port 8080
    10        fika payment runs python on port 8080
    11        fika dispatch runs golang with no port
    12        fika mongodb listens on port 27017
    13        fika redis listens on port 6379
    14        fika mysql listens on port 3306
    15        fika rabbitmq listens on port 5672
    16        fika basket runs python on port 8080
```
16 lines: the original line 1 + 5 copies below it.

`p` pastes below the cursor, `P` above it.