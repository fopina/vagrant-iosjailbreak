# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.box_check_update = false

  config.vm.provision "fix-no-tty", type: "shell", privileged: false, inline: <<-SHELL
    sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile
  SHELL

  config.vm.provider "virtualbox" do |vb|
    vb.name = "jailbreakdev"
    vb.linked_clone = true
  end

  config.vm.provision "hostname-motd", type: "shell", path: "scripts/hostname_motd.sh"
  config.vm.provision "apt-update", type: "shell", path: "scripts/apt_installs.sh"
  config.vm.provision "install-theos", type: "shell", path: "scripts/install_theos.sh"
  config.vm.provision "install-sdk", type: "shell", path: "scripts/install_sdk.sh"
  config.vm.provision "install-toolchain", type: "shell", path: "scripts/install_toolchain.sh"
end
