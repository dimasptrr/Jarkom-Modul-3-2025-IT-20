# (Di node Amandil)
apt update
apt install apache2-utils -y

# (Di node Worker: Elendil, Isildur, Anarion)
# Buka sesi terpisah (separate terminal window) di setiap worker 
# untuk memantau kondisi mereka selama serangan.
htop

# (Di node Amandil)
echo "--- SERANGAN AWAL (100 permintaan, 10 bersamaan) ---"

ab -n 100 -c 10 -u netics:ajk20 http://elros.K20.com/api/airing

# (Di node Amandil)
echo "--- SERANGAN PENUH (2000 permintaan, 100 bersamaan - BASELINE) ---"

ab -n 2000 -c 100 -u netics:ajk20 http://elros.K20.com/api/airing

# (Di node Elros)
nano /etc/nginx/sites-available/default

# --- 1. Definisikan Upstream dengan Weight ---
upstream laravel_workers {
    server 192.221.1.2:8001 weight=2; # Elendil menerima beban 2x lebih besar
    server 192.221.1.3:8002 weight=1; # Isildur menerima beban normal
    server 192.221.1.4:8003 weight=1; # Anarion menerima beban normal
}
# ... (Sisanya tetap sama) ...

# (Di node Elros)
service nginx restart

# (Di node Amandil)
echo "--- SERANGAN PENUH (2000 permintaan, 100 bersamaan - BERAT) ---"

ab -n 2000 -c 100 -u netics:ajk20 http://elros.K20.com/api/airing

#Catat dan Bandingkan:
#Tanpa Weight (Baseline): Catat "Failed requests" dan "Requests per second".
#Dengan Weight (Strategi Bertahan): Catat "Failed requests" dan "Requests per second".