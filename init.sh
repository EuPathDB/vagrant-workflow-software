# initializes and bootstraps the `${BASE_DIR}/sysadmin` directory with 
# required infrastructure.
#
# This is mostly copy/paste from the wiki instructions (and the two should
# be kept in sync if you make changes) with a few tweaks to aid Vagrant VM work.
# https://wiki.apidb.org/index.php/PreparingClusters

BASE_DIR=${1-/eupath/workflow-software}
export admin_path="${BASE_DIR}/sysadmin"

[[ -d "$admin_path" ]] && exit 0

# start clean
export PATH=/usr/bin:/bin
unset RUBYOPT RUBYLIB GEM_HOME

mkdir -p $admin_path/{software,src}

echo "downloading source code"
cd $admin_path/src/
curl -s -O http://software.apidb.org/source/ruby-1.8.7-p357.tar.gz
curl -s -O http://software.apidb.org/source/openssl-1.0.1j.tar.gz
curl -s -O http://software.apidb.org/source/rubygems-1.8.15.tgz

for i in *gz; do
  file "$i" | grep -q 'gzip compressed' || { echo "$PWD/$i is not valid"; exit 1; }
  tar zxf $i;
done;

cd $admin_path/src/openssl-1.0.1j

./config --prefix=$admin_path/software/openssl-1.0.1j shared
make install


cd $admin_path/src/ruby-1.8.7-p357
./configure \
  --prefix=$admin_path/software/ruby-1.8.7-p357 \
  --with-openssl-dir=$admin_path/software/openssl-1.0.1j \
  --disable-option-checking
make
make install

# get the ruby version you want in your PATH
export PATH=$admin_path/software/ruby-1.8.7-p357/bin:$PATH

cd $admin_path/src/rubygems-1.8.15
ruby setup.rb --prefix=$admin_path/software/rubygems-1.8.15

# get the new gem in PATH
export PATH=$admin_path/software/rubygems-1.8.15/bin:$PATH

export GEM_HOME=$admin_path/software/rubygems-1.8.15/gems
export RUBYLIB=$admin_path/software/rubygems-1.8.15/lib

gem install bundler


cd $admin_path
git clone git://gist.github.com/1793439.git make_admin_bin.sh
sh make_admin_bin.sh/make_admin_bin.sh $admin_path

cat > $admin_path/bashrc <<EOF
export admin_path=$admin_path
export PATH=\$admin_path/bin:/usr/bin:/bin
export GEM_HOME=\$admin_path/software/rubygems-1.8.15/gems
export RUBYLIB=\$admin_path/software/rubygems-1.8.15/lib
export RUBYOPT=rubygems
EOF

# Checkout puppet code on volume that is shared with host
# to aid editing, committing on host and to retain changes
# across vagrant destroy. This is Vagrant-specific. This
# would be cloned in situ on a real cluster.
git_wd=/vagrant/scratch/puppet-cluster
if [[ ! -d $git_wd ]]; then
  git clone git@git.apidb.org:puppet-cluster.git $git_wd
fi
ln -nsf $git_wd $admin_path/puppet

# Manually copy get_latest_package.rb in to $PATH . This script is used by a generate()
# function that is executed at manifest compile time - that is,
# before Puppet installs any files - so it needs to be pre-installed.
# Puppet will install updates to this file so we cp rather than ln.
cp $admin_path/puppet/modules/software/files/get_latest_package.rb $admin_path/bin/

# Manually copy the puppet wrapper script.
# Puppet will install updates to this file so we cp rather than ln.
cp $admin_path/puppet/modules/software/files/workpuppet $admin_path/bin/

# The yum repo contents will be downloaded to the guest volume shared
# with Vagrant host so it persists across vagrant destroy. This is
# just to save download time when re-provisioning a VM. 
# This is Vagrant-specific. On a real cluster this directory is
# created in situ by the workpuppet script.
mkdir /vagrant/scratch/yum-workflow
ln -s /vagrant/scratch/yum-workflow $admin_path/yum-workflow

