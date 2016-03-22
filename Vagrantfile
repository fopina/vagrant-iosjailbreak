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
    vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
  end

  config.vm.synced_folder "share/", "/share"

  config.vm.provision "hostname-motd", type: "shell", path: "scripts/hostname_motd.sh"
  config.vm.provision "locale", type: "shell", path: "scripts/set_locale.sh", args: ENV['LC_NAME']
  config.vm.provision "apt", type: "shell", path: "scripts/apt_installs.sh"
  config.vm.provision "theos", type: "shell", path: "scripts/install_theos.sh"
  config.vm.provision "sdk", type: "shell", path: "scripts/install_sdk.sh"
  config.vm.provision "toolchain", type: "shell", path: "scripts/install_toolchain.sh"
end
