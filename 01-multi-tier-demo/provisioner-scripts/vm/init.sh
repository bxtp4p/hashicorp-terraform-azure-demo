sudo apt-get -y update

echo "Installing JRE"
sudo apt-get -y install default-jre
java -version

echo "Installing NGINX"
sudo apt-get -y install nginx

echo "Updating Firewall"
sudo ufw allow 'Nginx HTTP'

