SOAL 19: Rate Limiting pada Elros dan Pharazon
Perintah Soal: Implementasikan rate limiting pada kedua Load Balancer (Elros dan Pharazon) menggunakan Nginx. Batasi agar satu alamat IP hanya bisa melakukan 10 permintaan per detik. Uji coba dengan menjalankan ab dari satu client dengan konkurensi tinggi (-c 50 atau lebih) dan periksa log Nginx untuk melihat pesan request yang ditolak atau ditunda karena rate limit.

TAHAPAN PENGERJAAN
1. Pasang Aturan Tol Utama (Global)
(Lakukan di console Elros DAN Pharazon)

Bash

# 1. Buka File Konfigurasi Nginx Utama
nano /etc/nginx/nginx.conf
Bash

# 2. Tambahkan Aturan Tol Utama (di dalam blok 'http { ... }')
# Mendefinisikan zona rate limit: 10 request per detik per IP
limit_req_zone $binary_remote_addr zone=batasin_ip:10m rate=10r/s;
2. Terapkan Gerbang Tol (Server Lokal)
(Lakukan di console Elros DAN Pharazon)

Bash

# 1. Buka File Konfigurasi Server Lokal (Gerbang Utama)
nano /etc/nginx/sites-available/default
Bash

# 2. Terapkan Aturan Tol (di dalam blok 'location / { ... }')
# Menerapkan zona limit yang sudah didefinisikan
limit_req zone=batasin_ip;
3. Nyalakan Benteng
(Lakukan di console Elros DAN Pharazon)

Bash

# 1. Cek Syntax dan Restart Nginx
nginx -t
service nginx restart
4. Uji Coba Serangan Massal (Verifikasi)
(Di console Miriel - Client)

Bash

# 1. Serang Elros (Worker Laravel) - Memicu Rate Limit
# Kita uji dengan konkurensi 50 (jauh di atas batas 10/detik) 
ab -n 200 -c 50 http://elros.k20.com/api/airing
(Di console Elros)

Bash

# 2. Cek Log Nginx (Mencari bukti penolakan/penundaan request)
# Pesan ini menandakan Rate Limiting sedang bekerja
cat /var/log/nginx/error.log | grep "limiting requests"

Verifikasi: Log harus menunjukkan pesan delaying request atau rejecting request.