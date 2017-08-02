#!/bin/bash
source overcloudrc

# Create a cirros Image
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
openstack image create --disk-format qcow2 --file cirros-0.3.4-x86_64-disk.img --public cirros
openstack flavor create --ram 128 --vcpus 1 --public m1.micro

# Open security group rules for ICMP and SSH
openstack security group list --project=admin
admin_secgroup=$(openstack  security group list --project=admin | grep default | awk '{print $2}')
openstack security group rule create $admin_secgroup --protocol icmp --ingress
openstack security group rule create $admin_secgroup --protocol icmp --egress
openstack security group rule create $admin_secgroup --protocol tcp --dst-port 22 --ingress
openstack security group rule create $admin_secgroup --protocol tcp --dst-port 22 --egress

# Create an external network and a subnet
neutron net-create public --provider:physical_network datacentre --provider:network_type flat --router:external=True
neutron subnet-create public 10.0.0.0/24 --dns-nameserver 10.25.28.28 --disable-dhcp --allocation-pool start=10.0.0.210,end=10.0.0.250

# Create a router and attach an interface
neutron router-create router1
neutron router-gateway-set router1 public

# Create a tenant network
NET1=$(openstack network create net1 | awk '/ id / { print  $4}')
neutron subnet-create --name subnet1 net1 192.168.99.0/24

# Attach the tenant network to the router
neutron router-interface-add router1 subnet1

# Create a floating IP
FIP=$(neutron floatingip-create public | grep floating_ip_address |awk '{print $4}')

# Launch an instance and associate a Floating IP to the instance
openstack server create --flavor m1.micro --image cirros --nic net-id=$NET1 vm1
sleep 30
openstack server add floating ip vm1 $FIP

# Check connectivity
ping -c 30 $FIP
