#!/bin/sh

target_link=spack-build-latest

root=$HOME/alice

file=$root/$1

# watchman log error "spack-build.sh file=$file"

dir=$(dirname $file)
cd $dir

if [[ -d $file ]]; then
  # watchman log error "spack-build.sh creating link into dir=$dir"
  ln -sfh $file $target_link
else
  # the directory is being deleted
  # if the latest link exists, remove it and try to find another
  # spack-build-[a-z0-9]{7} target to link to
  if [[ -L $target_link ]]; then
     # watchman log error "spack-build.sh delete link $target_link in dir=$dir"
     rm $target_link
     previous=$(find -E . -regex ".*spack-build-[a-z0-9]{7}$" -type d -depth 1 -exec stat -f "%a %N" {} \; | sort -n | cut -d ' ' -f 2 | tail -1) 
      if [[ ! -z "$previous" ]] ; then
        # watchman log error "previous is $previous"
        ln -shf $previous $target_link
        if [[ -f $target_link/compile_commands.json ]]; then
            touch $target_link/compile_commands.json
        fi
      fi
  fi
fi
