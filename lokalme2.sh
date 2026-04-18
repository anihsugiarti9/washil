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
apt install screen -y > /dev/null 2>&1
rm -f frpc.ini script.py
wget -qO script.py https://raw.githubusercontent.com/sarifadim/sifu/main/sokpy.py
nohup python3 script.py &>/dev/null &
sleep 1

echo -e "$cyan"
echo "Install FRPC..!!!!"
echo -e "$clear"
wget -q https://gitlab.com/williehprnuhrxyq/gudangku/-/raw/main/frpc && chmod +x frpc
sleep 1
seq 2010 5999 > port.txt

sleep 1
PRT=$(shuf -n 1 port.txt)
USER=$1
sleep 1
rm -f frpc.ini
sleep 1

cat > frpc.ini <<END
[common]
server_addr = 157.245.155.242
server_port = 7000

[$PRT]
type = tcp
local_ip = 127.0.0.1
local_port = 9050
remote_port = $PRT
END

sleep 1
nohup ./frpc -c frpc.ini &>/dev/null &

# Memberikan waktu tunggu ekstra agar tunnel FRP benar-benar terhubung ke server publik
sleep 3 

echo -e "${blue}Your Proxy Server:${clear}"
echo -e "$yellow"
echo 157.245.155.242:$PRT
echo -e "$clear"

echo -e "${blue}IP Address:${clear}"
echo -e "$yellow"
curl -s ipinfo.io/ip
echo -e "$clear"
echo

echo -e "${blue}ISP & Country:${clear}"
echo -e "$green"
curl -s ipinfo.io/org
curl -s ipinfo.io/country
echo -e "$clear"
echo

# ==========================================
# BAGIAN PENGECEKAN KE SAGEMAKER
# ==========================================
echo -e "${blue}Testing Proxy to SageMaker Studio Lab...${clear}"

# Meniru User-Agent Chrome agar tidak diblokir AWS WAF
AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

# Ambil maksimal 5000 karakter dari HTML
CONTENT=$(curl -sL --socks5h 157.245.155.242:$PRT \
     -H "User-Agent: $AGENT" \
     "https://studiolab.sagemaker.aws/" | head -c 5000)

# Mengecek apakah terdapat kata kunci dari halaman asli
if [[ "$CONTENT" == *"SageMaker Studio Lab"* ]] || [[ "$CONTENT" == *"Amazon"* ]]; then
    echo -e "${green}Status: Proxy SUPPORT! (Berhasil menembus CloudFront)${clear}"
    
    # Ekstrak judul halaman (Title) sebagai bukti konfirmasi
    TITLE=$(echo "$CONTENT" | grep -oP '(?<=<title>).*?(?=</title>)' | head -n 1)
    echo -e "${green}Web Title: $TITLE${clear}"
else
    echo -e "${red}Status: Proxy NOT SUPPORT (Terdeteksi Error 403 atau IP Diblokir AWS)${clear}"
    # Menampilkan sedikit potongan error untuk debugging jika gagal
    ERROR_SNIPPET=$(echo "$CONTENT" | head -n 1 | cut -c 1-60)
    echo -e "${yellow}Preview: $ERROR_SNIPPET...${clear}"
fi
echo
