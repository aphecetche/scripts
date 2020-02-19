#!/bin/sh

file=$1
echo "file=$file"

base=${ALIBUILD_WORK_DIR/sw/}
file=${file/${base}/}

what=$(echo $file | tr "/" "\n" | head -1)

echo "what=$what"

cd $ALIBUILD_WORK_DIR/BUILD/$what-latest/$what

ninja

