sudo apt-get update
sudo apt-get  install -y git zip unzip 
sudo apt install mariadb-server

DATABASE_PASS='admin123'
DATABAE_NAME = 'forum'



cd /tmp/
git clone https://github.com/manrodri/forum_infra.git

# Install maria-db


# starting & enabling mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb


#restore the dump file for the application
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root'"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database ${DATABASE_NAME}"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on ${DATABASE_NAME}.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on ${DATABASE_NAME}.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" ${DATABASE_NAME} < /tmp/vprofile-repo/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"