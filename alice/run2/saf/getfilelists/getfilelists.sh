#!/bin/sh

export machine=$(hostname -s)
output=$machine.files.list
legacy=${1:-no}

echo "#!/bin/sh" > $output

if [[ "$legacy" == "yes" ]]; then
  find /data -name *.root -type f -exec stat -Lc "%s %Y %n" {} \; | awk '{print strftime("%a %d.%m.%Y %H:%M:%S ",$2)  $1 " " $3 " SAF-" ENVIRON["machine"] }' > $output
else
  find /data -name *.root -type f -exec stat -Lc "%s %Y %X %n" {} \; | awk '{print $2 " " $3 " " $1 " " $4 " SAF-" ENVIRON["machine"] }' > $output
fi


