# Jarkom-Modul-3-2025-IT-20
**Laporan Resmi Praktikum Modul  — Komunikasi Data & Jaringan Komputer 2025**

## Daftar Anggota

| Nama                  | NRP        |
|-----------------------|------------|
| Zahra Khaalishah      | 5027241070 |
| Dimas Muhammad Putra  | 5027241076 |

---
# Soal 1
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

# Soal 2
- Tujuan dari skrip Soal 2 ini adalah Mengimplementasikan dan Menguji Layanan DHCP Dinamis dan Statis di jaringan Anda, menggunakan Durin sebagai perantara (Relay).
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

# soal 3
- Tujuan dari skrip Soal 3 yang Anda lakukan di Minastir ini adalah untuk Mengaktifkan dan Menguji Minastir sebagai DNS Resolver/Forwarder Sentral untuk seluruh jaringan Anda.
- jadi untuk soal nomor 3 ini 
- (Di node Minastir)
```
apt update
apt install bind9 -y
```

- (Di node minastir)
nano /etc/bind/named.conf.options

- Pastikan isinya sama persis dengan yang di Erendis:
```
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
```
- jalankan ini dulu sebelum merestart bind9
```
ln -s /etc/init.d/named /etc/init.d/bind9
```
- setelah itu di restart
```
service bind9 restart
```

- ketika cat /etc/resolv.conf di client dynamic (amandil dan gilgalad) ipnya minastir, dia bisa ping google

# Soal 4
- Tujuan dari skrip Soal 4 ini adalah Mengimplementasikan dan Menguji Arsitektur DNS Master-Slave Internal untuk domain pribadi Anda (K20.com), dan menetapkan Erendis serta Amdir sebagai otoritas resolusi nama utama.

- di Erendis dan Amdir:
```
apt update
apt install bind9 bind9-utils -y
```

-  (Di node Erendis)

-  1. Buat Symlink agar 'service bind9' ditemukan
```
ln -s /etc/init.d/named /etc/init.d/bind9
```

-  2. Perbaiki Izin (Jadikan 'bind' Pemilik Folder)
```
chown -R bind:bind /etc/bind/
chown -R bind:bind /var/cache/bind/
```

-  (Di node Amdir)

-  1. Buat Symlink
```
ln -s /etc/init.d/named /etc/init.d/bind9
```
- ini di amdir 
- 2. Perbaiki Izin (Jadikan 'bind' Pemilik Folder)
```
chown -R bind:bind /etc/bind/
chown -R bind:bind /var/cache/bind/
chown -R bind:bind /var/lib/bind/  # (Ini PENTING untuk Slave)
```
- di erendis (Master DNS)
```
nano /etc/bind/named.conf.options
```

```
options {
    directory "/var/cache/bind";

    listen-on { any; };
    allow-query { any; };
    allow-transfer { 192.221.3.3; }; // Izinkan Amdir menyalin
};
```
```
nano /etc/bind/named.conf.local
```
```
zone "K20.com" {
    type master;
    file "/etc/bind/db.K20.com"; // Lokasi file "peta"
    allow-transfer { 192.221.3.3; }; 
};
```

```
nano /etc/bind/db.K20.com
```

```
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
```

- di amdir (Slave DNS)
```
nano /etc/bind/named.conf.local
```
- 
```
zone "K20.com" {
    type slave;
    file "/var/lib/bind/db.K20.com"; // Lokasi file salinan
    masters { 192.221.3.2; };       // Alamat IP Master (Erendis)
};
```

```
nano /etc/bind/named.conf.options

options {
    // ...
    listen-on { any; };
    allow-query { any; };
    // ...
};
```

- (Di Erendis)
```
named-checkconf
named-checkzone K20.com /etc/bind/db.K20.com
```
- (Di Amdir)
```
named-checkconf
```

- (Di Erendis)
```
service bind9 restart
```
- (Di Amdir)
```
service bind9 restart
```

- cek di amdir
```
nslookup elendil.K20.com 127.0.0.1
```

