WF_BASE_DIR = '/eupath/workflow-software'

Vagrant.configure(2) do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-nocm"

  config.ssh.forward_agent = true

  config.vm.hostname = 'cluster-sim-6'
  config.ssh.username = 'vagrant'

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.extra_vars = {
      wf_base_dir: WF_BASE_DIR,
      sysadmin: config.ssh.username
    }
  end

#  config.vm.provision 'yum install', :type => :shell, :inline => "yum install -q -y zlib-devel git"

 # config.vm.provision 'mkdir', :type => :shell, :inline => "mkdir -p #{WF_BASE_DIR}"
 # config.vm.provision 'chown', :type => :shell, :inline => "chown #{config.ssh.username}:#{config.ssh.username} #{WF_BASE_DIR}"
 # config.vm.provision 'set known_hosts', :type => :shell, :inline => "ssh-keyscan git.apidb.org > ~vagrant/.ssh/known_hosts", :privileged => false
 # config.vm.provision 'run init.sh', :type => :shell, :path => "init.sh", :args => WF_BASE_DIR, :privileged => false

end
