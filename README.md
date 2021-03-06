Packaging Ansible as a single RPM for RHEL 6.4
==============================================

## Why?

[Ansible](https://github.com/ansible/ansible) is awesome. It'll make our deployments easier and consistent with each other. Unfortunately, the official Ansible RPM is in EPEL and depends on a bunch of other packages in EPEL and some features depend on other packages, etc. This is not ideal for environments where you want to minimize dependencies.

## Installing

Pre-built RPMs for RHEL 6.4 x86_64 can be found on the [releases page](https://github.com/rouge8/rpmbuilder-ansible/releases). Their only dependencies are `python-devel` and `postgresql-devel`, which should both be available in your local RHN mirror.

## Building

```sh
vagrant up --provision --provider=virtualbox
vagrant ssh
/vagrant/build.sh  # creates ansible-1.3.4_<date>_x86_64.rpm in the repo directory
```

**NOTE**: by default, uses Virtualbox to build. If you want to use VMware, add the equivalent vagrant box:

```sh
vagrant box add centos-6.4-x86_64 https://s3.amazonaws.com/rj-public/centos-6.4-x86_64-vmware.box
```

Copy that RPM to your target machine, install it with `sudo yum install <file>` (depends on `python-devel`, `postgresql-devel`, and their dependencies) and you're good to go!

Verify that it worked by having ansible ping your machine:

```sh
echo localhost > hosts
ansible -i hosts all (-k) -m ping
```

Include the `-k` if you need a password to do SSH authentication against localhost. Assuming it worked, you should see something like this:

```
localhost | success >> {
    "changed": false,
    "ping": "pong"
}
```

This is probably repeatable on other versions of RHEL/Fedora as well, but the important part is that the version you build the RPM on is the same as the version you deploy to.

## How?

[`fpm`](https://github.com/jordansissel/fpm) is a packaging tool that takes one format and transforms it into another (e.g. directory -> RPM, rubygem -> deb, etc.).

We install Ansible into a relocatable virtualenv, patch it so that it looks for its dependencies in the relocatable virtualenv (by default, Ansible will still attempt to use system packages), and build an RPM. The RPM installs the virtualenv to `/opt/ansible` with links in `/usr/local/bin/ansible`, `/usr/local/bin/ansible-doc`, and `/usr/local/bin/ansible-playbook`.
