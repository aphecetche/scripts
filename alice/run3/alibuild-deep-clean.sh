#!/bin/sh
#
# clean sw directory

if [[ $ALIBUILD_WORK_DIR ]]; then
  pushd $ALIBUILD_WORK_DIR
  find . -not \( -path ./MIRROR -prune \) -type d -depth 1 -exec rm -rf {} \;
  popd
else
  echo "ALIBUILD_WORK_DIR not defined"
fi
