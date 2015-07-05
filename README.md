## vagrant-cluster-centos-6

Vagrant manifest to set up a VirtualBox instance for developing and testing the deployment of workflow software for compute clusters and workflow servers. See https://wiki.apidb.org/index.php/PreparingClusters for specifications.

### Requirements

__Software__

- Vagrant
- VirtualBox


### Usage

    git clone 
    vagrant up

### Simulating a workflow user

The vagrant box includes the account `debbie` whose `.bashrc` matches that of a typical workflow user. Use this account to test running the workflow software and ensure that the environment is set up correctly. The `.bashrc` is copy/paste from the wiki instructions (and the two should be kept in sync if you need to make changes).

To log in as `debbie`, run

    vagrant ssh -- -l debbie

### Updating workflow software

The "sysadmin" of the workflow software infrastructure is the user `vagrant`. This user should be used for updating the workflow software and changing the deployment infrastructure. The `workpuppet` script is used for routine updates. See the wiki for details.

The `workpuppet` script (see wiki) is run on each invocation of `vagrant provision`. In this case `workpuppet` is run by Ansible which eats stdout, so it can be difficult to troubleshoot problems. However, the stderr and stdout is recorded in `~vagrant/workpuppet.log`, so that may be of some use.

Alternatively you can, ssh to the virtual machine and run the command manually. This option allow you to monitor progress through stdout and more closely simulates how cluster software is updated in the wild.

    vagrant ssh -c 'source /eupath/workflow-software/sysadmin/bashrc; workpuppet'

Interactive changes and gefingerpoken can, of course, also be done from the `vagrant` shell. To log in as `vagrant`, run

    vagrant ssh

__The Development Environment__

Git cloning from git.apidb.org requires ssh key authentication. The `Vagrantfile` specifies `config.ssh.forward_agent = true` to use your host ssh agent - so you need an agent running.

The `init.sh` script that does the initial provisioning assumes a VM that mounts the Vagrant project directory from host to `/vagrant` on the guest. The `puppetlabs/centos-6.6-64-nocm` specified in the `Vagrantfile` satisfies this requirement.

One of the temptations of having a virtualized development environment is working off-campus or offline. Be aware that the provisioning and many other operations require network access to resources behind UGA firewalls and/or expect clients originating from trusted IP addresses. If you don't meet expected network conditions, silent or cryptic failures await you. If you work remotely, fire up UGA's VPN and you should be OK.


### Provisioning

The `init.sh` script initializes and bootstraps the `${BASE_DIR}/sysadmin` directory with required infrastructure. It's mostly copy/paste from the wiki instructions (and the two should be kept in sync if you make changes) with a few tweaks to aid Vagrant VM work. The design is such that `${BASE_DIR}/sysadmin` is only built on the first `vagrant up`. Subsequent `vagrant provision` invocations will skip `init.sh` if `${BASE_DIR}/sysadmin` exists. So if if you need to re-provision `${BASE_DIR}/sysadmin` you might as well `vagrant destroy` and start over.

Invocations of `vagrant provision` after the initial setup will always invoke the `workpuppet` script. This script manages the YUM repo updates and runs the `puppet apply`.

The git repo of Puppet manifests is checked out to the guest `/vagrant/staging` mount point and symlinked in to the `${BASE_DIR}/sysadmin` directory. The `/vagrant` volume is provided by the host so its contents persist across `vagrant destroy` (reducing the changes of losing uncommitted changes). This also has the side-effect that Puppet manifest editing and Git management can be done on you local host.

The `yum-workflow` directory is also symlinked in `${BASE_DIR}/sysadmin` to the `/vagrant/staging` mountpoint on the guest, shared with the host, so it is persistent across `vagrant destroy`. This is just to save download time. The directory can be deleted manually if you want to test a complete provision from scratch.
