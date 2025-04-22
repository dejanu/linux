
### Stop cat abuse (refers to pointless uses of cat)

* It's common to see pipelines that use `cat` to open a single file and provide it to the standard input of another program, for example `wc -l`. 
This is usually unnecessary because the other program already accepts filename arguments and could open and read the file itself.

```bash
# concatenate files and print to sdtout
cat post.txt | wc -l
cat post.txt | grep by

# print line counts for file
wc -l post.txt

# print line matchin pattern
grep by post.txt

# no unnecesarry pipes just input redirect to desired cmd i.e. grep
grep by <post.txt
```

### Globbing

* Searching for files using widlcard expansion

```bash
# DONTS
ls -ltr | grep md

# DO *.md mathces any sequence of characters
ls *.md
```

### OS is a stack of methaphors and abstractions

* View various system calls (requests to the kernel) 
```bash
which ls
file $(!!)
strace -c ls *.md
```