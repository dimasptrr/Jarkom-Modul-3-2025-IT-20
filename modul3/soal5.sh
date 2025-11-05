# (Di node Erendis)
nano /etc/bind/db.K20.com

#ubah file db.K20.com menjadi seperti ini:
@       IN      SOA     ns1.K20.com. root.K20.com. (
                      2         ; Serial (NAIKKAN ANGKA INI)

#tambahkan record baru ini juga

; ... (daftar IP A record dari soal 4) ...

; --- Soal 5: Alias (CNAME) ---
www     IN      CNAME   K20.com.

; --- Soal 5: Pesan Rahasia (TXT) ---
; "Cincin Sauron" -> elros.K20.com
@       IN      TXT     "Cincin Sauron=elros.K20.com"

; "Aliansi Terakhir" -> pharazon.K20.com
@       IN      TXT     "Aliansi Terakhir=pharazon.K20.com"

#Definisikan Zona Reverse
nano /etc/bind/named.conf.local

zone "3.221.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.221.3"; // File "peta terbalik"
    allow-transfer { 192.221.3.3; }; // Izinkan Amdir menyalin
};

#Buat File "Peta Terbalik"
nano /etc/bind/db.192.221.3

; (File: /etc/bind/db.192.221.3 di Erendis)
$TTL    604800
@       IN      SOA     ns1.K20.com. root.K20.com. (
                      1         ; Serial
                      604800    ; Refresh
                      86400     ; Retry
                      2419200   ; Expire
                      604800 )  ; Negative Cache TTL
;
; --- Name Servers ---
@       IN      NS      ns1.K20.com.
@       IN      NS      ns2.K20.com.

; --- PTR Records (IP ke Nama) ---
; (Perhatikan: Hanya angka terakhir dari IP)
2       IN      PTR     ns1.K20.com.    ; (192.221.3.2)
3       IN      PTR     ns2.K20.com.    ; (192.221.3.3)

# (Di node Amdir)
nano /etc/bind/named.conf.local

zone "3.221.192.in-addr.arpa" {
    type slave;
    file "/var/lib/bind/db.192.221.3";
    masters { 192.221.3.2; };
};

# (Di Erendis)
named-checkconf

# Cek file forward (yang di-edit)
named-checkzone K20.com /etc/bind/db.K20.com

# Cek file reverse (yang baru)
named-checkzone 3.221.192.in-addr.arpa /etc/bind/db.192.221.3


# (Di Erendis)
service bind9 restart

# (Di Amdir)
service bind9 restart

# (Di node Amandil)
echo "nameserver 192.221.3.2" > /etc/resolv.conf
echo "nameserver 192.221.3.3" >> /etc/resolv.conf
echo "search K20.com" >> /etc/resolv.conf

# (Di node Amandil)

# Tes 1: Cek Alias (CNAME)
nslookup www.K20.com

# Tes 2: Cek Pesan Rahasia (TXT)
nslookup -type=TXT K20.com

# Tes 3: Cek Peta Terbalik (PTR)
nslookup 192.221.3.2
nslookup 192.221.3.3


:'
Hasil yang Diharapkan:
Tes 1 (CNAME): Akan menampilkan...

www.K20.com     canonical name = K20.com.
Name:   K20.com
Address: [IP Erendis/Amdir, atau IP lain jika Anda set A record untuk @]
Tes 2 (TXT): Akan menampilkan...

K20.com text = "Cincin Sauron=elros.K20.com"
K20.com text = "Aliansi Terakhir=pharazon.K20.com"
Tes 3 (PTR): Akan menampilkan...

2.3.221.192.in-addr.arpa      name = ns1.K20.com.
3.3.221.192.in-addr.arpa      name = ns2.K20.com.'