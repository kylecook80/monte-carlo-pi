# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "/Users/kyle/.puppet/modules"
  end

  config.vm.provision "file", source: "compile.sh", destination: "~/compile.sh"
  config.vm.provision "file", source: "dist.sh", destination: "~/dist.sh"
  config.vm.provision "file", source: "run.sh", destination: "~/run.sh"
  config.vm.provision "file", source: "monte_carlo_pi.c", destination: "~/monte_carlo_pi.c"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
  end

  config.vm.define "head", primary: true do |head|
    head.vm.box = "ubuntu/trusty64"
    head.vm.network "private_network", ip: "192.168.0.2"
    head.vm.hostname = "head"
  end

  config.vm.define "worker1" do |worker1|
    worker1.vm.box = "ubuntu/trusty64"
    worker1.vm.network "private_network", ip: "192.168.0.3"
    worker1.vm.hostname = "worker1"
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.box = "ubuntu/trusty64"
    worker2.vm.network "private_network", ip: "192.168.0.4"
    worker2.vm.hostname = "worker2"
  end
end

