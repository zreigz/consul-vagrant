# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

def configure_vm(vm, **opts)

    vm.box = opts.fetch(:box, "yk0/ubuntu-xenial")
    vm.network :private_network, ip: opts[:private_ip]

    vm.provider :libvirt do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end

    vm.provider :virtualbox do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end

    # Disable default share, because we dont use it
    vm.synced_folder ".", "/vagrant", disabled: true
    
    vm.provision "file", source: "util.sh", destination: "util.sh"
    vm.provision "file", source: "cluster.sh", destination: "cluster.sh"
    vm.provision "file", source: "hostname.json", destination: "hostname.json"
    vm.provision "file", source: "master.sh", destination: "master.sh"
    vm.provision "file", source: "node.sh", destination: "node.sh"
end

Vagrant.configure(2) do |config|
    # ---------------------------------------------------------------------------------------------
    #
    # Definition of the VM for running consul master.
    #
    config.vm.define "master" do |master|
        configure_vm(master.vm, private_ip: "10.9.8.7")
        master.vm.provision "shell", inline: "IP_ADDRESS=10.9.8.7 ./cluster.sh master"
    end


    # ---------------------------------------------------------------------------------------------
    #
    # Definition of the VM for running consule node.
    #
    config.vm.define "node" do |node|
        configure_vm(node.vm, private_ip: "10.9.8.6")
        node.vm.provision "shell", inline: "IP_ADDRESS=10.9.8.6 ./cluster.sh worker"
    end

end
