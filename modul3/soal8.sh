# (Di node Palantir)
# Instal MariaDB Server
apt update
apt install mariadb-server -y

# Palantir butuh PHP MySQL extension agar bisa komunikasi dengan dirinya sendiri
apt install php8.4-mysql -y

# (Di node Palantir)

service mariadb restart

# Masuk ke MySQL (dengan password kosong/default)
mysql -u root

# Jalankan perintah SQL di bawah ini:
CREATE DATABASE laravel_db;
CREATE USER 'laravel_user'@'192.221.1.%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'192.221.1.%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;

# (Di Elendil, Isildur, dan Anarion)
# Perlu extension ini agar Laravel tahu cara bicara dengan MariaDB
apt install php8.4-mysql -y
service php8.4-fpm restart

# (Di Elendil, Isildur, dan Anarion)
nano .env

# --- Ubah Baris Ini ---
DB_CONNECTION=mysql
DB_HOST=palantir.K20.com  # Menggunakan domain Palantir yang sudah dikonfigurasi di DNS
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=password
# --- Akhir Perubahan ---


#konfigurasi nginx
Node	Port Nginx	Server Name
Elendil	8001	elendil.K20.com
Isildur	8002	isildur.K20.com
Anarion	8003	anarion.K20.com

# (Di Elendil, Isildur, dan Anarion)
nano /etc/nginx/sites-available/default

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

#di node palantir
nano /etc/mysql/mariadb.conf.d/50-server.cnf

[mysqld]
# bind-address = 127.0.0.1  <-- Pastikan ini DIHAPUS atau diberi tanda #
bind-address = 0.0.0.0      <-- atau tambahkan/ubah menjadi 0.0.0.0

 service mariadb restart


# (Di Elendil, Isildur, dan Anarion)
service nginx restart

# (HANYA DI NODE ELENDIL)
cd /var/www/laravel-simple-rest-api

# Migrasi Database
php artisan migrate --seed

# (Di node Amandil dan Gilgalad)
#tambahkan nameserver di resolv.conf
nameserver 192.221.3.2(ini ip erendis)
