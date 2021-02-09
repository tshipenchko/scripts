#!/bin/bash 
#Only for Ubuntu/Debian
# root?
if [[ $EUID -ne 0 ]]; then
  echo -e "MUST RUN AS ROOT USER! use sudo"
  exit 1
fi
# install stuff
sudo apt-get update -y 
sudo apt-get upgrade -y
apt-get install openssl wget curl -y

#open ports
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

# openssl
mkdir -p /etc/ssl/v2ray/
echo "You can don't fill that"
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/v2ray/priv.key -out /etc/ssl/v2ray/cert.pub

# v2-ui
bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)
v2-ui start

# info
yourip=`wget -qO - icanhazip.com`
echo "go to http://$yourip:65432 and set it up" | tee -a /root/v2rayOpenSSL.info
echo "admin admin is login and password" | tee -a /root/v2rayOpenSSL.info
echo "certificate file path: /etc/ssl/v2ray/cert.pub" | tee -a /root/v2rayOpenSSL.info
echo "key file path: /etc/ssl/v2ray/priv.key" | tee -a /root/v2rayOpenSSL.info
echo ""
echo "to see that again: cat /root/v2rayOpenSSL.info"
