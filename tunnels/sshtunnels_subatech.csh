#!/bin/tcsh

#xname 'ssh tunnels to subatech'

echo "MailRelay at 6001"
echo "Pointeuse à localhost:6088/eTPTA"
echo "Web at 6080"

ssh -fN4 -X -l aphecete -L 6001:mailrelay-subatech.in2p3.fr:25 -L 6080:www-subatech.in2p3.fr:80 -L 6088:pointwin.emn.fr:8080 nansl1.in2p3.fr

