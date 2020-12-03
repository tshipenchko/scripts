#/bin/bash
# root?
if [[ $EUID -ne 0 ]]; then
  echo -e "MUST RUN AS ROOT USER! use sudo"
  exit 1
fi

#open ports
sudo apt update && sudo apt upgrade -y
sudo apt install net-tools speedtest-cli python2 python3 python3-pip curl wget -y