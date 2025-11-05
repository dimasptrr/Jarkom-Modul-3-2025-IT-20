# (Di node Amandil/Gilgalad)
apt update
apt install apache2-utils -y

# (Di Elendil, Isildur, dan Anarion)
htop

# (Di node Amandil)
echo "--- SERANGAN PENUH (2000 permintaan, 100 bersamaan - BASELINE TANPA WEIGHT) ---"

# Catatan: Karena Anda tidak mencantumkan autentikasi di skrip Soal 10 Anda, 
# kita asumsikan akses API tidak memerlukan username/password.
ab -n 2000 -c 100 http://elros.K20.com/api/airing

# --- Definisikan Upstream dengan Weight ---
upstream kesatria_numenor {
    server elendil.K20.com:8001 weight=2; # Elendil menerima 2x beban
    server isildur.K20.com:8002 weight=1; # Isildur
    server anarion.K20.com:8003 weight=1; # Anarion
}
# ... (Sisanya tetap sama) ...

# (Di node Elros)
service nginx restart

# (Di node Amandil)
echo "--- SERANGAN PENUH (2000 permintaan, 100 bersamaan - DENGAN WEIGHT 2:1:1) ---"

ab -n 2000 -c 100 http://elros.K20.com/api/airing

- Bandingkan metrik "Requests per second" dan "Failed requests" dari kedua tes untuk menarik kesimpulan:

- Jika Requests per second naik dan/atau Failed requests turun, strategi weight LEBIH BAIK.