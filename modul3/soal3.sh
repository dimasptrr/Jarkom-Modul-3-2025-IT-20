# (Di node Minastir)
apt update
apt install bind9 -y

# (Di node minastir)
nano /etc/bind/named.conf.options

# Pastikan isinya sama persis dengan yang di Erendis:
options {
    directory "/var/cache/bind";
    dnssec-validation auto;
    forwarders {
        192.168.122.1;
    };
    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};

ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart

#ketika cat /etc/resolv.conf di client dynamic (amandil dan gilgalad) ipnya minastir, dia bisa ping google
