

#di Erendis dan Amdir:
apt update
apt install bind9 bind9-utils -y

# (Di node Erendis)

# 1. Buat Symlink agar 'service bind9' ditemukan
ln -s /etc/init.d/named /etc/init.d/bind9

# 2. Perbaiki Izin (Jadikan 'bind' Pemilik Folder)
chown -R bind:bind /etc/bind/
chown -R bind:bind /var/cache/bind/

# (Di node Amdir)

# 1. Buat Symlink
ln -s /etc/init.d/named /etc/init.d/bind9

#ini di amdir 
# 2. Perbaiki Izin (Jadikan 'bind' Pemilik Folder)
chown -R bind:bind /etc/bind/
chown -R bind:bind /var/cache/bind/
chown -R bind:bind /var/lib/bind/  # (Ini PENTING untuk Slave)

#di erendis (Master DNS)
nano /etc/bind/named.conf.options


options {
    directory "/var/cache/bind";

    listen-on { any; };
    allow-query { any; };
    allow-transfer { 192.221.3.3; }; // Izinkan Amdir menyalin
};


nano /etc/bind/named.conf.local

zone "K20.com" {
    type master;
    file "/etc/bind/db.K20.com"; // Lokasi file "peta"
    allow-transfer { 192.221.3.3; }; 
};

nano /etc/bind/db.K20.com

; (File: /etc/bind/db.K20.com di Erendis)
$TTL    604800
@       IN      SOA     ns1.K20.com. root.K20.com. (
                      1         ; Serial (Ubah jika ada edit)
                      604800    ; Refresh
                      86400     ; Retry
                      2419200   ; Expire
                      604800 )  ; Negative Cache TTL
;
; --- Name Servers (Penjaga Peta) ---
@       IN      NS      ns1.K20.com.
@       IN      NS      ns2.K20.com.

; --- Alamat IP Penjaga Peta ---
ns1     IN      A       192.221.3.2     ; (Erendis)
ns2     IN      A       192.221.3.3     ; (Amdir)

; --- Lokasi Penting (Sesuai Konfig IP) ---
palantir  IN    A       192.221.4.3
elros     IN    A       192.221.1.7
pharazon  IN    A       192.221.2.2
elendil   IN    A       192.221.1.2
isildur   IN    A       192.221.1.3
anarion   IN    A       192.221.1.4
galadriel IN    A       192.221.2.6
celeborn  IN    A       192.221.2.5
oropher   IN    A       192.221.2.4

#di amdir (Slave DNS)
nano /etc/bind/named.conf.local

zone "K20.com" {
    type slave;
    file "/var/lib/bind/db.K20.com"; // Lokasi file salinan
    masters { 192.221.3.2; };       // Alamat IP Master (Erendis)
};

nano /etc/bind/named.conf.options

options {
    // ...
    listen-on { any; };
    allow-query { any; };
    // ...
};

# (Di Erendis)
named-checkconf
named-checkzone K20.com /etc/bind/db.K20.com

# (Di Amdir)
named-checkconf

# (Di Erendis)
service bind9 restart

# (Di Amdir)
service bind9 restart

#cek di amdir
nslookup elendil.K20.com 127.0.0.1

#outputnya harus:
# Name:   elendil.K20.com
# Address: 192.221.1.2

#konfig di setiap node klien (kecuali durin dan minastir)
#node statid IP
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "nameserver 192.221.3.3" >> /etc/resolv.conf
echo "search K20.com" >> /etc/resolv.conf