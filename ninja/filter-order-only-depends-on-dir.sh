#!/usr/bin/env sh


file=$1
while IFS= read -r line
do
  if [[ "$line" =~ RERUN_CMAKE ]]; then
    a=1
  else 
       if [[ "$line" =~ ^build ]] \
         && [[ "$line" =~ "||" ]] \
         && [[ "$line" =~ \.dir$ ]]; then
         a=${line/||/|}
         echo "$a" | cut -d '|' -f 1
         echo "$a" | cut -d '|' -f 2 >&2
       else 
         echo "$line"
       fi
  fi
        

done <"$file"

