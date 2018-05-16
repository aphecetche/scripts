convert cmake-configure-o2.sh in VSCode settings.json

add echo before cmake in script above and then :

```
. $HOME/github.com/aphecetche/scripts/cmake/cmake-configure-o2.sh | tr " " "\n" | grep "^-D" | awk '{ print "\"" $1"\","}' | sed s/-D//g | sed s/=/\":\"/g
```
