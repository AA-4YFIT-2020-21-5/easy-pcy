# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/buster64'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
  end

  config.vm.hostname = 'ror-lernportal'
  config.vm.network 'private_network', ip: '192.168.10.10', virtualbox__intnet: false

  config.ssh.extra_args = ['-t', 'cd /vagrant; bash --login']

  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = false
  end
  config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

  config.vm.provision 'shell', path: 'setup.sh', privileged: false
end
