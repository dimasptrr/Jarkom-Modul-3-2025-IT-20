Alur Pengerjaan Soal 7: Setup Laravel Worker
Target Node:

Elendil (192.221.1.2)

Isildur (192.221.1.3)

Anarion (192.221.1.4)


# 1. Konfigurasi DNS (Menggunakan Minastir BIND9 sebagai utama, Erendis sebagai internal)
# Minastir BIND9 (192.221.5.2) harus sudah dikonfigurasi untuk forward K20.com ke 3.2/3.3
echo "nameserver 192.221.5.2" > /etc/resolv.conf 
echo "nameserver 192.221.3.2" >> /etc/resolv.conf # Fallback Internal
echo "search K20.com" >> /etc/resolv.conf

# 2. Update & Instalasi Tools (Akses langsung ke internet via NAT Durin)
apt update
apt install nginx php8.4-fpm php8.4-mbstring php8.4-xml php8.4-curl composer git -y

# 3. Hapus Environment Proxy (Pastikan tidak ada loop)
unset http_proxy
unset https_proxy


# 1. Pindah ke direktori web
cd /var/www/

git config --global --unset http.proxy
git config --global --unset https.proxy

# 3. Clone Repositori (Cetak Biru Benteng)
git clone https://github.com/elshiraphine/laravel-simple-rest-api.git
cd laravel-simple-rest-api

# 4. Instal Dependensi (Perbaikan Kompatibilitas PHP 8.4)
# Perintah 'update' wajib karena PHP 8.4 Anda terlalu baru untuk file lock lama
# Pastikan variabel proxy sudah tersetting di terminal ini
composer update

# 5. Final Setup Laravel
cp .env.example .env
php artisan key:generate

# 6. Atur Izin Folder (agar Nginx bisa menulis cache)
chown -R www-data:www-data storage/ bootstrap/cache/

# (Di Elendil, Isildur, & Anarion)
nano /etc/nginx/sites-available/default

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


# (Di Elendil, Isildur, & Anarion)
service nginx restart
service php8.4-fpm restart

#diketiga node (elendil,isildur,anarion) tes
curl http://127.0.0.1


