# desec-dns-updater
A Lightweight Dockerized Bash script for updating deSEC.io dynamic DNS records with IP caching
### 🚀 Features
* **Direct API Integration:** Uses the deSEC REST API (no bulky `ddclient` needed).
* **IP Caching:** Only sends updates if your public IP actually changes (prevents API throttling).
* **Multi-Host Support:** Updates multiple subdomains and wildcards in one go.
* **Minimal Footprint:** Runs on a tiny Alpine Linux image.

### 🛠️ Prerequisites
* A [deSEC.io](https://desec.io) account and API Token.
* Docker & Docker Compose installed on your host.

### 🚀 Quick Start (Pre-built Image)
You don't need to clone this repo. Just create a `docker-compose.yml`:

```yaml
services:
  ddns-updater:
    image: ghcr.io/egaehler-dev/desec-dns-updater:latest
    container_name: ddns-updater
    environment:
      - DESEC_TOKEN=your_token_here
      - DESEC_ZONE=your_domain.com
      - DESEC_HOSTS=["@","*"]
    volumes:
      - ./data:/data
    restart: unless-stopped
