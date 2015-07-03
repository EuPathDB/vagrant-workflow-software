## vagrant-cluster-centos-6

Sets up a virtual machine for developing and testing workflow software deployment for compute clusters and workflow servers. See https://wiki.apidb.org/index.php/PreparingClusters for specifications.

### Usage

    git clone 
    vagrant up

### A warning about working remotely

One of the temptations of having a virtualized development environment is working off-campus or offline. Be aware that the provisioning and many other operations require network access to resources behind UGA firewalls and/or expect clients originating from trusted IP addresses. If you don't meet expected network conditions, silent or cryptic failures await you. If you work remotely, fire up UGA's VPN and you should be OK.

### Vagrantfile

The `Vagrantfile` sets the variable `WF_BASE_DIR` as the path to the parent directory that will hold the workflow software and administrative infrastructure.

Git cloning from git.apidb.org requires ssh key authentication. The `Vagrantfile` specifies `config.ssh.forward_agent = true` to use your host ssh agent - so you need one agent running.

The `init.sh` provisioning assumes a VM that mounts the Vagrant project directory from host to `/vagrant` on the guest. The `puppetlabs/centos-6.6-64-nocm` specified satisfies this requirement.


### Provisioning

The `init.sh` script initializes and bootstraps the `${BASE_DIR}/sysadmin` directory with required infrastructure. It's mostly copy/paste from the wiki instructions (and the two should be kept in sync if you make changes) with a few tweaks to aid Vagrant VM work. The design is such that `${BASE_DIR}/sysadmin` is only built on the first `vagrant up`. Subsequent `vagrant provision` invocations will skip `init.sh` if `${BASE_DIR}/sysadmin` exists. So if if you need to re-provision `${BASE_DIR}/sysadmin` you might as well `vagrant destroy` and start over.

Invocations of `vagrant provision` after the initial setup will invoke the `workpuppet` script. This script manages the YUM repo updates and runs the `puppet apply`.

The git repo of Puppet manifests is checked out to the guest `/vagrant/staging` mount point and symlinked in to the `${BASE_DIR}/sysadmin` directory. The `/vagrant` volume is provided by the host so its contents persist across `vagrant destroy` (reducing the changes of losing uncommitted changes).

The `yum-workflow` directory is also symlinked in `${BASE_DIR}/sysadmin` to the `/vagrant/staging` mountpoint on the guest, shared with the host, so it is persistent across `vagrant destroy`. This is just to save download time. The directory can be deleted manually if you want to test a complete provision from scratch.
