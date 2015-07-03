BASE_DIR=$1
BASHRC=${BASE_DIR}/sysadmin/bashrc
source $BASHRC || { echo $BASHRC not found; exit 1; }
workpuppet
