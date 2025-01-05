
<div align="center">
    <h1>Shell Tools</h1>
    <img alt="Shell Badge" src="https://img.shields.io/badge/Bash-ZSH-black?style=for-the-badge&logo=gnubash&logoColor=ffffff">
</div>

#
Here are some funcions to work on a shell environment. Some of them have been created in order to accomplish the challenges from [Over The Wire project](https://overthewire.org/).


## Table of contents

1. [Cesar](#cesar)

### Cesar
Function to encode or decode text strings and files that have been previously encoded using based-on-Caesar algorithm such as rot13. The code is slightly different in both `zsh` and `bash` shells due to both of their diferences. However, the execution of the function works the same way. The source code can be found in folders [bash](https://github.com/mguzman14/tools/blob/main/shell/bash/cesar.sh) and [zsh](https://github.com/mguzman14/tools/blob/main/shell/zsh/cesar.zsh) respectively.

The function accepts the following **parameters**:
- `-t`: input type. It must be file or str (for string text)
- `-r`: number of positions that each letter has to rotate to encode or decode the file or text string. Only numbers from 0 to 25 are allowed. Values out of this range may cause a non-successful execution of the process (`echo $? = 1`)
- `-i`: input to be encoded or decoded. It can be a text string in single quotes or an absolute path of a file.
- `-h`: show help

Here are some **examples** of use:

- Using a text string as input
```bash
cesar -t str -r 13 -i 'Gur cnffjbeq vf 7k16JArUVv5LxVuJfsSVdbbtaHGlw9D4'
```

- Using a file as input
```bash
cesar -t file -r 13 -i /etc/hosts
```
- Looping 25 times over the function to print all the possible results:
```bash
for i in $(seq 1 25); do 
    cesar -t str -r $i -i 'Gur cnffjbeq vf 7k16JArUVv5LxVuJfsSVdbbtaHGlw9D4'; 
done
```