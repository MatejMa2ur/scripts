# Learn more about Mikrotik Scripting on: 
#
# https://help.mikrotik.com/docs/display/ROS/Scripting
# 

# This script is intended to quickly install a pihole on your machine, after containers are allowed.

# Setup

# Add network interface
/interface veth
add name=veth1 address=17.17.0.2/24 gateway=172.17.0.1

# Add network bridge
/interface bridge
add name=docker
/ip address
add address=172.17.0.1 interface=docker
/interface bridge port
add bridge=docker interface=veth1

# Setup firewall rule
/ip firewall nat
add chain=srcnat action=masquerade src-address=172.17.0.0/24

# Setup container envs
/container envs
add key=TZ name=pihole_env value=Europe/Prague
add key=WEBPASSWORD name=pihole_env value=mystrongpassword
add key=DNSMASQ_USER name=pihole_env value=root

# Setup container mounts
/container mounts
add dst=/etc/pihole name=etc_pihole src=/usb1-part1/etc
add dst=/etc/dnsmasq.d name=dnsmasq_pihole src=/usb1-part1/etc-dnsmasq.d

# Add container registry
/container config
set registry-url=https://registry-1.docker.io tmpdir=usb1-part1/pull

# Add container
/container
add remote-image=pihole/pihole:latest interface=veth1 root-dir=usb1-part1/pihole mounts=dnsmasq_pihole,etc_pihole envlist=pihole_env
