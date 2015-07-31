# Wrapper to aid Ansible running workpuppet.
set -x
set -e
BASE_DIR=$1
BASHRC=${BASE_DIR}/sysadmin/bashrc
source $BASHRC || { echo $BASHRC not found; exit 1; }
workpuppet 2>&1 > /home/vagrant/workpuppet.log
