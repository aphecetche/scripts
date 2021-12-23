# Using multipass to create a Spack build cache

Create a multipass vm using :

```shell
$ ./create-vm.sh 
```

Check the instance has been created :

```shell
$ multipass list
Name                    State             IPv4             Image
m2exp                   Running           172.16.81.15     Ubuntu 20.04 LTS
```

Enter the instance :

```shell
$ multipass shell m2exp
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

📦ubuntu@m2exp:~$
```

Activate the relevant Spack environment and install it :

```shell
$ cd ~/nantes-m2-rps-exp/qqbar2mumu-2021
📦ubuntu@m2exp:~/nantes-m2-rps-exp/qqbar2mumu-2021$

$ spack env activate . 
📦qqbar2mumu-2021ubuntu@m2exp:~/nantes-m2-rps-exp/qqbar2mumu-2021$

$ time spack install
...snip..
```

Note that the install stage _is_ a long process (2-3 hours) as everything is built from
and follow the lines below to install the packages, create a buildcache from
source. That's actually why we prepare a build cache so that the students will
not have to be exposed to such a large installation time.

A this point the `qqbar2mumu-2021` package and all its dependencies  have been
installed.

```shell
📦qqbar2mumu-2021ubuntu@m2exp:~/nantes-m2-rps-exp/qqbar2mumu-2021$ spack find
==> In environment /home/ubuntu/nantes-m2-rps-exp/qqbar2mumu-2021
==> Root specs
qqbar2mumu-2021@1.0.0

==> 173 installed packages
-- linux-ubuntu20.04-haswell / gcc@9.3.0 ------------------------
berkeley-db@18.1.40          py-decorator@5.1.0            py-pycparser@2.20
boost@1.75.0                 py-defusedxml@0.7.1           py-pygments@2.10.0
bzip2@1.0.8                  py-deprecation@2.1.0          py-pyparsing@3.0.6
...snip...

```

Next step is to "package" then into a build cache. For this a GPG
key is required (for signing the binaries)

```shell
$ spack gpg create "m2exp" "m2exp@example.com"
==> Pushing binary packages to file:///home/ubuntu/mirror/build_cache
...snip...
```

Each package is added to the build cache (this phase also takes some time
because of the signing part mainly) :

```shell
$ for ii in $(spack find --format "yyy {version} /{hash}" | 
              grep -v -E "^(develop^master)" | 
              grep "yyy" | 
              cut -f3 -d" ") 
  do 
      spack buildcache create --allow-root --force -d ~/mirror --only=package $ii 
  done 
```

For the build cache to be of any use, it then **must** be indexed :

```shell
$ spack buildcache update-index -d ~/mirror --keys
...
```

Finally the build cache (a subdirectory of the `mirror` one) is turned into an
archive to be transportable to other machines :

```shell
$ tar zvcf ~/mirror.tar.gz ~/mirror
```

Retrieve the archive of the buildcache :

```shell
$ multipass transfer m2exp:mirror.tar.gz mirror.tar.gz
```

Put that archive on some publicly available server (e.g. your cernbox with a
public shared link) and modify the `student/cloud-init.yaml.ini` file to
download that archive during the vm first boot.

If anything goes wrong and you want to start again :

```shell
multipass delete m2exp && multipass purge
```
