#!/bin/sh
# This script shows all git directories (starting from some dir)
# that have (unpushed) local modifications

dir=${1:-$(pwd)}

function checkdir() {
        pushd $1 > /dev/null
        cd ..
        # Fetch remote refs silently
        git fetch --quiet --all --prune
        git status -bs | grep "^##" | grep ahead > /dev/null
        if [[ $? -eq 0 ]]; then
                echo "AHEAD"
        else
                lines=$(git status -bs | grep -v "^##" | wc -l)
                if [[ $lines -gt 0 ]]; then
                        echo "LOCAL MODS"
                fi
        fi

        # Loop through local branches
        for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
          # Check if a remote tracking branch exists
          if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
            echo "🌱 $branch (no remote branch found)"
          fi
        done

        popd > /dev/null
}


for d in $(find $dir -not \( -path $HOME/Library -prune \) -not \( -path $HOME/alice/sw -prune \) -not \( -path $HOME/CERNBox -prune \) -not \( -path $HOME/ownCloud -prune \) -type d -name .git); do
        r=$(checkdir $d)
        if [[ ${#r} -eq 0 ]]; then
                r="CLEAN"
        fi
        if [[ ${r} != "CLEAN" ]]; then
                echo "dir=$d R=$r"
        fi
done

