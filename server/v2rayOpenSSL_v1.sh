#!/bin/bash 
#Only for Ubuntu/Debian
# root?
if [[ $EUID -ne 0 ]]; then
  echo -e "MUST RUN AS ROOT USER! use sudo"
  exit 1
fi

#open ports
echo "Do you want to open all ports? (y/n)"
read -r open_port
case open_port in
y|Y)
	sudo iptables -A INPUT -p udp -m udp --dport 1:65535 -j ACCEPT
	sudo iptables -A INPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
	sudo iptables -A OUTPUT -p udp -m udp --dport 1:65535 -j ACCEPT
	sudo iptables -A OUTPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
	echo "All ports are open now"
	;;
n|N)
	echo "Okey, ports are closed"
	;;
*)
	echo "Port won't be open (enter to continue)"
	read -r lol
	;;
esac

#openssl
apt-get install openssl wget -y
mkdir -p /etc/ssl/v2ray/
echo "You can don't fill that"
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/v2ray/priv.key -out /etc/ssl/v2ray/cert.pub

#v2-ui
sudo apt-get update -y 
sudo apt-get upgrade -y
sudo apt install curl -y
bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)
v2-ui start

#info
yourip=`wget -qO - icanhazip.com`
echo "go to http://$yourip:65432 and set it up" | tee /root/v2rayOpenSSL.info
echo "admin admin is login and password" | tee /root/v2rayOpenSSL.info
echo "certificate file path: /etc/ssl/v2ray/cert.pub" | tee /root/v2rayOpenSSL.info
echo "key file path: /etc/ssl/v2ray/priv.key" | tee /root/v2rayOpenSSL.info
echo ""
echo "to see that again: cat /root/v2rayOpenSSL.info"
