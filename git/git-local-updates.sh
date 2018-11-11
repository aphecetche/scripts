#!/bin/sh
# This script shows all git directories (starting from some dir)
# that have (unpushed) local modifications

dir=${1:-$(pwd)}

function checkdir() {
        pushd $1 > /dev/null
        cd ..
        git status -bs | grep "^##" | grep ahead > /dev/null
        if [[ $? -eq 0 ]]; then
                echo "AHEAD"
        else
                lines=$(git status -bs | grep -v "^##" | wc -l)
                if [[ $lines -gt 0 ]]; then
                        echo "LOCAL MODS"
                fi
        fi
        popd > /dev/null
}

for d in $(find $dir -name .git -type d); do
        r=$(checkdir $d)
        if [[ ${#r} -eq 0 ]]; then
                r="CLEAN"
        fi
        if [[ ${r} != "CLEAN" ]]; then
                echo "dir=$d R=$r"
        fi
done

