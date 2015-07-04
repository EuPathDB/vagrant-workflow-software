#WF_BASE_DIR = '/eupath/workflow-software'
WF_HOST = 'consign.pmacs.upenn.edu'
WF_BASE_DIR = '/project/eupathdblab/workflow-software'
WF_USER = 'debbie'
WF_GROUP = 'eupathdblab'

Vagrant.configure(2) do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-nocm"

  config.ssh.forward_agent = true

  config.vm.hostname = WF_HOST
  config.ssh.username = 'vagrant'

#  config.vm.provison 'add group' :type => :shell, :inline => "groupadd -f #{WF_GROUP}"
#  config.vm.provison 'set sysadmin group' :type => :shell, :inline => "usermod -g #{WF_GROUP} #{config.ssh.username}"

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.extra_vars = {
      wf_base_dir: WF_BASE_DIR,
      sysadmin: config.ssh.username,
      wf_user: WF_USER,
      wf_group: WF_GROUP
    }
  end

end
