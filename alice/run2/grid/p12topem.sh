#!/bin/sh
#
# convert a .p12 certificate into a pair userkey.pem usercert.pem, directly into the $HOME/.globus directory
#

destdir=${2:-$HOME/.globus}
#destdir=`pwd`

rm $destdir/user*.pem

openssl pkcs12 -nocerts -nodes -in $1 -out $destdir/userkey.pem

openssl pkcs12 -clcerts  -nokeys -in $1 -out $destdir/usercert.pem

chmod 0400 $destdir/userkey.pem
chmod 0644 $destdir/usercert.pem

# to show content of certificate use : 
# openssl x509 -text -noout -in usercert.pem
