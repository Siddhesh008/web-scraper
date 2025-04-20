FROM node:20-slim

# Install Chromium, Python3, pip, and Puppeteer dependencies
RUN apt-get update && \
    apt-get install -y \
    chromium \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    python3 \
    python3-pip \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*


ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /app

# Install Node dependencies
COPY package.json .
RUN npm install


COPY scrape.js .
COPY requirements.txt .
RUN pip3 install --break-system-packages -r requirements.txt
COPY server.py .

EXPOSE 5000

# Scrape at runtime and launch server
CMD ["sh", "-c", "node scrape.js && python3 server.py"]

