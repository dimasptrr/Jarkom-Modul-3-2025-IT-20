# (Di node Aldarion)
nano /etc/dhcp/dhcpd.conf

# (File: /etc/dhcp/dhcpd.conf di Aldarion)

# --- Opsi Global ---
option domain-name "K20.com";
option domain-name-servers 192.221.3.2, 192.221.3.3; 
default-lease-time 600; # Waktu default (bisa ditimpa per subnet)
max-lease-time 3600;    # Batas Maksimal Global (1 Jam)
authoritative;

# --- Subnet 1: Keluarga Manusia (Setengah Jam) ---
subnet 192.221.1.0 netmask 255.255.255.0 {
    option routers 192.221.1.1;
    range 192.221.1.6 192.221.1.34;
    range 192.221.1.68 192.221.1.94;
    
    # --- TAMBAHKAN INI ---
    default-lease-time 1800; # Setengah Jam
    max-lease-time 3600;     # 1 Jam (sesuai aturan global)
}

# --- Subnet 2: Keluarga Peri (Seperenam Jam) ---
subnet 192.221.2.0 netmask 255.255.255.0 {
    option routers 192.221.2.1;
    range 192.221.2.35 192.221.2.67;
    range 192.221.2.96 192.221.2.121;
    
    # --- TAMBAHKAN INI ---
    default-lease-time 600;  # Seperenam Jam
    max-lease-time 3600;   # 1 Jam
}

# ... (Subnet 3, 4, 5 biarkan seperti semula) ...

# (Di node Aldarion)
service isc-dhcp-server restart

# (Di node Amandil & Gilgalad)
dhclient -r && dhclient -v eth0


cat /var/lib/dhcp/dhclient.leases | grep "lease-time"



# (Di node Aldarion)
cat /var/lib/dhcp/dhcpd.leases