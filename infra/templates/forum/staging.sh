sudo apt-get update
# install mariadab, git, zip and nginx
sudo apt install  git zip unzip -y
sudo apt install nginx -y
sudo apt install mariadb-server -y
apt  install awscli -y

# install php and php dependencies
sudo apt-get install php php-mbstring php-xml php-bcmath php-fpm php-mysql  -y
sudo apt purge  apache2 -y

sudo php -m > /tmp/php-extensions

#install composer
sudo apt install -y composer


# 1 Create deploy user, add user to sudo group and allow user to run sudo commands without password
# 2 Create ssh key pair, upload key to Gitlab
# 3 clone repo from Gitlab
# 4 mysql_secure_installation

