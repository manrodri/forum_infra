#!/bin/bash

sudo apt-get update
# install mariadab, git, zip and nginx
sudo apt install  git zip unzip -y
sudo apt install nginx -y
sudo apt install mariadb-server -y
apt  install awscli -y

# install php and php dependencies
sudo apt-get install php php-mbstring php-xml php-bcmath php-fpm php-mysql  -y
sudo apt purge  apache2 -y


#install composer
sudo apt install -y composer


sudo useradd -m deploy
sudo usermod -aG sudo deploy

sudo mkdir /sites
cd /sites
sudo git clone https://github.com/manrodri/forum.git
sudo chown -R deploy:deploy /home/deploy/forum

APP_HOME=/sites/forum
sudo chown -R deploy:deploy ${APP_HOME}
sudo chown -R www-data:www-data ${APP_HOME}/storage
sudo chown -R www-data:www-data ${APP_HOME}/bootstrap/cache


# configure mysql
export DATABASE_PASS='admin123'

# get forum app
cd /sites
git clone https://github.com/manrodri/forum.git
sudo chown -R deploy:deploy /home/deploy/forum

# starting & enabling mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb


#restore the dump file for the application
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('forumdb') WHERE User='root'"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES";
sudo mysql -u root -p"$DATABASE_PASS" -e "create database forumdb"
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE USER forumdb_user@'%' IDENTIFIED BY 'password2022'"

sudo mysql -u root -p"$DATABASE_PASS" -e "grant all on forumdb.* TO 'forumdb_user'@'%'";
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart mariadb-server
sudo systemctl restart mariadb

# configure nginx
cat <<EOT > forum
server {
    listen 80;
    listen [::]:80;
    server_name staging.manrodri.com;
    root /sites/forum/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php index.html;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOT

sudo mv forum /etc/nginx/sites-available/forum.conf
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/forum.conf /etc/nginx/sites-enabled/forum.conf

#starting nginx service
sudo systemctl enable --now nginx


# deploy user
sudo usermod -aG sudo deploy
echo 'deploy ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/deploy


