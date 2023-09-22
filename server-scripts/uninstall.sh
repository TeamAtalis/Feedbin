# Define colors for the script
Color_Off='\033[0m'       # Text Reset
Green='\033[0;32m'        # Green
Blue='\033[0;34m'         # Blue

echo -e "${Green}Remove postgres${Color_Off}"
sudo apt remove postgresql postgresql-contrib -y
sudo apt autoremove

echo -e "${Green}Remove redis-server${Color_Off}"
apt-get purge --auto-remove redis-server -y

echo -e "${Green}Uninstall ruby${Color_Off}"
sudo apt-get purge ruby -y


echo -e "${Green}Uninstall gems dependences${Color_Off}"
sudo apt-get remove libpq-dev
sudo apt-get purge libpq-dev -y

sudo apt-get remove libldap2-dev
sudo apt-get purge libldap2-dev -y

sudo apt-get remove libidn11-dev
sudo apt-get purge libidn11-dev -y

sudo apt-get remove libvips
sudo apt-get purge libvips -y

echo "${Green}Remove Node${Color_Off}"
sudo apt-get remove nodejs
sudo apt-get purge nodejs
