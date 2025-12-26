# LEMP Stack — project-lemp-stack

A documented, reproducible LEMP stack (Linux, Nginx, MariaDB, PHP-FPM) configuration for local homelab and small production use. This README covers architecture, requirements, quickstart (Ansible and Docker Compose options), configuration snippets, testing and troubleshooting.

## What this project contains

- opinionated configuration examples for Nginx, PHP-FPM and MariaDB
- Ansible playbook example for provision and deploy
- Docker Compose example to run the stack in containers
- sample app and test endpoints

## Requirements

- A Linux host (Ubuntu 20.04+ or Debian 10+ recommended)
- sudo/root access
- Git
- Either Docker & Docker Compose (v2+) or Ansible (v2.9+)

## Architecture

- Nginx as the reverse proxy / web server
- PHP-FPM handling PHP requests (Unix socket recommended)
- MariaDB as the database server
- Optional: phpMyAdmin or Adminer for DB management

## Quickstart — Docker Compose (recommended for local testing)

1. Copy the example env file and edit credentials:

```bash
cp .env.example .env
# edit .env (DB_ROOT_PASSWORD, DB_USER, DB_PASSWORD, MYSQL_DATABASE)
```

2. Start the stack:

```bash
docker compose up -d
```

3. Verify services:

```bash
docker compose ps
curl -I http://localhost
```

## Quickstart — Ansible (provision a VM or bare metal)

1. Install Ansible on your control machine.
2. Edit `inventory/hosts` to point to your target host(s).
3. Run the playbook:

```bash
ansible-playbook -i inventory/hosts site.yml --ask-become-pass
```

## Sample Nginx server block (snippets/nginx/site.conf)

```nginx
server {
    listen 80;
    server_name example.local;

    root /var/www/project/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_index index.php;
    }

    access_log /var/log/nginx/project.access.log;
    error_log /var/log/nginx/project.error.log;
}
```

Adjust the `fastcgi_pass` socket path to match installed PHP version.

## Sample MariaDB secure setup (Ansible task or manual)

```sql
-- Run as root or via mysql -u root -p
CREATE DATABASE project_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'project'@'127.0.0.1' IDENTIFIED BY 'strong_password_here';
GRANT ALL PRIVILEGES ON project_db.* TO 'project'@'127.0.0.1';
FLUSH PRIVILEGES;
```

Run `mysql_secure_installation` when installing MariaDB to remove test users and set root password.

## Sample PHP info file (public/index.php)

```php
<?php
phpinfo();
```

Place it in the web root to confirm PHP-FPM and Nginx integration.

## Environment variables (.env.example)

```
APP_ENV=local
APP_DEBUG=true
DB_HOST=db
DB_PORT=3306
DB_DATABASE=project_db
DB_USERNAME=project
DB_PASSWORD=strong_password_here
```

## Logging & Monitoring

- Place Nginx logs under /var/log/nginx/<site>.
- Configure logrotate for Nginx and PHP-FPM logs.
- Consider using Prometheus + node_exporter + cAdvisor for container metrics.

## Backups

- Schedule regular dumps of MariaDB: `mysqldump --single-transaction --quick --lock-tables=false -u root -p project_db > /backups/project_db-$(date +%F).sql`
- Persist volumes when using Docker: use named volumes or bind mounts to host path under `/srv/data` or `/opt/data`.

## Troubleshooting

- 502 Bad Gateway: check that PHP-FPM is running and socket path matches Nginx config.
- 500 errors: check PHP-FPM logs (`/var/log/php*-fpm.log`) and Nginx error log.
- DB connection errors: verify credentials, host, and that MariaDB accepts connections from the web host.

## Security

- Always run behind a firewall and only expose necessary ports.
- Use TLS (Let's Encrypt) in production — see `certbot` or `nginx-proxy` patterns.
- Keep packages updated and apply security patches promptly.

## Contributing

- Open an issue or PR with improvements, configuration suggestions or bug fixes.
- Include reproducible steps and expected vs actual behavior.

## License

This repository follows the same license as the parent repo. If none is set, assume MIT for these examples.

---

Last updated: 2025-12-26
