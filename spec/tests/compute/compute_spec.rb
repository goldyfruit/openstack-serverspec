require 'spec_helper'

#
# cloud::compute::compute
#

describe file('/etc/nova/nova.conf') do
  it { should contain "servicegroup_driver=mc" }
  it { should contain "vif_driver=nova.virt.libvirt.vif.LibvirtGenericVIFDriver" }
end
