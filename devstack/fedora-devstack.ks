# Minimal Kickstart file
install
text
reboot
lang en_US.UTF-8
keyboard us
network --bootproto dhcp
#Choose a saner password here.
rootpw password
firewall --enabled --ssh
selinux --enforcing
timezone --utc America/New_York
bootloader --location=mbr --append="console=tty0 console=ttyS0,115200 rd_NO_PLYMOUTH"
zerombr
clearpart --all --initlabel
autopart
user --name=stack --homedir=/opt/stack --password=password --groups wheel

%packages
@core
git
wget
bridge-utils
net-tools
yum-utils
sudo
%end

%post --nochroot
echo "stack	ALL=(ALL)	NOPASSWD: ALL" >> /mnt/sysimage/etc/sudoers
%end