- outputnya harus:
```
# Name:   elendil.K20.com
# Address: 192.221.1.2
```

- konfig di setiap node klien (kecuali durin dan minastir)
- node statid IP
```
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "nameserver 192.221.3.3" >> /etc/resolv.conf
echo "search K20.com" >> /etc/resolv.conf
```

# Soal 5
- Tujuan dari Soal 5 ini adalah Menambah Fitur Lanjutan pada DNS Internal dan Mengaktifkan Pelacakan Balik (Reverse Lookup).
- (Di node Erendis)
```
nano /etc/bind/db.K20.com
```
- ubah file db.K20.com menjadi seperti ini:
```
@       IN      SOA     ns1.K20.com. root.K20.com. (
                      2         ; Serial (NAIKKAN ANGKA INI)

- tambahkan record baru ini juga

; ... (daftar IP A record dari soal 4) ...

; --- Soal 5: Alias (CNAME) ---
www     IN      CNAME   K20.com.

; --- Soal 5: Pesan Rahasia (TXT) ---
; "Cincin Sauron" -> elros.K20.com
@       IN      TXT     "Cincin Sauron=elros.K20.com"

; "Aliansi Terakhir" -> pharazon.K20.com
@       IN      TXT     "Aliansi Terakhir=pharazon.K20.com"
```

- Definisikan Zona Reverse
```
nano /etc/bind/named.conf.local
```
```
zone "3.221.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.221.3"; // File "peta terbalik"
    allow-transfer { 192.221.3.3; }; // Izinkan Amdir menyalin
};
```

- Buat File "Peta Terbalik"
```
nano /etc/bind/db.192.221.3
```
```
; (File: /etc/bind/db.192.221.3 di Erendis)
$TTL    604800
@       IN      SOA     ns1.K20.com. root.K20.com. (
                      1         ; Serial
                      604800    ; Refresh
                      86400     ; Retry
                      2419200   ; Expire
                      604800 )  ; Negative Cache TTL
;
; --- Name Servers ---
@       IN      NS      ns1.K20.com.
@       IN      NS      ns2.K20.com.

; --- PTR Records (IP ke Nama) ---
; (Perhatikan: Hanya angka terakhir dari IP)
2       IN      PTR     ns1.K20.com.    ; (192.221.3.2)
3       IN      PTR     ns2.K20.com.    ; (192.221.3.3)
```

-  (Di node Amdir)
```
nano /etc/bind/named.conf.local
```
```
zone "3.221.192.in-addr.arpa" {
    type slave;
    file "/var/lib/bind/db.192.221.3";
    masters { 192.221.3.2; };
};
```

- (Di Erendis)
- Cek file forward (yang di-edit)
- Cek file reverse (yang baru)

```
named-checkconf
named-checkzone K20.com /etc/bind/db.K20.com
named-checkzone 3.221.192.in-addr.arpa /etc/bind/db.192.221.3
```

- (Di Erendis dan amdir)
```
service bind9 restart
```

- (Di node Amandil)
```
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "nameserver 192.221.3.3" >> /etc/resolv.conf
echo "search K20.com" >> /etc/resolv.conf
```

-  (Di node Amandil)

-  Tes 1: Cek Alias (CNAME)
```nslookup www.K20.com```

-  Tes 2: Cek Pesan Rahasia (TXT)
```nslookup -type=TXT K20.com```

-  Tes 3: Cek Peta Terbalik (PTR)
```
nslookup 192.221.3.2
nslookup 192.221.3.3
```


- Hasil yang Diharapkan:
- Tes 1 (CNAME): Akan menampilkan...
```
www.K20.com     canonical name = K20.com.
Name:   K20.com
Address: [IP Erendis/Amdir, atau IP lain jika Anda set A record untuk @]
```

- Tes 2 (TXT): Akan menampilkan...
```
K20.com text = "Cincin Sauron=elros.K20.com"
K20.com text = "Aliansi Terakhir=pharazon.K20.com"
```

