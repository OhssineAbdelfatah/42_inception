# Inception - 42 Project  
**🚀 A Docker-based infrastructure for WordPress with NGINX, MariaDB, and optional bonuses**  

---

## 📌 Overview  
This project virtualizes a multi-container infrastructure using **Docker Compose**, featuring:  
- **NGINX** with TLSv1.2/1.3 (sole entry point)  
- **WordPress** + PHP-FPM (no NGINX)  
- **MariaDB** database  
- **Volumes** for WordPress files and database  
- **Docker network** for secure inter-container communication  

**Bonus Options**: Redis cache, FTP server, Adminer, static website, or custom service.  

---

## 🛠️ Technologies  
| **Service**    | **Role**                          | **Constraints**                  |  
|----------------|-----------------------------------|----------------------------------|  
| **NGINX**      | Reverse proxy (TLS only)          | Port 443 only, no `latest` tag   |  
| **WordPress**  | CMS with PHP-FPM                  | No NGINX in container            |  
| **MariaDB**    | Database                          | Custom users (no "admin" names)  |  
| **Docker**     | Containerization                  | Alpine/Debian (penultimate stable)|  
| **Volumes**    | Persistent storage                | Host path: `/home/<login>/data`  |  

---

## 📂 Project Structure  

inception/
├── Makefile # Builds images and launches containers
├── srcs/ # All configuration files
│ ├── docker-compose.yml # Defines services, networks, volumes
│ ├── .env # Environment variables (e.g., DOMAIN_NAME=login.42.fr)
│ ├── secrets/ # Stores credentials (git-ignored)
│ └── requirements/ # Dockerfiles and configs per service
│ ├── nginx/
│ │ ├── Dockerfile # Custom NGINX with TLS
│ │ └── conf/ # NGINX config files
│ ├── wordpress/
│ │ ├── Dockerfile # WordPress + PHP-FPM
│ │ └── tools/ # Setup scripts
│ ├── mariadb/
│ │ ├── Dockerfile # MariaDB with secure users
│ │ └── conf/ # DB configs
│ └── bonus/ # Optional services (Redis, FTP, etc.)
└── README.md # This file


---

## 🚀 Quick Start  

### **Prerequisites**  
- Docker and Docker Compose installed  
- Domain `login.42.fr` pointing to your VM's local IP  

### **1. Configure Environment**  
```bash  
cd srcs/  
echo "DOMAIN_NAME=yourlogin.42.fr" > .env  # Replace with your 42 login  
```
Add secrets (e.g., secrets/db_password.txt) - never commit these!
### **2. Build and Launch**
```bash  
make  # Runs `docker-compose up --build`  
```

### **3. Access Services**

    WordPress: https://yourlogin.42.fr

    MariaDB: Accessible only via WordPress container (port 3306 internal)

## 🔒 Security & Rules

✅ Forbidden: latest tags, network: host, --link, infinite loops (tail -f, sleep infinity)
✅ Required:

    Docker secrets for credentials (not in Dockerfiles)

    Auto-restart on crash

    Non-root users in containers

    TLSv1.2/1.3 only (NGINX)

## 🛠️ Troubleshooting
Issue	Solution
WordPress DB connection error	Check mariadb logs: docker logs -f mariadb
NGINX 502 Bad Gateway	Verify PHP-FPM is running in WordPress container
TLS errors	Ensure domain login.42.fr resolves to your VM's IP
## ✨ Bonus Features

To enable bonuses, uncomment services in docker-compose.yml:

    Redis: Caching for WordPress

    FTP Server: Manage WordPress files

    Adminer: Web-based DB GUI

    Static Website: Non-PHP (e.g., HTML/CSS)

Note: Bonuses are graded only if the mandatory part is flawless.
