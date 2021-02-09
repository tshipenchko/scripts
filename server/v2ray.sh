#!/bin/bash 
GREEN='\033[0;32m'      #  ${GREEN}
NORMAL='\033[0m'      #  ${NORMAL}

# root?
if [[ $EUID -ne 0 ]]; then
  echo -e "MUST RUN AS ROOT USER! use sudo"
  exit 1
fi

# open ports
echo "Do you want to open all ports? (y/n)"
read -r open_port
case $open_port in
[yY] | [yY][Ee][Ss] )
	bash <(curl -Ls https://raw.githubusercontent.com/tshipenchko/scripts/main/server/openallports.sh)
	echo "All ports are open now"
	;;
[nN] | [n|N][O|o] )
	echo "Okey, ports are closed"
	;;
*)
	echo "Port won't be open (enter to continue)"
	read -r lol
	;;
esac

# install stuff
sudo apt-get update -y 
sudo apt-get upgrade -y
apt-get install openssl wget curl -y

# port open 80?
echo -e "${GREEN}DON'T FORGET OPEN & FREE 80 PORT${NORMAL}"
echo "[ENTER]"
read -r lol

# v2-ui
bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)
v2-ui start

# cert
echo ""
echo "enter your domain wer.exp.com OR set empty (enter)"
echo ""
read -r domain
if [ -z "$domain" ]; then
sudo apt-get install snapd -y
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
echo -e "${GREEN}GETTING CERTIFICATE${NORMAL}"
sudo /snap/bin/certbot certonly --standalone --preferred-challenges http --agree-tos --email someadress@hui.com -d "$domain"
echo ""
echo "open http://${domain}:65432"
echo ""
yourip=`curl ifconfig.co`
else
echo ""
echo "open http://${yourip}:65432"
echo ""
fi