- Tes 3 (PTR): Akan menampilkan...
```
2.3.221.192.in-addr.arpa      name = ns1.K20.com.
3.3.221.192.in-addr.arpa      name = ns2.K20.com.'
```

# Soal 6
- Mengatur dan Menguji Kontrol Waktu Peminjaman Alamat IP (Lease Time) secara Berbeda untuk Setiap Kelompok Klien sesuai dengan ketentuan Raja Aldarion.   
- (Di node Aldarion)
```nano /etc/dhcp/dhcpd.conf```

- (File: /etc/dhcp/dhcpd.conf di Aldarion)

```
# --- Opsi Global ---
option domain-name "K20.com";
option domain-name-servers 192.221.3.2, 192.221.3.3; 
default-lease-time 600; # Waktu default (bisa ditimpa per subnet)
max-lease-time 3600;    # Batas Maksimal Global (1 Jam)
authoritative;

# --- Subnet 1: Keluarga Manusia (Setengah Jam) ---
subnet 192.221.1.0 netmask 255.255.255.0 {
    option routers 192.221.1.1;
    range 192.221.1.6 192.221.1.34;
    range 192.221.1.68 192.221.1.94;
    
    # --- TAMBAHKAN INI ---
    default-lease-time 1800; # Setengah Jam
    max-lease-time 3600;     # 1 Jam (sesuai aturan global)
}

# --- Subnet 2: Keluarga Peri (Seperenam Jam) ---
subnet 192.221.2.0 netmask 255.255.255.0 {
    option routers 192.221.2.1;
    range 192.221.2.35 192.221.2.67;
    range 192.221.2.96 192.221.2.121;
    
    # --- TAMBAHKAN INI ---
    default-lease-time 600;  # Seperenam Jam
    max-lease-time 3600;   # 1 Jam
}

# ... (Subnet 3, 4, 5 biarkan seperti semula) ...
```
- (Di node Aldarion)
```
service isc-dhcp-server restart
```

- (Di node Amandil & Gilgalad)
```
dhclient -r && dhclient -v eth0
```
```
cat /var/lib/dhcp/dhclient.leases | grep "lease-time"
```
- (Di node Aldarion)
```
cat /var/lib/dhcp/dhcpd.leases
```

# Soal 7
- Tujuan dari skrip Soal 7 ini adalah Mengimplementasikan dan Menguji Basis Aplikasi Web (Laravel) pada Worker Node Anda.

- 1. Konfigurasi DNS (Menggunakan Minastir BIND9 sebagai utama, Erendis sebagai internal)
- Minastir BIND9 (192.221.5.2) harus sudah dikonfigurasi untuk forward K20.com ke 3.2/3.3
```
echo "nameserver 192.221.5.2" > /etc/resolv.conf 
echo "nameserver 192.221.3.2" >> /etc/resolv.conf # Fallback Internal
echo "search K20.com" >> /etc/resolv.conf
```

- 2. Update & Instalasi Tools (Akses langsung ke internet via NAT Durin)
```
apt update
apt install nginx php8.4-fpm php8.4-mbstring php8.4-xml php8.4-curl composer git -y
```
- 3. Hapus Environment Proxy (Pastikan tidak ada loop)
```
unset http_proxy
unset https_proxy
```

- 1. Pindah ke direktori web
```
cd /var/www/
```

- 3. Clone Repositori (Cetak Biru Benteng)
```
git clone https://github.com/elshiraphine/laravel-simple-rest-api.git
cd laravel-simple-rest-api
```

- 4. Instal Dependensi (Perbaikan Kompatibilitas PHP 8.4)
- Perintah 'update' wajib karena PHP 8.4 Anda terlalu baru untuk file lock lama
- Pastikan variabel proxy sudah tersetting di terminal ini
```
composer update
```
- 5. Final Setup Laravel
```
cp .env.example .env
php artisan key:generate
```

