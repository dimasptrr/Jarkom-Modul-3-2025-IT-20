# Soal 12 & 13

- Step 0 :
# 1. Nyalain "Saklar Jasa Titip" (Proxy)
# (Di console 'Minastir')
```
service squid start
```
# 2. Nyalain "Saklar Kantor Telepon Utama" (DNS Master)
# (Di console 'Erendis')
```
service bind9 start
``` 

# 3. Nyalain "Saklar Kantor Telepon Cadangan" (DNS Slave)
# (Di console 'Amdir')
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
# isian nano: /etc/nginx/sites-available/default ===
# (Hapus semua isi lama, ganti dengan ini)
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
