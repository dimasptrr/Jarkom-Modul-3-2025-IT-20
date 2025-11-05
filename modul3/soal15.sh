# SOAL 15
# Meng-upgrade "Taman" untuk Mendeteksi IP Asli Pengunjung

# BAGIAN 1: 🧝‍♀️ UPGRADE TAMAN 'Galadriel'
# (Dijalankan di console 'Galadriel,celeborn,oropher')

# 1. Buka "Buku Aturan Penjaga Gerbang" (nginx)
nano /etc/nginx/sites-available/default

# (File: /etc/nginx/sites-available/default di Galadriel)
#
# (Cari blok 'location ~ \.php$ { ... }')
#
#     location ~ \.php$ {
#         # tambhakan
#         fastcgi_param X_REAL_IP $remote_addr;
# 
#         include snippets/fastcgi-php.conf;
#         fastcgi_pass unix:/run/php/php8.4-fpm.sock;
#     }


# 2. Buka file "Plang Nama" (index.php)
nano /var/www/html/index.php

# (File: /var/www/html/index.php di Galadriel)
# (Hapus semua isi lama, ganti dengan ini)
#
# <?php
# echo "Ini adalah Taman Digital " . gethostname() . "<br>";
# 
# // Soal 15: Baca "Surat Rahasia" (X_REAL_IP)
# // Jika belum ada, pakai IP tamu biasa (REMOTE_ADDR)
# $ip_asli = $_SERVER['X_REAL_IP'] ?? $_SERVER['REMOTE_ADDR'];
# 
# echo "IP Asli Pengunjung: " . $ip_asli;
# ?>


# 3. Terapkan Perubahan (Restart Nginx & PHP)
nginx -t
service nginx restart
service php8.4-fpm restart


# BAGIAN 2: testing

# 1.Atur (DNS Erendis)
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf

# 2. 
curl -u noldor:silvan http://galadriel.k20.com:8004
curl -u noldor:silvan http://celeborn.k20.com:8005
curl -u noldor:silvan http://oropher.k20.com:8006

# OUTPUT:
# (IP Asli adalah IP-nya Miriel, 192.221.1.5, sesuai soal1.sh)

# Ini adalah Taman Digital Galadriel<br>IP Asli Pengunjung: 192.221.1.5
# Ini adalah Taman Digital Celeborn<br>IP Asli Pengunjung: 192.221.1.5
# Ini adalah Taman Digital Oropher<br>IP Asli Pengunjung: 192.221.1.5
