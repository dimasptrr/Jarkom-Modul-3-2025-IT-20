##SOAL 14
# Memasang  (Basic Authentication)
# User: noldor
# Pass: silvan

# BAGIAN 1: TAMAN 'Galadriel' (Gerbang 8004)
# 1. Install alat 'htpasswd'
apt-get install apache2-utils -y

# 2. Buat folder "Brankas" untuk file password
mkdir /etc/nginx/rahasia

# 3. Buat file password & user 'noldor'
# (Ketik 'silvan' 2x)
htpasswd -c /etc/nginx/rahasia/.htpasswd noldor

# 4. Edit konfigurasi nginx
nano /etc/nginx/sites-available/default

# (File: /etc/nginx/sites-available/default di Galadriel)

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

# 5. Terapkan "Aturan Satpam" baru
nginx -t
service nginx restart



# BAGIAN 2:'Celeborn' (Gerbang 8005)

# 1. Install alat 'htpasswd'
apt-get install apache2-utils -y

# 2. Buat "Brankas"
mkdir /etc/nginx/rahasia

# 3. Buat file password
htpasswd -c /etc/nginx/rahasia/.htpasswd noldor
# (Ketik 'silvan' 2x)

# 4. Edit konfigurasi nginx
nano /etc/nginx/sites-available/default

# (File: /etc/nginx/sites-available/default di Celeborn)
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

# 5. Terapkan "Aturan Satpam" baru
nginx -t
service nginx restart

# BAGIAN 3: 'Oropher' (Gerbang 8006)
# 1. Install alat 'htpasswd'
apt-get install apache2-utils -y

# 2. Buat "Brankas"
mkdir /etc/nginx/rahasia

# 3. Buat file password
htpasswd -c /etc/nginx/rahasia/.htpasswd noldor
# (Ketik 'silvan' 2x)

# 4. Edit konfigurasi nginx
nano /etc/nginx/sites-available/default

# (File: /etc/nginx/sites-available/default di Oropher)

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

# 5. Terapkan "Aturan Satpam" baru
nginx -t
service nginx restart

# BAGIAN 4: test miriel
# 1.
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "search k20.com" >> /etc/resolv.conf

# 2.  (Tanpa Password) - output 401
curl http://galadriel.k20.com:8004
curl http://celeborn.k20.com:8005
curl http://oropher.k20.com:8006

# 3. (Pakai Password) - output OK
curl -u noldor:silvan http://galadriel.k20.com:8004
curl -u noldor:silvan http://celeborn.k20.com:8005
curl -u noldor:silvan http://oropher.k20.com:8006
