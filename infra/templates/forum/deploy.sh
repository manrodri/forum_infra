# edit .env file.  copy .env.example to .env
cp .env.example .env
# install dependencies
composer install --optimize-autoloader --no-dev # generate app key
php aritsan key:gen
# db migration
php aritsan migrate


upstream vproapp {
 server appserver.com:8080;
}
server {
  listen 80;
location / {
  proxy_pass http://vproapp;
}
}
