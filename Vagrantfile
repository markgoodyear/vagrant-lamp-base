####################################
# Some global vars to set up
####################################

box_name       = "LampBox"             # Set the box name
box_ip         = "92.46.60.101"        # VM box IP
host_port      = 8080                  # Host machine port, accessable at localhost:8080
root_dir       = "./www"               # Root dir mounted to /var/www on VM
manifests      = "vagrant/manifests"   # Puppet manifests folder
modules        = "vagrant/modules"     # Puppet modules folder


####################################
# Do not edit below unless you know
# what you're doing
####################################

Vagrant.configure("2") do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: box_ip
  # config.vm.network "public_network", :bridge => 'en1: Wi-Fi (AirPort)'

  # Forward ports
  config.vm.network :forwarded_port, guest: 80, host: host_port

  # Forward SSH
  config.ssh.forward_agent = true

  # Config VM
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--name", box_name]
  end

  # Set NFS settings
  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/

  # Synced folder
  config.vm.synced_folder root_dir, "/var/www", id: "vagrant-root" , :nfs => nfs_setting
  # config.vm.synced_folder "./db", "/var/www/db", :nfs => nfs_setting

  # Set sources list to GB servers
  config.vm.provision :shell, :inline => "sed -i 's/us.archive/gb.archive/g' /etc/apt/sources.list"

  # Shell provision
  config.vm.provision :shell, :inline =>
    "if [[ ! -f /apt-get-run ]]; then sudo apt-get update && sudo touch /apt-get-run; fi"

  # Puppet provision
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = manifests
    puppet.module_path = modules
    puppet.options = ['--verbose']
  end

end
