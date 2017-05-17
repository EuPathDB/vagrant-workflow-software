# Vagrant manifest to set up a VirtualBox instance for developing and
# testing the deployment of workflow software for compute clusters and
# workflow servers. See https://wiki.apidb.org/index.php/PreparingClusters
# for specifications.

WF_SERVERS = {
#   :el5 => {
#     :vagrant_box     => 'puppetlabs/centos-5.11-64-nocm',
#     :wf_hostname     => 'zcluster.rcc.uga.edu',
#     :wf_eupath_dir   => '/panfs/pstor.storage/jckscratch/eupath',
#     :wf_user         => 'debbie',
#     :wf_shared_group => 'jcklab',
#   },
  :el6 => {
    :vagrant_box     => 'puppetlabs/centos-6.6-64-nocm',
    :wf_hostname     => 'consign.pmacs.upenn.edu',
    :wf_eupath_dir   => '/project/eupathdblab',
    :wf_user         => 'debbie',
    :wf_shared_group => 'eupathdblab',
  },
  :el7 => {
    :vagrant_box     => 'ebrc/centos-7-64-puppet',
    :wf_hostname     => 'elm.pcbi.upenn.edu',
    :wf_eupath_dir   => '/eupath',
    :wf_user         => 'debbie',
    :wf_shared_group => 'eupa',
  },
}

Vagrant.configure(2) do |config|

  config.ssh.forward_agent = true
  config.ssh.username = 'vagrant'

  WF_SERVERS.each do |name,cfg|
    config.vm.define name do |vm_config|

      vm_config.vm.box      = cfg[:vagrant_box] if cfg[:vagrant_box]
      vm_config.vm.hostname = cfg[:wf_hostname] if cfg[:wf_hostname]

      # Prepare CentOS 5 to support Ansible
      if ( /centos-5/.match(vm_config.vm.box) )
        vm_config.vm.provision 'Install epel key',
            :type => :shell,
            :inline => 'rpm --import http://mirrors.mit.edu/epel/RPM-GPG-KEY-EPEL'
        vm_config.vm.provision 'Install epel repo',
            :type => :shell,
            :inline => 'rpm -q --quiet epel-release-5-4 || rpm -U http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm'
        vm_config.vm.provision 'Install centos key',
            :type => :shell,
            :inline => 'rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5'
        vm_config.vm.provision 'Install json',
            :type => :shell,
            :inline => 'yum install -d 0 -e 0 -y python-simplejson'
      end

      vm_config.vm.provision :ansible do |ansible|
        ansible.playbook = "playbook.yml"
        ansible.extra_vars = {
          sysadmin:        config.ssh.username,
          wf_eupath_dir:   cfg[:wf_eupath_dir],
          wf_user_path:    "#{cfg[:wf_eupath_dir]}/workflow-software",
          wf_user:         cfg[:wf_user],
          wf_shared_group: cfg[:wf_shared_group]
        }
      end

    end # config.vm.define
  end # WF_SERVERS.each
end # Vagrant.configure