- 6. Atur Izin Folder (agar Nginx bisa menulis cache)
```
chown -R www-data:www-data storage/ bootstrap/cache/
```
- (Di Elendil, Isildur, & Anarion)
```
nano /etc/nginx/sites-available/default
```
```
server {
    listen 80 default_server;
    root /var/www/laravel-simple-rest-api/public;
    index index.php index.html index.htm;
    server_name _;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        # Pastikan ini sesuai dengan PHP FPM yang diinstal
        fastcgi_pass unix:/run/php/php8.4-fpm.sock; 
    }

    location ~ /\.ht {
        deny all;
    }
}
```

- (Di Elendil, Isildur, & Anarion)
```
service nginx restart
service php8.4-fpm restart
```

- diketiga node (elendil,isildur,anarion) tes
```
curl http://127.0.0.1
```

# Soal 8 
- Tujuan dari skrip Soal 8 ini adalah Mengintegrasikan Aplikasi Laravel dengan Database Terpusat (Palantir) dan Mengaktifkan Akses Port yang Terpisah/Unik untuk Setiap Worker.

- (Di node Palantir)
- Instal MariaDB Server
apt update
apt install mariadb-server -y

- Palantir butuh PHP MySQL extension agar bisa komunikasi dengan dirinya sendiri
apt install php8.4-mysql -y

- (Di node Palantir)

service mariadb restart

- Masuk ke MySQL (dengan password kosong/default)
mysql -u root

- Jalankan perintah SQL di bawah ini:
CREATE DATABASE laravel_db;
CREATE USER 'laravel_user'@'192.221.1.%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'192.221.1.%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;

- (Di Elendil, Isildur, dan Anarion)
- Perlu extension ini agar Laravel tahu cara bicara dengan MariaDB
apt install php8.4-mysql -y
service php8.4-fpm restart

- (Di Elendil, Isildur, dan Anarion)
nano .env

```
DB_CONNECTION=mysql
DB_HOST=palantir.K20.com  # Menggunakan domain Palantir yang sudah dikonfigurasi di DNS
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=password
```


- konfigurasi nginx
Node	Port Nginx	Server Name
Elendil	8001	elendil.K20.com
Isildur	8002	isildur.K20.com
Anarion	8003	anarion.K20.com

- (Di Elendil, Isildur, dan Anarion)
```
nano /etc/nginx/sites-available/default
```

```
server {
    # UBAH BARIS INI SESUAI NODE (8001/8002/8003)
    listen 8001 default_server; 

    # UBAH BARIS INI SESUAI NODE (elendil.K20.com/isildur.K20.com/anarion.K20.com)
    server_name elendil.K20.com; 
    
    # Goal 4: Restriksi Akses IP
    # Karena kita mendefinisikan server_name secara eksplisit, 
    # permintaan yang datang melalui IP akan diabaikan oleh Nginx.
    
    root /var/www/laravel-simple-rest-api/public;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
```

- di node palantir
```
nano /etc/mysql/mariadb.conf.d/50-server.cnf
```
```
[mysqld]
# bind-address = 127.0.0.1  <-- Pastikan ini DIHAPUS atau diberi tanda #
bind-address = 0.0.0.0      <-- atau tambahkan/ubah menjadi 0.0.0.0
```
```
service mariadb restart
```

- (Di Elendil, Isildur, dan Anarion)
```
service nginx restart
```

- Migrasi Database
```
php artisan migrate --seed
```
- (Di node Amandil dan Gilgalad)
```
#tambahkan nameserver di resolv.conf
nameserver 192.221.3.2(ini ip erendis)
```

# soal 9
- lanjutan dari soal nomor 8 dimana di tes di client amandil dan gilgalad
- (Di node Amandil & Gilgalad)
apt install lynx -y

- Tes Elendil (Port 8001)
```
lynx http://elendil.K20.com:8001
```

- Tes Isildur (Port 8002)
```
lynx http://isildur.K20.com:8002
```

- Tes Anarion (Port 8003)
```
lynx http://anarion.K20.com:8003
```

