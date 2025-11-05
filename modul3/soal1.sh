# Interface ke Internet (NAT1)
auto eth0
iface eth0 inet dhcp

# Interface ke Switch1 (Numenor / Elendil)
auto eth1
iface eth1 inet static
    address 192.221.1.1
    netmask 255.255.255.0

# Interface ke Switch2 (Peri / Galadriel)
auto eth2
iface eth2 inet static
    address 192.221.2.1
    netmask 255.255.255.0

# Interface ke Switch3 (Erendis / Khamul)
auto eth3
iface eth3 inet static
    address 192.221.3.1
    netmask 255.255.255.0

# Interface ke Switch6 (Pharazon) - SESUAI DIAGRAM
auto eth4
iface eth4 inet static
    address 192.221.4.1
    netmask 255.255.255.0

# Interface ke Minastir (Proxy) - SESUAI DIAGRAM
auto eth5
iface eth5 inet static
    address 192.221.5.1
    netmask 255.255.255.0

up echo 1 > /proc/sys/net/ipv4/ip_forward

up apt update && apt install -y iptables
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.221.0.0/16


#Elendil
auto eth0
iface eth0 inet static
	address 192.221.1.2
	netmask 255.255.255.0
	gateway 192.221.1.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Isildur
auto eth0
iface eth0 inet static
	address 192.221.1.3
	netmask 255.255.255.0
	gateway 192.221.1.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Anarion
auto eth0
iface eth0 inet static
	address 192.221.1.4
	netmask 255.255.255.0
	gateway 192.221.1.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Miriel
auto eth0
iface eth0 inet static
	address 192.221.1.5
	netmask 255.255.255.0
	gateway 192.221.1.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Amandil
auto eth0
iface eth0 inet dhcp

#Elros
auto eth0
iface eth0 inet static
	address 192.221.1.7
	netmask 255.255.255.0
	gateway 192.221.1.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf


#Pharazon
auto eth0
iface eth0 inet static
	address 192.221.2.2
	netmask 255.255.255.0
	gateway 192.221.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Celebrimbor
auto eth0
iface eth0 inet static
	address 192.221.2.3
	netmask 255.255.255.0
	gateway 192.221.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Gilgalad
auto eth0
iface eth0 inet dhcp

#Oropher
auto eth0
iface eth0 inet static
	address 192.221.2.4
	netmask 255.255.255.0
	gateway 192.221.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Celeborn
auto eth0
iface eth0 inet static
	address 192.221.2.5
	netmask 255.255.255.0
	gateway 192.221.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf


#Galadriel
auto eth0
iface eth0 inet static
	address 192.221.2.6
	netmask 255.255.255.0
	gateway 192.221.2.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#khamul
auto eth0
iface eth0 inet static
	address 192.221.3.95
	netmask 255.255.255.0
	gateway 192.221.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf


#Erendis
auto eth0
iface eth0 inet static
	address 192.221.3.2
	netmask 255.255.255.0
	gateway 192.221.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Erendis
auto eth0
iface eth0 inet static
	address 192.221.3.3
	netmask 255.255.255.0
	gateway 192.221.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Aldarion
auto eth0
iface eth0 inet static
	address 192.221.4.2
	netmask 255.255.255.0
	gateway 192.221.4.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Palantir
auto eth0
iface eth0 inet static
	address 192.221.4.3
	netmask 255.255.255.0
	gateway 192.221.4.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Narvi
auto eth0
iface eth0 inet static
	address 192.221.4.4
	netmask 255.255.255.0
	gateway 192.221.4.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Minastir
#Palantir
auto eth0
iface eth0 inet static
	address 192.221.5.2
	netmask 255.255.255.0
	gateway 192.221.5.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf



