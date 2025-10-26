Deleting branches that were removed upstream (e.g. following an accepted merge request)

```shell
git fetch --prune && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -d
```
