
file=$1
dir=`dirname $1`

if [ ! -w $dir ]; then
  echo "Have no write access to $dir. Exiting"
  exit
fi

if [ ! -f "$file" ]; then
  touch $file
fi

/usr/bin/open -a '/Applications/Aquamacs Emacs.app' $file



