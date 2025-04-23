# Stage 1: Scraper 
FROM node:20-slim AS scraper

# Install Chromium + dependencies
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
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Puppeteer settings
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app

COPY package.json .
RUN npm install
COPY scrape.js .

# Pass target URL at build-time
ARG SCRAPE_URL=https://www.wikipedia.org
ENV SCRAPE_URL=$SCRAPE_URL


RUN node scrape.js

# Stage 2: Python Server 
FROM python:3.10-slim AS server

WORKDIR /app

# Copy the scraped result from scraper stage
COPY --from=scraper /app/scraped_data.json .


COPY requirements.txt .
RUN pip3 install --break-system-packages -r requirements.txt

COPY server.py .

EXPOSE 5000

CMD ["python3", "server.py"]
