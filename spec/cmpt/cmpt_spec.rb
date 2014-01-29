require 'spec_helper'

#
# nbd : Ensure the ndb kernel module is loaded
#
# To ensure installation is correct the following
# conditions needs to be met :
#
# * kernel module 'ndb' needs to be loaded
#

describe kernel_module('nbd') do
  it { should be_loaded }
end

#
# ssh : Ensure the ssh related files are created
#
# To ensure installation is correct the following
# conditions needs to be met :
#
# * directory should be 700
# * files should be 600
# * all should be owned by nova
# * directory '/var/lib/nova/.ssh' must be present
# * file '/var/lib/nova/.ssh/id_rsa' must be present
# * file '/var/lib/nova/.ssh/authorized_keys' must be present
# * file '/var/lib/nova/.ssh/config' must be present
#

describe file('/var/lib/nova/.ssh') do
  it { should be_mode 700 }
  it { should be_owned_by 'nova' }
end

describe file('/var/lib/nova/.ssh/id_rsa') do
  it { should be_mode 600 }
  it { should be_owned_by 'nova' }
end

describe file('/var/lib/nova/.ssh/authorized_keys') do
  it { should be_mode 600 }
  it { should be_owned_by 'nova' }
end

describe file('/var/lib/nova/.ssh/config') do
  it { should be_mode 600 }
  it { should be_owned_by 'nova' }
end

#
# nova::compute : Ensure the nova computes packages
#                 and services installed correctly
#
# To ensure installation is correct the following
# conditions needs to be met :
#
# * 'pm-utils', 'nova-common', 'nova-compute' packages needs to be installed
# * service 'nova-compute' needs to be installed, running and enabled
# * config file '/etc/nova/nova.conf' should match properties
#

describe package('pm-utils') do
  it { should be_installed }
end

describe package('bridge-utils') do
  it { should_not be_installed }
end

describe package('nova-common') do
  it { should be_installed }
end

describe package('nova-compute') do
  it { should be_installed }
end

describe service('nova-compute') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/nova/nova.conf') do
  it { should be_mode 640 }
  it { should be_owned_by 'nova' }

  its(:content) { should match /compute_driver=libvirt\.LibvirtDriver/ }
  its(:content) { should match /libvirt_type=#{property[:virt_type]}/ }
  its(:content) { should match /connection_type=libvirt/ }
  its(:content) { should match /vncserver_listen=0\.0\.0\.0/ }

  its(:content) { should match /novncproxy_base_url=http:\/\/#{property[:hostname_vip]}:6080\/vnc_auto\.html/ }
  its(:content) { should match /vnc_enabled=True/ }
  its(:content) { should match /vncserver_proxyclient_address=#{property[:server_ip]}/ }

end

#
# nova::compute::hypervisor : Ensure the hypervisor installed correctly
#
# To ensure installation is correct the following
# conditions needs to be met :
#
# * 'nova-compute-kvm' or 'nova-compute-qemu' is installed
# * package 'libvirt-bin' is installed
# * service 'libvirt-bin' is running and enabled
#

describe package("nova-compute-#{property[:virt_type]}") do
  it { should be_installed }
end

describe package('libvirt-bin') do
  it { should be_installed }
end

describe service('libvirt-bin') do
  it { should be_enabled }
  it { should be_running }
end