# Using multipass and spack to get a working environment

## multipass installation

## virtual machine installation

Execute the following command :

```shell
$ ./create-vm.sh
Launched: qqbar2mumu
==> Fetching file:///home/ubuntu/mirror/build_cache/_pgp/0BB2598DB7BB50156663C3C8625B32CA90BA8870.pub
gpg: key 625B32CA90BA8870: public key "Laurent Aphecetche (GPG created for Spack) <laurent.aphecetche@gmail.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg: inserting ownertrust of 6
```

It should take a few minutes (below 10 minutes, depending on your network connection speed)
 to complete.

Note that the public key hash will be different from the output above.

Check that the virtual machine has been created :

```shell
$ multipass list
Name                    State             IPv4             Image
qqbar2mumu              Running           172.16.81.14     Ubuntu 20.04 LTS
```

The main use case for that virtual machine is to launch a Jupyter Lab server ,
which can be done using the `start` convenience command that's defined in that
vm for you :

```shell
$ multipass exec start
```

Occasionally you may need to use it for other things (e.g. to download the
 data), in which case you'll need to "enter" the vm :

```shell
$ multipass shell qqbar2mumu
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information as of Thu Dec 23 17:20:14 CET 2021

 System load:  0.01              Processes:               169
 Usage of /:   3.3% of 61.86GB   Users logged in:         0
 Memory usage: 2%                IPv4 address for enp0s2: 172.16.81.15
 Swap usage:   0%


11 updates can be applied immediately.
4 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

📦qqbar2mumu-2021ubuntu@qqbar2mumu:~$
```

