# Wrapper to aid Ansible running workpuppet.
set -x
set -e
wfs_dir=$1
bashrc=${wfs_dir}/sysadmin/bashrc
source $bashrc || { echo $bashrc not found; exit 1; }
workpuppet 2>&1 > /home/vagrant/workpuppet.log
