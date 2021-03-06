sync_dir = ENV["SYNC_DIR"] || "Code"
port_80 = ENV["PORT_80"] || 8002
port_3306 = ENV["PORT_3306"] || 33062

Vagrant.require_version ">= 2.0.0"
Vagrant.configure("2") do |config|
  config.vm.define "ubuntu-18-04-tests-rails"
  config.vm.box = "bento/ubuntu-18.04" # 64GB HDD
  config.vm.provider "virtualbox" do |vb|
    vb.name = "ubuntu-18-04-tests-rails"
    vb.memory = "3072" # 3GB RAM
    vb.cpus = 1
  end
  # vagrant@ubuntu-18-04
  config.vm.hostname = "ubuntu-18-04-tests-rails"
  # Synchronize projects and vm directories
  config.vm.synced_folder "~/#{sync_dir}", "/home/vagrant/#{sync_dir}", owner: "vagrant", group: "vagrant"
  config.vm.synced_folder "~/vm", "/home/vagrant/vm", owner: "vagrant", group: "vagrant"
  # Disable default dir sync
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # Apache: http://localhost:8000
  # Puma: `rails server -b 0.0.0.0` => http://localhost:3000
  config.vm.network :forwarded_port, guest: 80, host: port_80 # HTTP
  config.vm.network :forwarded_port, guest: 3306, host: port_3306 # MySQL
  config.vm.network :forwarded_port, guest: 3000, host: 3000 # Rails Puma
  config.vm.network :forwarded_port, guest: 4444, host: 4444 # Selenium
  config.vm.network :forwarded_port, guest: 9222, host: 9222 # Chromedriver
  # Copy SSH keys and Git config
  config.vm.provision :file, source: "~/.ssh", destination: "$HOME/.ssh"
  config.vm.provision :file, source: "~/.gitconfig", destination: "$HOME/.gitconfig"
  # Provision bash scripts
  config.vm.provision :shell, path: "ubuntu-18-04.sh", env: {
    "CONFIG_PATH" => "/home/vagrant/vm/ubuntu-18-04-tests-rails/config",
    "SYNC_DIR" => sync_dir,
    "PORT_80" => port_80
  }
  config.vm.provision :shell, path: "tests.sh", env: {
    "CONFIG_PATH" => "/home/vagrant/vm/ubuntu-18-04-tests-rails/config",
    "SYNC_DIR" => sync_dir,
    "PORT_80" => port_80
  }
  config.vm.provision :shell, path: "rails.sh", env: {
    "CONFIG_PATH" => "/home/vagrant/vm/ubuntu-18-04-tests-rails/config",
    "SYNC_DIR" => sync_dir,
    "PORT_80" => port_80
  }
end
