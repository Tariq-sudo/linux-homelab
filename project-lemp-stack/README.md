# Project: Deploying a Production-Ready LEMP Stack on Ubuntu Server 24.04

## Objective

To build a complete, functional web server from scratch on a minimal Ubuntu Server installation. This project demonstrates core competencies in package management, service configuration, network security, and database administration.

---

## Technologies Used

*   **Operating System:** Ubuntu Server 24.04
*   **Virtualization:** VMware Workstation
*   **Web Server:** Nginx
*   **Database:** MariaDB (a fork of MySQL)
*   **Scripting Language:** PHP-FPM
*   **Networking:** UFW (Uncomplicated Firewall), SSH

---

## Project Breakdown & Skills Demonstrated

### 1. Initial Server Setup & Hardening
*   Installed Ubuntu Server 24.04 in a virtualized environment.
*   Performed initial system updates and upgrades (`apt update && apt upgrade`).
*   **Configured the UFW firewall** to deny all incoming traffic by default and explicitly allow essential services (SSH, HTTP, HTTPS). This is a critical security best practice.

### 2. Nginx Web Server Installation & Configuration
*   Installed Nginx using the `apt` package manager.
*   Verified that the `nginx` service was running and enabled to start on boot using `systemctl`.
*   Successfully tested default web server connectivity from a client machine on the same network.

### 3. MariaDB Database Server Installation
*   Installed the `mariadb-server` package.
*   **Secured the database installation** by running `mysql_secure_installation`, which involved setting a root password, removing anonymous users, and disallowing remote root login.

### 4. PHP-FPM Installation
*   Installed `php-fpm` and the `php-mysql` extension to allow communication between PHP and the database.
*   Created a `phpinfo()` test page to verify that Nginx was correctly processing PHP files and that the database extension was loaded.

---

## Challenges & Lessons Learned

*   **Problem:** Initially, PHP files were being downloaded instead of executed by the browser.
*   **Solution:** This required editing the Nginx server block configuration file to correctly pass `.php` file requests to the PHP-FPM socket. This reinforced the importance of understanding service-to-service communication.
*   **Lesson:** A default installation is rarely production-ready. Understanding and editing configuration files (like those in `/etc/nginx/sites-available/`) is a non-negotiable skill for a system administrator.
