# Jarkom-Modul-3-2025-IT-20

# soal 1
- jadi pada soal 1 ini diminta untuk membuat konfigurasi sesuai dengan topologi yang sudah di buat
- topologi untuk durin(server)
```
# Interface ke Internet (NAT1)
`auto eth0
iface eth0 inet dhcp`

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
```

- untuk yang static seperti di bawah (tergantung gateway sama adressnya)
```
auto eth0
iface eth0 inet static
	address 192.221.x.x
	netmask 255.255.255.0
	gateway 192.221.x.x

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```
- untuk yang dynamic
```
auto eth0
iface eth0 inet dhcp
```
- untuk yang fixed address
```
auto eth0
iface eth0 inet static
	address 192.221.3.95
	netmask 255.255.255.0
	gateway 192.221.3.1

up echo nameserver 192.168.122.1 > /etc/resolv.conf
```

# soal 2

- di aldarion
```
apt update
apt install isc-dhcp-server -y
```

- (Di node Aldarion)
```
nano /etc/default/isc-dhcp-server
#ubah ini
INTERFACESv4="eth0"
```
```
nano /etc/dhcp/dhcpd.conf
```
```
#tambahkan ini di dhcpd.conf
# --- Opsi Global ---
option domain-name "K20.com";
# Kita asumsikan IP DNS Erendis (ns1) & Amdir (ns2) nanti
option domain-name-servers 192.221.3.2, 192.221.3.3; 
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.221.4.0 netmask 255.255.255.0 {
}

subnet 192.221.1.0 netmask 255.255.255.0 {
    range 192.221.1.6 192.221.1.34;
    range 192.221.1.68 192.221.1.94;
    option routers 192.221.1.1;
    option broadcast-address 192.221.1.255;
    # option domain-name "k20.com";
    option domain-name-servers 192.221.5.2;
    default-lease-time 600;
    max-lease-time 7200;
}

subnet 192.221.2.0 netmask 255.255.255.0 {
    range 192.221.2.35 192.221.2.67;
    range 192.221.2.96 192.221.2.121;
    option routers 192.221.2.1;
    option broadcast-address 192.221.2.255;
    # option domain-name "k20.com";
    option domain-name-servers 192.221.5.2;
    default-lease-time 600;
    max-lease-time 7200;
}

subnet 192.221.3.0 netmask 255.255.255.0 {
    option routers 192.221.3.1;
    option broadcast-address 192.221.3.255;
    # option domain-name "k20.com";
    option domain-name-servers 192.221.5.2;
    default-lease-time 600;
    max-lease-time 7200;
}
# fixed address untuk subnet 192.221.3.0/24
host khamul {
    hardware ethernet 02:42:eb:43:f3:00;
    fixed-address 192.221.3.95;
}
```

- install systemctl
```
apt update && apt install systemctl -y
```
- restart dan cek status dhcp server
```
systemctl restart isc-dhcp-server
systemctl status isc-dhcp-server
```

- di khamul
```
ip link show eth0
```
- nanti akan muncul mac address nya

- di durin
- 
```
apt update
apt install isc-dhcp-relay -y
```
- (Di node Durin)
```
nano /etc/default/isc-dhcp-relay
```
- IP Aldarion (DHCP Server)
```
SERVERS="192.221.4.2"
- Interface yang mendengarkan request dari KLIEN
- Ini adalah KUNCI-nya: eth1 (Amandil), eth2 (Gilgalad), eth3 (Khamul)
INTERFACES="eth1 eth2 eth3 eth4"
```

- ip forwarder
```
 echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
```

- restart dhcp
```
sysctl -p
service isc-dhcp-relay restart
```

- di node gilgalad dan amandil
```
apt update && apt install systemctl -y

- untuk soal 6 download di amandil dan gilgalad
apt install isc-dhcp-client -y
```
- (Di node Amandil dan gilgalad untuk menjadikan dia menjadi ip dynamic)
```
nano /etc/network/interfaces
- masukkan ini
auto eth0
iface eth0 inet dhcp
```

- (Di node Amandil dan gilgalad)
```
systemctl restart networking
```

- (Di node Amandil dan Gilgalad mengecek apakah sudah mendapatkan ip)
```
ip a
```