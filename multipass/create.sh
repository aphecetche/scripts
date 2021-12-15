cp cloud-init.yaml.ini cloud-init.yaml
#echo "ssh_authorized_keys: $(cat $HOME/.ssh/id_rsa.pub)" >> cloud-init.yaml

multipass launch --name mea \
 --cpus 4 \
 --mem 8G \
 --disk 128G \
 --cloud-init ./cloud-init.yaml \
 --timeout 600
