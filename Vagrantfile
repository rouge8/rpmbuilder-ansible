# -*- mode: ruby -*-
# vi: set ft=ruby :

$setup = <<SCRIPT
sudo rpm -Uvh http://ftp.osuosl.org/pub/fedora-epel/6/i386/epel-release-6-8.noarch.rpm
sudo yum install -y postgresql-devel python-virtualenv patch rpm-build
sudo yum install -y rubygems ruby-devel
echo "Installing 'fpm'... (this might take a while)"
sudo gem install fpm
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos-6.4-x86_64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://s3.amazonaws.com/rj-public/centos-6.4-x86_64-virtualbox.box"

  # Provisioning!
  config.vm.provision "shell", inline: $setup
end
