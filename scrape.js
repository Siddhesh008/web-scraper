const puppeteer = require('puppeteer');
const fs = require('fs');

const url = process.env.SCRAPE_URL;

if (!url) {
    console.error("Error: SCRAPE_URL environment variable not set.");
    process.exit(1);
}

(async () => {
    const browser = await puppeteer.launch({
        headless: true,
        executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || '/usr/bin/chromium',
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();
    await page.goto(url, { waitUntil: 'networkidle2' });

    const result = await page.evaluate(() => {
        return {
            title: document.title,
            firstHeading: document.querySelector('h1') 
                          ? document.querySelector('h1').innerText 
                          : 'No H1 tag found'
        };
    });

    fs.writeFileSync('scraped_data.json', JSON.stringify(result, null, 2));

    await browser.close();
})();

