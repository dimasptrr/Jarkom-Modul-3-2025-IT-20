SOAL 18
 Konfigurasikan replikasi database Master-Slave menggunakan MariaDB. Jadikan Palantir sebagai Master. Konfigurasikan Narvi sebagai Slave yang secara otomatis menyalin semua data dari Palantir. Buktikan replikasi berhasil dengan membuat tabel baru di Master dan memeriksanya di Slave.

TAHAPAN PENGERJAAN
1. Persiapan Node Slave (Narvi)
(Di console Narvi)

Bash

# Instalasi MariaDB (jika belum)
apt-get update
apt-get install mariadb-server -y
2. Konfigurasi Master (Palantir)
(Di console Palantir)

Bash

# 1. Atur Master ID dan Log Binary
nano /etc/mysql/mariadb.conf.d/50-server.cnf
# Pastikan di bawah [mysqld]:
# server-id       = 1
# log-bin         = mysql-bin
# bind-address    = 0.0.0.0
Bash

# 2. Restart MariaDB
service mariadb restart
Bash

# 3. Buat User Replikasi dan Catat Posisi
mysql -u root
# Di dalam mysql>:
CREATE USER 'replikator'@'192.221.4.4' IDENTIFIED BY 'passwordrahasia';
GRANT REPLICATION SLAVE ON *.* TO 'replikator'@'192.221.4.4';
FLUSH PRIVILEGES;
SHOW MASTER STATUS;
# (CATAT FILE DAN POSITION YANG MUNCUL)
EXIT;
3. Konfigurasi Slave (Narvi)
(Di console Narvi)

Bash

# 1. Atur Slave ID
nano /etc/mysql/mariadb.conf.d/50-server.cnf
# Pastikan di bawah [mysqld]:
# server-id       = 2
Bash

# 2. Restart MariaDB
service mariadb restart
Bash

# 3. Sambungkan ke Master (GANTI DATA YANG DICATAT!)
mysql -u root
# Di dalam mysql>:
CHANGE MASTER TO
  MASTER_HOST='192.221.4.3',
  MASTER_USER='replikator',
  MASTER_PASSWORD='passwordrahasia',
  MASTER_LOG_FILE='<FILE_DARI_PALANTIR>', 
  MASTER_LOG_POS=<POSISI_DARI_PALANTIR>;
START SLAVE;
EXIT;
4. Verifikasi Replikasi
(Di console Narvi)

Bash

# 1. Cek Status (Harus Slave_IO_Running: Yes dan Slave_SQL_Running: Yes)
mysql -u root
# Di dalam mysql>:
SHOW SLAVE STATUS\G
EXIT;
(Di console Palantir - Master)

Bash

# 2. Buat Database Uji Coba di Master
mysql -u root
# Di dalam mysql>:
CREATE DATABASE tes_replikasi_berhasil;
EXIT;
(Di console Narvi - Slave)

Bash

# 3. Cek Database Uji Coba di Slave (Harus muncul)
mysql -u root
# Di dalam mysql>:
SHOW DATABASES;
EXIT;