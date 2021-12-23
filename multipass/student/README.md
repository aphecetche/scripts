# Using multipass and spack to get a working environment

## Multipass installation

Head to [multipass](https://multipass.run) homepage and follow the instrutions there to install the multipass product.

## Virtual machine installation

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

It should take of the order of ten minutes (depending on your network connection speed) to complete.

Note that the public key hash will be different from the output above.

Check that the virtual machine has been created :

```shell
$ multipass list
Name                    State             IPv4             Image
qqbar2mumu              Running           172.16.81.14     Ubuntu 20.04 LTS
```

## Virtual machine usage to start a Jupyter Lab server

The main use case for that virtual machine is to launch a Jupyter Lab server ,
which can be done using the `start` convenience command that's defined in that
vm for you :

<details>
<summary>`multipass exec qqbar2mumu start`</summary>

```shell
$ multipass exec qqbar2mumu start
[I 2021-12-24 00:08:27.829 ServerApp] jupyterlab | extension was successfully linked.
[I 2021-12-24 00:08:27.859 LabApp] JupyterLab extension loaded from /home/ubuntu/spack/opt/spack/linux-ubuntu20.04-haswell/gcc-9.3.0/py-jupyterlab-3.2.1-veeoqqjxqx5un4b2oq3c2iispchd25cr/lib/python3.8/site
-packages/jupyterlab
[I 2021-12-24 00:08:27.859 LabApp] JupyterLab application directory is /home/ubuntu/spack/opt/spack/linux-ubuntu20.04-haswell/gcc-9.3.0/py-jupyterlab-3.2.1-veeoqqjxqx5un4b2oq3c2iispchd25cr/share/jupyter/l
ab
[I 2021-12-24 00:08:27.864 ServerApp] jupyterlab | extension was successfully loaded.
[I 2021-12-24 00:08:27.865 ServerApp] Serving notebooks from local directory: /home/ubuntu/nantes-m2-rps-exp/qqbar2mumu-2021
[I 2021-12-24 00:08:27.865 ServerApp] Jupyter Server 1.11.2 is running at:
[I 2021-12-24 00:08:27.865 ServerApp] http://172.16.81.14:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a
[I 2021-12-24 00:08:27.865 ServerApp]  or http://127.0.0.1:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a
[I 2021-12-24 00:08:27.865 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 2021-12-24 00:08:27.870 ServerApp]

    To access the server, open this file in a browser:
        file:///home/ubuntu/.local/share/jupyter/runtime/jpserver-21489-open.html
    Or copy and paste one of these URLs:
        http://172.16.81.14:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a
     or http://127.0.0.1:8888/lab?token=282695122119c7cd9c16e096303a3290e387a9792bbafa8a

```

</details>

Click (or copy and paste, depending on your terminal capabilities) on the `http://172.../lab?token=....`  to enter a fully functional Jupyter Lab server which gets all (or almost all) the Python modules you'll need to complete the project.

## Doing more with the virtual machine

Occasionally you may need to use it for other things (e.g. to download the
 data), in which case you'll need to "enter" the vm :

<details>
<summary>`multipass shell qqbar2mumu`</summary>

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

</details>

### Using python packages

If you want to use Python packages the first thing you'll probably want to do is to enter the `qqbar2mumu-2021` environment and load the corresponding packages :

```shell
cd ~/nantes-m2-rps-exp/qqbar2mumu-2021
spacktivate . 
spack load qqbar2mumu-2021
```

### Downloading data

If you just want to download the full (real) data set, do :

```shell
cd ~/nantes-m2-rps-exp/qqbar2mumu-2021
./copy-data-locally.sh
```
