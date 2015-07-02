VAGRANT_COMMAND = ARGV[0]

Vagrant.configure(2) do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-nocm"
  
  config.vm.hostname = 'cluster-sim-6'
  config.ssh.username = 'vagrant'

  # The git repo of Puppet manifests requires ssh key authN not permitted
  # from guest. So we checkout on the host. It will be available on the
  # guest via the /vagrant mount point.
  if ARGV[0] != "ssh"
    system('/bin/sh gitclone')
  end

  config.vm.provision :shell, :inline => "yum install -q -y zlib-devel git"

  # The path to the parent directory that will hold the workflow software and
  # administrative infrastructure.
  base_dir = '/eupath'

  config.vm.provision :shell, :inline => "mkdir -p #{base_dir}"
  config.vm.provision :shell, :inline => "chown #{config.ssh.username}:#{config.ssh.username} #{base_dir}"
  config.vm.provision :shell, :inline => "ssh-keyscan git.apidb.org > ~/.ssh/known_hosts", :privileged => false
  config.vm.provision :shell, :path => "init.sh", :args => base_dir, :privileged => false

end
