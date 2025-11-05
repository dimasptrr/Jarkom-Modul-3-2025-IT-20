# SOAL 16
# Memasang (Reverse Proxy) Pharazon
#
# BAGIAN 1:
# (Dijalankan di console 'Galadriel', 'Celeborn', DAN 'Oropher')

# 1. Buka "Buku Aturan Penjaga Gerbang" (nginx)
nano /etc/nginx/sites-available/default

# (File: /etc/nginx/sites-available/default di Galadriel/Celeborn/Oropher)
#
# (Cari dan HAPUS atau beri '#' pada 3 baris "Satpam Pintu" Soal 12)
#
#     # if ($host != $server_name) {
#     #     return 404;
#     # }


# 2. Terapkan Perubahan
nginx -t
service nginx restart

# BAGIAN 2:  'Pharazon'

# 1. Atur "Jasa Titip" (Proxy) permanen
echo 'Acquire::http::Proxy "http://192.221.5.2:3128";' > /etc/apt/apt.conf.d/99proxy.conf
echo 'Acquire::https::Proxy "http://192.221.5.2:3128";' >> /etc/apt/apt.conf.d/99proxy.conf

# 2. Atur "Buku Telepon" (DNS)
echo "nameserver 192.221.5.2" > /etc/resolv.conf
echo "nameserver 192.221.3.2" >> /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf

# 3. "Belanja" Alat (Install Nginx)
apt-get update
apt-get install nginx -y

# 4. Buat "Buku Aturan Tukang Anter Tamu"
nano /etc/nginx/sites-available/default

# (File: /etc/nginx/sites-available/default di Pharazon)
# (HAPUS semua isi lama, ganti dengan ini. Ganti k20.com)
#
# # Soal 16: "Daftar Taman" (Pakai NAMA, bukan IP)
# upstream Kesatria_Lorien {
#     server galadriel.k20.com:8004;
#     server celeborn.k20.com:8005;
#     server oropher.k20.com:8006;
# }
# 
# server {
#     listen 80;
#     server_name pharazon.k20.com;
# 
#     location / {
#         [cite_start]# 1. Antar Tamu ke "Daftar Taman" [cite: 201]
#         proxy_pass http://Kesatria_Lorien;
#         
#         [cite_start]# 2. (SOAL 16) Teruskan "Password" Tamu [cite: 201]
#         proxy_set_header Authorization $http_authorization;
#         
#         [cite_start]# 3. (SOAL 15) Bikin "Surat Rahasia" IP Asli [cite: 198]
#         proxy_set_header X-Real-IP $remote_addr;
#         proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#     }
# }
#

# 5. "Suruh Jaga"
nginx -t
service nginx restart


# BAGIAN 3: testing (miriel)

# 1. (WAJIB) Atur "Buku Telepon" (DNS Erendis)
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf

# 2. Tes "Gerbang Utama" Pharazon (Pakai Password Soal 14)
echo "--- TES GERBANG UTAMA (HARUS BERHASIL) ---"
curl -u noldor:silvan http://pharazon.k20.com

#OUTPUT:
# (Akan muncul salah satu dari 3 Taman, dengan IP Asli Miriel)
#
# Ini adalah Taman Digital Galadriel<br>IP Asli Pengunjung: 192.221.1.5
# ATAU
# Ini adalah Taman Digital Celeborn<br>IP Asli Pengunjung: 192.221.1.5
# ATAU
# Ini adalah Taman Digital Oropher<br>IP Asli Pengunjung: 192.221.1.5