# Soal 10
- Mengimplementasikan Load Balancer Nginx di Elros untuk mendistribusikan trafik aplikasi secara merata ke Worker Node (Elendil, Isildur, Anarion).
- di elros
```
apt update
apt install nginx php8.4-fpm php8.4-mysql git -y
```

```
nano /etc/nginx/sites-available/elros.conf
```
```
# --- Bagian 1: UPSTREAM (Load Balancer Pool) ---
# Nama Upstream: kesatria_numenor
upstream kesatria_numenor {
    # Algoritma default adalah Round Robin (distribusi merata)
    # Tiga Worker Node: Elendil (8001), Isildur (8002), Anarion (8003)
    server elendil.K20.com:8001;
    server isildur.K20.com:8002;
    server anarion.K20.com:8003;
}

# --- Bagian 2: SERVER BLOCK (Reverse Proxy) ---
server {
    listen 80;
    server_name elros.K20.com;

    # Hapus Server Block default Nginx agar tidak mengganggu (jika ada)
    # Ini juga memastikan Nginx merespons hanya pada domain elros.K20.com

    location / {
        # Directive utama: Meneruskan permintaan ke pool upstream
        proxy_pass http://kesatria_numenor;

        # Wajib: Meneruskan informasi Host dan IP klien yang sebenarnya ke Worker
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Pengaturan koneksi (opsional)
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 600;
    }
}
```


- masukkan nameserver di elros dan amandil
```
nano /etc/resolv.conf
nameserver 192.221.3.2
```

 - 1. Buat symlink untuk mengaktifkan konfigurasi
 ```
 ln -s /etc/nginx/sites-available/elros.conf /etc/nginx/sites-enabled/
 ```

 - 2. Uji sintaks konfigurasi Nginx
 ```
 nginx -t
 ```

 - 3. Muat ulang layanan Nginx
 ```
 service nginx restart
 ```

 - di amandil
 - Uji permintaan pertama (harus ke Elendil:8001)
 ```
 curl -s -o /dev/null -w "Status: %{http_code}\nWorker: %{remote_port}\n" http://elros.K20.com/
 ```

- Uji permintaan kedua (harus ke Isildur:8002)
 ```
 curl -s -o /dev/null -w "Status: %{http_code}\nWorker: %{remote_port}\n" http://elros.K20.com/
 ```

- Uji permintaan ketiga (harus ke Anarion:8003)
 ```
 curl -s -o /dev/null -w "Status: %{http_code}\nWorker: %{remote_port}\n" http://elros.K20.com/
 ```

 # soal 11

- (Di node Amandil/Gilgalad)
```
apt update
apt install apache2-utils -y
```

- (Di Elendil, Isildur, dan Anarion)
```
htop
```

- (Di node Amandil)
```
echo "--- SERANGAN PENUH (2000 permintaan, 100 bersamaan - BASELINE TANPA WEIGHT) ---"
```

- Catatan: Karena Anda tidak mencantumkan autentikasi di skrip Soal 10 Anda, 
- kita asumsikan akses API tidak memerlukan username/password.
```
ab -n 2000 -c 100 http://elros.K20.com/api/airing
```
```
nano /etc/nginx/sites-available/elros.conf
```
- ubah bagian upstream kesatria_numenor

```
# --- Definisikan Upstream dengan Weight ---
upstream kesatria_numenor {
    server elendil.K20.com:8001 weight=2; # Elendil menerima 2x beban
    server isildur.K20.com:8002 weight=1; # Isildur
    server anarion.K20.com:8003 weight=1; # Anarion
}
# ... (Sisanya tetap sama) ...
```

- (Di node Elros)
```
service nginx restart
```
- (Di node Amandil)
```
echo "--- SERANGAN PENUH (2000 permintaan, 100 bersamaan - DENGAN WEIGHT 2:1:1) ---"

ab -n 2000 -c 100 http://elros.K20.com/api/airing
```

- Bandingkan metrik "Requests per second" dan "Failed requests" dari kedua tes untuk menarik kesimpulan:

- Jika Requests per second naik dan/atau Failed requests turun, strategi weight LEBIH BAIK.

