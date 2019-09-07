# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "lavabit/evil"
  config.vm.hostname = "evil.build.box"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.box_check_update = true

  # config.vm.post_up_message = ""
  # config.vm.box_download_checksum = true
  # config.vm.box_download_checksum_type = "sha256"

  config.vm.usable_port_range = 20000..30000

  # The box ships with a short script that will clone the git repos and
  # compile the code. This line will trigger that process automatically
  # when the box is provisioned.
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    su -l vagrant -c '/home/vagrant/evil-build.sh'

  config.vm.provider :virtualbox do |v, override|
    v.customize ["modifyvm", :id, "--memory", 4096]
    v.customize ["modifyvm", :id, "--vram", 512]
    v.customize ["modifyvm", :id, "--cpus", 4]
    v.customize ["modifyvm", :id, "--usb", "on"]
    v.gui = false
  end

  ["vmware_fusion", "vmware_workstation", "vmware_desktop"].each do |provider|
    config.vm.provider provider do |v, override|
      v.whitelist_verified = true
      v.gui = false
      v.vmx["cpuid.coresPerSocket"] = "1"
      v.vmx["memsize"] = "2048"
      v.vmx["numvcpus"] = "2"
    end
  end

end