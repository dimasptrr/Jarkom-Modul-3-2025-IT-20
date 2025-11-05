apt update
apt install nginx php8.4-fpm php8.4-mysql git -y

#di elros
 nano /etc/nginx/sites-available/elros.conf

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

#masukkan nameserver di elros dan amandil
192.221.3.2

 # 1. Buat symlink untuk mengaktifkan konfigurasi
 ln -s /etc/nginx/sites-available/elros.conf /etc/nginx/sites-enabled/

 # 2. Uji sintaks konfigurasi Nginx
 nginx -t

 # 3. Muat ulang layanan Nginx
 service nginx restart

 # di amandil
 # Uji permintaan pertama (harus ke Elendil:8001)
 curl -s -o /dev/null -w "Status: %{http_code}\nWorker: %{remote_port}\n" http://elros.K20.com/

# Uji permintaan kedua (harus ke Isildur:8002)
 curl -s -o /dev/null -w "Status: %{http_code}\nWorker: %{remote_port}\n" http://elros.K20.com/

# Uji permintaan ketiga (harus ke Anarion:8003)
 curl -s -o /dev/null -w "Status: %{http_code}\nWorker: %{remote_port}\n" http://elros.K20.com/