# Soal 12 & 13

- Step 0 :
1. Nyalain "Saklar Jasa Titip" (Proxy)
(Di console 'Minastir')
```
service squid start
```
2. Nyalain "Saklar Kantor Telepon Utama" (DNS Master)
(Di console 'Erendis')
```
service bind9 start
``` 

3. Nyalain "Saklar Kantor Telepon Cadangan" (DNS Slave)
 (Di console 'Amdir')
```
service bind9 start
```

- Step 1: 'Galadriel' (Gerbang 8004)

1. Atur "Jasa Titip" (Proxy) permanen untuk 'apt'
```
echo 'Acquire::http::Proxy "http://192.221.5.2:3128";' > /etc/apt/apt.conf.d/99proxy.conf
echo 'Acquire::https::Proxy "http://192.221.5.2:3128";' >> /etc/apt/apt.conf.d/99proxy.conf
```
2. Atur "Buku Telepon" (DNS)
```
echo "nameserver 192.221.5.2" > /etc/resolv.conf
echo "nameserver 192.221.3.2" >> /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf
```

3. Download "Katalog Harga" (via Jasa Titip)
```
apt-get update
```
4. "Belanja" Alat untuk Taman (Soal 12) 
```
apt-get install nginx php8.4-fpm -y
```
5. Buat file "Plang Nama"
```
nano /var/www/html/index.php
```

isi nano: /var/www/html/index.php ===
```
<?php
# // Menampilkan nama hostname Taman-nya [cite: 192]
 echo "Ini adalah Taman Digital " . gethostname();
?>
```

6. Buka "Buku Aturan Penjaga Gerbang"
```
nano /etc/nginx/sites-available/default
```
isian nano: /etc/nginx/sites-available/default
```
 server {
     # Soal 13: Atur "Gerbang Masuk" unik di port 8004 [cite: 195]
     listen 8004;
 
     root /var/www/html;
     index index.php index.html;
 
     # Soal 12: "Nama" Taman (dari soal4.sh)
     server_name galadriel.k20.com; 
 
     # Soal 12: "Penjaga Gerbang" (Tolak panggilan via IP) [cite: 193]
     if ($host != $server_name) {
         return 404;
     }
 
     location / {
         try_files $uri $uri/ =404;
     }
 
     # Soal 13: Sambungkan "Penjaga Gerbang" ke "Bibit Ajaib PHP" [cite: 194]
     location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/run/php/php8.4-fpm.sock;
     }
 }
```

7. Tes "Aturan Penjaga Gerbang" 
```
nginx -t
```
8. "Nyalakan Penjaga Gerbang" 
```
service nginx restart
service php8.4-fpm restart
```

- Step 2:  'Celeborn' (Gerbang 8005)

1. Atur "Jasa Titip" (Proxy)
```
echo 'Acquire::http::Proxy "http://192.221.5.2:3128";' > /etc/apt/apt.conf.d/99proxy.conf
echo 'Acquire::https::Proxy "http://192.221.5.2:3128";' >> /etc/apt/apt.conf.d/99proxy.conf
```
2. Atur "Buku Telepon" (DNS)
```
echo "nameserver 192.221.5.2" > /etc/resolv.conf
echo "nameserver 192.221.3.2" >> /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf
```
3. Download "Katalog Harga" & 4. "Belanja" Alat Taman
```
apt-get update
apt-get install nginx php8.4-fpm -y
```
5. Buat file "Plang Nama"
```
nano /var/www/html/index.php
# isian nano: /var/www/html/index.php ===
```
```
<?php
# echo "Ini adalah Taman Digital " . gethostname();
?>
```
6. Buka "Buku Aturan Penjaga Gerbang"
```
nano /etc/nginx/sites-available/default
```
isian nano: /etc/nginx/sites-available/default 
 (Hapus semua isi lama, ganti dengan ini)
