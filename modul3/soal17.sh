# SOAL 17
# Benchmark (Uji Beban) & Simulasi Gagal

# 1. Menyerang Pharazon (Load Balancer) dengan 'ab'.
# 2. Mematikan 1 "Taman" (Galadriel).
# 3. Menyerang Pharazon lagi untuk melihat apakah dia "pinter".

# BAGIAN 1:
# (Dijalankan di console 'Miriel')

# 1. Atur (Proxy) permanen
echo 'Acquire::http::Proxy "http://192.221.5.2:3128";' > /etc/apt/apt.conf.d/99proxy.conf
echo 'Acquire::https::Proxy "http://192.221.5.2:3128";' >> /etc/apt/apt.conf.d/99proxy.conf

# 2. Atur  (DNS Erendis)
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf

# 3. "Belanja" Alat Penyerbu ('ab' ada di sini)
apt-get update
apt-get install apache2-utils -y

# BAGIAN 2: 
# (Dijalankan di console 'Miriel')

# 1. Serang Pharazon (pakai -A untuk password, BUKAN -u)
# (Hasil harusnya 'Failed requests: 0')
echo "--- TES 1: SERANGAN SAAT SEMUA 'TAMAN' BUKA ---"
ab -n 100 -c 10 -A noldor:silvan http://pharazon.k20.com/

# BAGIAN 3: 
# 1. "Matikan" Taman Galadriel
echo "--- MEMATIKAN 'TAMAN' GALADRIEL ---"
service nginx stop

# BAGIAN 4: test serangan
# (Dijalankan di console 'Miriel')

# 1. Serang Pharazon lagi
# (Hasil harusnya 'Failed requests: 0' atau ADA)
# (Kedua hasil = BENAR)
echo "--- TES 2: SERANGAN SAAT 1 'TAMAN' RUNTUH ---"
ab -n 100 -c 10 -A noldor:silvan http://pharazon.k20.com/

# BAGIAN 5:
# 1. Cek log error 'Pharazon'
# (HARUS muncul error 'Connection refused' ke 'upstream' Galadriel) [cite: 204]
echo "--- MENGECEK LOG ERROR DI PHARAZON ---"
cat /var/log/nginx/error.log


# BAGIAN 6
# 1. "Nyalakan" kembali Taman Galadriel
echo "--- MENGHIDUPKAN KEMBALI 'TAMAN' GALADRIEL ---"
service nginx start
