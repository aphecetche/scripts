#!/bin/sh

export machine=$(hostname -s)
output=$machine.filelist.txt

echo "#!/bin/sh" > $output

find /data -name *.root -type f -exec stat -c "%s %Y %n" {} \; | awk '{print strftime("%a %d.%m.%Y %H:%M:%S ",$2)  $1 " " $3 " SAF-" ENVIRON["machine"] }' > $output

