# Vagrant manifest to set up a VirtualBox instance for developing and
# testing the deployment of workflow software for compute clusters and
# workflow servers. See https://wiki.apidb.org/index.php/PreparingClusters
# for specifications.

WF_HOST = 'consign.pmacs.upenn.edu'
WF_USER_PATH = '/project/eupathdblab/workflow-software'
WF_USER = 'debbie'
WF_SHARED_GROUP = 'eupathdblab'

Vagrant.configure(2) do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-nocm"

  config.ssh.forward_agent = true

  config.vm.hostname = WF_HOST
  config.ssh.username = 'vagrant'

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.extra_vars = {
      wf_user_dir: WF_USER_PATH,
      sysadmin: config.ssh.username,
      wf_user: WF_USER,
      wf_shared_group: WF_SHARED_GROUP
    }
  end

end
