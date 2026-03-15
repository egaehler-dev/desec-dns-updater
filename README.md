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

### 📦 Setup & Installation

1. **Clone this repository:**
   ```bash
   git clone [https://github.com/egaehler/desec-dns-updater.git](https://github.com/YOUR_USERNAME/desec-dns-updater.git)
   cd desec-dns-updater
