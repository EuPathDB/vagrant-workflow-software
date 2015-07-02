BASE_DIR=${1-/eupath}
export admin_path="${BASE_DIR}/sysadmin"

# start clean
export PATH=/usr/bin:/bin
unset RUBYOPT RUBYLIB GEM_HOME

mkdir -p $admin_path/{software,src}

cd $admin_path/src/
curl -s -O http://software.apidb.org/source/ruby-1.8.7-p357.tar.gz
curl -s -O http://software.apidb.org/source/openssl-1.0.1j.tar.gz
curl -s -O http://software.apidb.org/source/rubygems-1.8.15.tgz

for i in * ; do tar zxf $i; done;

cd $admin_path/src/openssl-1.0.1j

./config --prefix=$admin_path/software/openssl-1.0.1j shared
make install


cd $admin_path/src/ruby-1.8.7-p357
./configure --prefix=$admin_path/software/ruby-1.8.7-p357 --with-openssl-dir=$admin_path/software/openssl-1.0.1j
#  add --disable-option-checking if your version of autoconf reports
# "configure: WARNING: unrecognized options: --with-openssl-dir"
# or just ignore the warning.
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


cd $admin_path
# Link the Git puppet-cluster repo from /vagrant mountpoint.
# see Vagrantfile for note on why.
ln -s /vagrant/puppet-cluster puppet

# Manually copy get_latest_package.rb in to $PATH . This script is used by a generate() function that is executed at manifest
# compile time - that is, before Puppet installs any files - so it needs to be pre-installed.
# Puppet will install updates to this file so we cp rather than ln.
cp $admin_path/puppet/modules/software/files/get_latest_package.rb $admin_path/bin/

# Manually copy the puppet wrapper script.
# Puppet will install updates to this file so we cp rather than ln.
cp $admin_path/puppet/modules/software/files/workpuppet $admin_path/bin/
