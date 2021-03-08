# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
    config.vbguest.auto_update = false
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.customize ["modifyvm", :id, "--cpus", 1]
      end
    config.vm.define "kongdatastore" do |kongdatastore|
      kongdatastore.vm.box = "generic/centos7"
      kongdatastore.vm.hostname = "kongdatastore"
      kongdatastore.vm.network :private_network, ip: "10.10.20.10"
    end
    config.vm.define "kong-node-01" do |kongnode01|
      kongnode01.vm.box = "generic/centos7"
      kongnode01.vm.hostname = "kongnode01"
      kongnode01.vm.network :private_network, ip: "10.10.20.11"
    end
    config.vm.define "kongnode02" do |kongnode02|
      kongnode02.vm.box = "generic/centos7"
      kongnode02.vm.hostname = "kongnode02"
      kongnode02.vm.network :private_network, ip: "10.10.20.12"
    end
    config.vm.provision "shell", path: "setup.sh", privileged: true
  end
  