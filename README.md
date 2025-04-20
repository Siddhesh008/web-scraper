# **Web Scraper using Docker**
This project demonstrates the combined power of Node.js (Puppeteer) for headless web scraping and Python (Flask) for serving the scraped content — containerized with Docker.
It:
- Scrapes a user-specified URL for the page title and first heading
- Hosts the scraped data on a Flask server running on port 5000
- Uses Chromium headless browser inside a Docker container
## Files Info
- Dockerfile: The blueprint for building our Docker image. It's a multi-stage setup, means it includes setup for both node and python.
- scrape.js: The script that actually goes to the website, looks around, and saves the data.
- Server.py: The simple web server that reads the saved data and shows it in your browser.
- package.json: Tells Node.js what it needs to run
- requirements.txt: Lists what Python needs

## Prerequisites:
1. Docker: Ensure that Docker Engine is installed and running on the host system. Installation instructions can be found on the official Docker website according to your operating system.
2. Git(optional): If you want to push your code/files to Github, you may also need to install Git.

## **Dockerfile**
This file is used for building Docker image. The Dockerfile implements a multi-stage build strategy to optimize the final container image size:
*Scraper Stage*
- Base Image: node:18-slim (Debian-based Node.js image).
- System Dependencies: Installs necessary system packages for running Chromium in a headless environment.
- Chromium Configuration: Configures Puppeteer to utilize the system-installed Chromium by setting environment variables PUPPETEER_SKIP_CHROMIUM_DOWNLOAD to true and PUPPETEER_EXECUTABLE_PATH to /usr/bin/chromium.
- Node.js Dependencies: Copies the node/ directory and installs Node.js dependencies specified in package.json (Puppeteer).
- Scraping Execution: Executes the scrape.js script using CMD. This script retrieves the target URL from the SCRAPE_URL environment variable, launches Puppeteer, navigates to the URL, extracts predefined data (page title and first heading), and saves the output as scraped_data.json in the /app directory.

*Web Server Stage*
- Base Image python:3.10-slim.
- Scraped Data Transfer: Copies the scraped_data.json file from the scraper stage to the /app directory of the current stage.
- Python Dependencies: Copies the python/ directory and installs Python dependencies specified in requirements.txt (Flask).
- Port Exposure: Exposes port 5000 for the Flask web server.
- Server Execution: Defines the command to run the Flask development server (server.py) upon container startup.

## **Building Docker Image**
Navigate to the root directory of this project (where the Dockerfile is located) in your terminal and execute the following command:
   
   
   
   *``` docker build -t devops-scraper . ```*


   
This command will build the Docker image based on the instructions in the Dockerfile.

## **Running Docker Container**
To run the container and initiate the scraping process for a specific URL, use the following command:
 
    
    
    *``` docker run -e SCRAPE_URL=https://www.wikipedia.org -p 5000:5000 devops-scraper ```* 


    

## ** How to pass the URL for scraping**
To run the container and specify the website you want to scrape, you need to use the `-e` flag with the `docker run` command to set the `SCRAPE_URL` environment variable.
   
    
    
    *``` docker run -e SCRAPE_URL=https://www.wikipedia.org -p 5000:5000 devops-scraper ```* 


    
-e SCRAPE_URL="URL": This part is crucial for telling the scraper which website to visit. The '-e' flag is used to set environment variables inside the running Docker container. Here, I am setting a variable named SCRAPE_URL and assigning it the value of the website address you want to scrape.
## ** Accessing Scraped Data**
Once the container is running, the scraped data, served as JSON by the Flask application, can be accessed by opening a web browser and navigating to the following address:



*```public ip:5000```* or *```http://localhost:5000```*



The browser will display the JSON output containing the scraped title, first heading

## Contribution
Contributions to this project are welcome.
