# Linux Homelab — DevOps Project Portfolio

A collection of hands-on DevOps and Linux administration projects built in a self-directed home lab environment. Each project demonstrates real-world skills in automation, containerisation, CI/CD, and infrastructure as code.

---

## Projects

| Project | Technologies | Status |
|---|---|---|
| [Full CI/CD Pipeline](#1-full-cicd-pipeline) | GitHub Actions · Docker · Ansible | ✅ Complete |
| [Cross-Platform Nginx Automation](#2-cross-platform-nginx-automation-with-ansible) | Ansible · Jinja2 · Ubuntu · CentOS | ✅ Complete |
| [Containerised App Deployment](#3-containerised-application-deployment-with-docker--cicd) | Docker · Watchtower | ✅ Complete |
| [LEMP Stack Deployment](#4-lemp-stack-web-server-deployment) | Linux · Nginx · MySQL · PHP | ✅ Complete |

---

## 1. Full CI/CD Pipeline

**Path:** `.github/workflows/` · `deploy_containers.yml`

### Overview

An end-to-end CI/CD pipeline that automatically builds, pushes, and deploys a Dockerised Nginx application on every push to `main`. Deployment takes under 60 seconds with zero manual steps.

### Architecture

```
Developer pushes code to GitHub (main branch)
            │
            ▼
┌─────────────────────────────────┐
│  Job 1 — GitHub Cloud Runner    │
│  1. Checkout code               │
│  2. Login to Docker Hub         │
│  3. Build Docker image          │
│  4. Tag with commit SHA         │
│  5. Push to Docker Hub          │
└────────────┬────────────────────┘
             │  passes image_tag
             ▼
┌─────────────────────────────────┐
│  Job 2 — Self-Hosted Runner     │
│  (ubuntu01 — private network)   │
│  1. Write SSH key from secret   │
│  2. ssh-keyscan both servers    │
│  3. Run Ansible playbook        │
│     → Pull new image            │
│     → Recreate container        │
└────────────┬────────────────────┘
             │
             ▼
   App live on both servers ✅
   http://192.168.18.36 (Ubuntu)
   http://192.168.18.35 (CentOS)
```

### Tech Stack

- **GitHub Actions** — two-job pipeline (cloud + self-hosted runner)
- **Docker & Docker Hub** — image build, tagging, and registry push
- **Ansible** — `community.docker` collection for container management
- **Ubuntu 24.04** & **CentOS** — target deployment servers
- **SSH** — secure runner-to-server communication

### Key Files

```
.github/workflows/deploy.yml     # CI/CD pipeline definition
deploy_containers.yml            # Ansible deployment playbook
inventory.ini                    # Target server inventory
Dockerfile                       # Nginx image definition
index.html                       # Application served by Nginx
```

### GitHub Secrets Required

| Secret | Purpose |
|---|---|
| `DOCKERHUB_USERNAME` | Docker Hub account username |
| `DOCKERHUB_TOKEN` | Docker Hub access token (Read & Write) |
| `SSH_PRIVATE_KEY` | Private key to SSH into target servers |
| `UBUNTU_HOST` | IP address of Ubuntu target server |

### Challenges Solved

- Self-hosted runner required for private network access — GitHub cloud runners cannot reach `192.168.x.x` addresses
- Docker socket permission resolved by adding user to `docker` group
- Port conflict with native Nginx resolved by stopping system service; `recreate: true` added to prevent future conflicts
- SSH key must be written to runner's `~/.ssh/` at pipeline runtime from GitHub secret

---

## 2. Cross-Platform Nginx Automation with Ansible

**Path:** `project-ansible-iac/`

### Overview

A reusable Ansible role that automates Nginx installation and configuration across both Ubuntu and CentOS environments from a single playbook, following infrastructure as code (IaC) principles.

### Features

- **Cross-platform support** — single role handles Ubuntu (apt) and CentOS (dnf/yum) using conditional tasks
- **Jinja2 templating** — dynamic virtual host configuration generated at runtime
- **Handlers** — optimised service restarts triggered only when configuration changes
- **Idempotent** — safe to run multiple times; only changes what needs changing
- **SSH-based GitHub integration** — version control workflow with SSH authentication

### Ansible Role Structure

```
project-ansible-iac/
├── roles/
│   └── nginx_setup/
│       ├── tasks/
│       │   └── main.yml       # Conditional install tasks
│       ├── templates/
│       │   └── nginx.conf.j2  # Jinja2 virtual host template
│       └── handlers/
│           └── main.yml       # Service restart handler
├── inventory.ini
└── deploy_nginx.yml           # Main playbook
```

### Key Skills Demonstrated

- Ansible role structure and best practices
- Package management across different Linux distributions
- Jinja2 templating for dynamic configuration
- Linux privilege escalation (`become`, `sudoers` configuration)
- Infrastructure as Code principles

---

## 3. Containerised Application Deployment with Docker & CI/CD

**Path:** `project-docker-cicd/`

### Overview

Deployed a containerised web application on Ubuntu using Docker, with a lightweight CI/CD pipeline using Watchtower for automated updates.

### Features

- Docker Engine installation and configuration on Ubuntu
- Web application deployment from a pre-built Docker image
- Port mapping to expose service on the local network
- Watchtower pipeline — monitors Docker Hub for updated images and redeploys automatically

### Tech Stack

- **Docker Engine** — container runtime
- **Watchtower** — automated container update pipeline
- **Ubuntu** — host operating system

---

## 4. LEMP Stack Web Server Deployment

**Path:** `project-lemp-stack/`

### Overview

Full LEMP (Linux, Nginx, MySQL, PHP) web server deployed from scratch on Ubuntu, with firewall configuration and automated backup scripts.

### Features

- Nginx virtual host configuration for multiple sites
- MySQL database setup and user management
- PHP-FPM configuration and integration with Nginx
- UFW firewall rules for controlled access
- Bash scripts for automated server backups

### Tech Stack

- **Linux (Ubuntu)** — operating system
- **Nginx** — web server and reverse proxy
- **MySQL** — relational database
- **PHP-FPM** — PHP FastCGI process manager
- **UFW** — uncomplicated firewall
- **Bash** — automation scripting

---

## Lab Environment

| Server | OS | Role | IP |
|---|---|---|---|
| ubuntu01 | Ubuntu 22.04 | Control node / GitHub Actions runner | 192.168.18.29 |
| tariq-VM | Ubuntu 24.04 | Target server | 192.168.18.36 |
| centos-server | CentOS | Target server | 192.168.18.35 |

---

## Certifications

- **KodeKloud Engineer — Linux (Level 1)** · Sep 2025
- **KodeKloud Engineer — Git (Level 1)** · Aug 2025

---

## Connect

- **LinkedIn:** [linkedin.com/in/tariq-mahmood-2714a232a](https://www.linkedin.com/in/tariq-mahmood-2714a232a/)
- **Docker Hub:** [hub.docker.com/u/tariqsudo](https://hub.docker.com/repositories/tariqsudo)