```
server {
#     # BEDA 1: "Gerbang Masuk" di 8005 [cite: 195]
     listen 8005;
 
     root /var/www/html;
     index index.php index.html;
 
#     # BEDA 2: "Nama" Taman (dari soal4.sh)
     server_name celeborn.k20.com; 
 
#     # (Sisanya SAMA...)
     if ($host != $server_name) {
         return 404;
     }
     location / {
         try_files $uri $uri/ =404;
     }
     location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/run/php/php8.4-fpm.sock;
     }
 }
```

7. Tes "Aturan Penjaga Gerbang"
```
nginx -t
```
8. Nyalakan "Penjaga Gerbang"
```
service nginx restart
service php8.4-fpm restart
```

- Step 3: 'Oropher' (Gerbang 8006)
```
# 1. Atur "Jasa Titip" (Proxy)
echo 'Acquire::http::Proxy "http://192.221.5.2:3128";' > /etc/apt/apt.conf.d/99proxy.conf
echo 'Acquire::https::Proxy "http://192.221.5.2:3128";' >> /etc/apt/apt.conf.d/99proxy.conf

# 2. Atur "Buku Telepon" (DNS)
echo "nameserver 192.221.5.2" > /etc/resolv.conf
echo "nameserver 192.221.3.2" >> /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf

# 3. Download "Katalog Harga" & 4. "Belanja" Alat Taman
apt-get update
apt-get install nginx php8.4-fpm -y

# 5. Buat file "Plang Nama"
nano /var/www/html/index.php

# isian nano: /var/www/html/index.php ===
 <?php
# echo "Ini adalah Taman Digital " . gethostname();
 ?>

# 6. Buka "Buku Aturan Penjaga Gerbang"
nano /etc/nginx/sites-available/default

# isian nano: /etc/nginx/sites-available/default ===
# (Hapus semua isi lama, ganti dengan ini)

 server {
#     # BEDA 1: "Gerbang Masuk" di 8006 [cite: 195]
     listen 8006;
 
     root /var/www/html;
     index index.php index.html;
 
#     # BEDA 2: "Nama" Taman (dari soal4.sh)
     server_name oropher.k20.com; 
 
#     # (Sisanya SAMA...)
     if ($host != $server_name) {
         return 404;
     }
     location / {
         try_files $uri $uri/ =404;
     }
     location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/run/php/php8.4-fpm.sock;
     }
 }

# 7. Tes "Aturan Penjaga Gerbang"
nginx -t

# 8. Nyalakan "Penjaga Gerbang" dan "Aktifkan Bibit Ajaib"
service nginx restart
service php8.4-fpm restart
```

- Step 4: testin jalankan di miriel
```
# 1. Atur "Buku Telepon" (DNS)
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf

# 2. "Belanja" Alat Tes (curl), kalau belum
# (Kita perlu 'apt update' dan 'proxy' dulu, sama kayak di atas)
echo 'Acquire::http::Proxy "http://192.221.5.2:3128";' > /etc/apt/apt.conf.d/99proxy.conf
apt-get update
apt-get install curl -y


- Testing 
# Ini membuktikan Soal 13 (port unik) & Soal 12 (PHP) bekerja.
echo "--- TES 1:panggil nama (HARUS BERHASIL) ---"
curl http://galadriel.k20.com:8004
curl http://celeborn.k20.com:8005
curl http://oropher.k20.com:8006

echo "--- TES 2: panggil pakai IP 
curl http://192.221.2.6:8004
curl http://192.221.2.5:8005
curl http://192.221.2.4:8006
```
# Soal 14
- Memasang  (Basic Authentication)
- User: noldor
- Pass: silvan

- Step 1: TAMAN 'Galadriel' (Gerbang 8004)
 1. Install alat 'htpasswd'
```
apt-get install apache2-utils -y
```
 2. Buat folder "Brankas" untuk file password
```
mkdir /etc/nginx/rahasia
```
 3. Buat file password & user 'noldor'
 (Ketik 'silvan' 2x)
