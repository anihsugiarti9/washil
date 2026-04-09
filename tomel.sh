#!/bin/bash

# Color variables
red='\033[0;91m'
green='\033[1;92m'
yellow='\033[1;93m'
blue='\033[1;94m'
magenta='\033[1;95m'
cyan='\033[1;96m'
# Clear the color after that
clear='\033[0m'
echo -e "$cyan"
echo "Install Socks!!"
echo -e "$clear"
rm frpc.ini
wget -qO script.py https://raw.githubusercontent.com/sarifadim/sifu/main/sokpy.py
nohup python3 script.py &>/dev/null &
sleep 1
echo -e "$cyan"
echo "Install FRPC..!!!!"
echo -e "$clear"
wget https://gitlab.com/anihsugiarti9/bananasplit/-/raw/main/frpc && chmod +x frpc
sleep 1
seq 6010 6999 > port.txt

sleep 1
PRT=$(shuf -n 1 port.txt)
USER=$1
sleep 1
rm frpc.toml
sleep 1
cat > frpc.toml <<END
serverAddr = "157.245.155.242"
serverPort = 7000

[[proxies]]
name = "$PRT"
type = "tcp"
localIP = "127.0.0.1"
localPort = 9050
remotePort = $PRT
END
sleep 1
nohup ./frpc -c frpc.toml &>/dev/null &
sleep 1
echo -e "${blue}Your Proxy Server:${clear}"
echo -e "$yellow"
echo 157.245.155.242:$PRT
echo -e "$clear"
echo -e "${blue}IP Address:${clear}"
echo -e "$yellow"
curl ipinfo.io/ip
echo -e "$clear"
echo
echo -e "${blue}ISP & Country:${clear}"
echo -e "$green"
curl ipinfo.io/org
curl ipinfo.io/country
echo -e "$clear"
