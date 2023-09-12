# Define colors for the script
Color_Off='\033[0m'       # Text Reset
Green='\033[0;32m'        # Green
Blue='\033[0;34m'         # Blue

echo -e "${Green}Remove postgres${Color_Off}"
sudo apt remove postgresql postgresql-contrib -y
sudo apt autoremove