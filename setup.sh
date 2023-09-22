# Define colors for the script
Color_Off='\033[0m'       # Text Reset
Green='\033[0;32m'        # Green
Blue='\033[0;34m'         # Blue

echo -e "${Green}Start installing postgres ${Blue} [sudo apt install postgresql postgresql-contrib] ${Color_Off}"
sudo apt install postgresql postgresql-contrib
echo -e "${Green}Init the postgres service ${Blue} [sudo systemctl start postgresql.service] ${Color_Off}"
sudo systemctl start postgresql.service
echo "FIN"

#sudo systemctl enable postgresql
#sudo systemctl start postgresql
#sudo -u postgres psql
#createuser -U postgres atalisfunding