```
htpasswd -c /etc/nginx/rahasia/.htpasswd noldor
```
# 4. Edit konfigurasi nginx
```
nano /etc/nginx/sites-available/default
```
~ (File: /etc/nginx/sites-available/default di Galadriel)
```
# server {
#     listen 8004;
#     root /var/www/html;
#     index index.php index.html;
#     server_name galadriel.k20.com; 
# 
#     # --- TAMBAHAN SOAL 14 ---
#     auth_basic "Taman Terlarang! Password?";
#     auth_basic_user_file /etc/nginx/rahasia/.htpasswd;
#     # -----------------------
# 
#     if ($host != $server_name) {
#         return 404;
#     }
#     location / {
#         try_files $uri $uri/ =404;
#     }
#     location ~ \.php$ {
#         include snippets/fastcgi-php.conf;
#         fastcgi_pass unix:/run/php/php8.4-fpm.sock;
#     }
# }
```
 5. Terapkan "Aturan Satpam" baru
```
nginx -t
service nginx restart
```
- Step 2:'Celeborn' (Gerbang 8005)

 1. Install alat 'htpasswd'
```
apt-get install apache2-utils -y
```
 2. Buat "Brankas"
```
mkdir /etc/nginx/rahasia
```
 3. Buat file password
```
htpasswd -c /etc/nginx/rahasia/.htpasswd noldor
(Ketik 'silvan' 2x)

 5. Edit konfigurasi nginx
```
nano /etc/nginx/sites-available/default
```
~ (File: /etc/nginx/sites-available/default di Celeborn)
```
# server {
#     listen 8005;
#     root /var/www/html;
#     index index.php index.html;
#     server_name celeborn.k20.com; 
# 
#     # --- TAMBAHAN SOAL 14 ---
#     auth_basic "Taman Terlarang! Password?";
#     auth_basic_user_file /etc/nginx/rahasia/.htpasswd;
#     # -----------------------
# 
#     if ($host != $server_name) {
#         return 404;
#     }
#     location / {
#         try_files $uri $uri/ =404;
#     }
#     location ~ \.php$ {
#         include snippets/fastcgi-php.conf;
#         fastcgi_pass unix:/run/php/php8.4-fpm.sock;
#     }
# }
```

 5. Terapkan "Aturan Satpam" baru
```
nginx -t
service nginx restart
```

- Step 3: 'Oropher' (Gerbang 8006)
 1. Install alat 'htpasswd'
```
apt-get install apache2-utils -y
```
```
 2. Buat "Brankas"
```
mkdir /etc/nginx/rahasia
```
3. Buat file password
```
htpasswd -c /etc/nginx/rahasia/.htpasswd noldor
```
```
(Ketik 'silvan' 2x)

 4. Edit konfigurasi nginx
```
nano /etc/nginx/sites-available/default
```

~ (File: /etc/nginx/sites-available/default di Oropher)
```
# server {
#     listen 8006;
#     root /var/www/html;
#     index index.php index.html;
#     server_name oropher.k20.com; 
# 
#    #soal14
#     auth_basic "Taman Terlarang! Password?";
#     auth_basic_user_file /etc/nginx/rahasia/.htpasswd;
#     
# 
#     if ($host != $server_name) {
#         return 404;
#     }
#     location / {
#         try_files $uri $uri/ =404;
#     }
#     location ~ \.php$ {
#         include snippets/fastcgi-php.conf;
#         fastcgi_pass unix:/run/php/php8.4-fpm.sock;
#     }
# }
```

 5. Terapkan "Aturan Satpam" baru
```
nginx -t
service nginx restart
```

- Step 4: Test (Miriel)
1.
```
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf
```
2.  (Tanpa Password) - output 401
```
curl http://galadriel.k20.com:8004
curl http://celeborn.k20.com:8005
curl http://oropher.k20.com:8006
```
3. (Pakai Password) - output OK
```
curl -u noldor:silvan http://galadriel.k20.com:8004
curl -u noldor:silvan http://celeborn.k20.com:8005
curl -u noldor:silvan http://oropher.k20.com:8006
```
