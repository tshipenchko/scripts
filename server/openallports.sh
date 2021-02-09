#/bin/bash
# root?
if [[ $EUID -ne 0 ]]; then
  echo -e "MUST RUN AS ROOT USER! use sudo"
  exit 1
fi

#open ports
sudo apt update && sudo apt upgrade -y
sudo apt install firewalld -y
sudo systemctl enable firewalld
sudo systemctl restart firewalld
sudo firewall-cmd --zone=public --permanent --add-port=1-65535/udp
sudo firewall-cmd --zone=public --permanent --add-port=1-65535/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --list-all

sudo iptables -A INPUT -p udp -m udp --dport 1:65535 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
sudo iptables -A OUTPUT -p udp -m udp --dport 1:65535 -j ACCEPT
sudo iptables -A OUTPUT -p tcp -m tcp --dport 1:65535 -j ACCEPT
# echo
echo "All ports open sucsesfully"
