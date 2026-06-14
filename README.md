# Project: Production-Style Monitoring Stack

A fully automated observability stack built with Prometheus, Grafana, and Alertmanager — deployed via Docker Compose and managed entirely through Ansible, with secrets secured using Ansible Vault.

---

## Architecture

```
ubuntu01 (control node · 192.168.18.11)
├── Prometheus     :9090  →  scrapes metrics · stores time-series data · evaluates alert rules
├── Grafana        :3000  →  visualises dashboards (Node Exporter Full · dashboard ID 1860)
├── Alertmanager   :9093  →  routes alerts → Gmail email notifications
└── Node Exporter  :9100  →  exposes control node system metrics

192.168.18.36 (Ubuntu target)
└── Node Exporter  :9100  →  exposes system metrics (installed via Ansible)

192.168.18.42 (CentOS target)
└── Node Exporter  :9100  →  exposes system metrics (installed via Ansible)
```

### Data Flow

```
Every 15 seconds:

Node Exporter          Node Exporter          Node Exporter
(ubuntu-target)        (centos-target)        (control-node)
      ↑                      ↑                      ↑
      └──────────────────────┴──────────────────────┘
                             │  scrape
                        Prometheus
                   stores metrics · checks alert rules
                             │
              ┌──────────────┴──────────────┐
              ↓                             ↓
          Grafana                    Alertmanager
      live dashboards              email alerts → Gmail
```

---

## Project Structure

```
project-monitoring-stack/
├── deploy_monitoring.yml          # main Ansible playbook (idempotent)
├── install_node_exporter.yml      # installs Node Exporter on target servers
├── vars/
│   ├── monitoring_vars.yml        # plain config (IPs, ports, Grafana credentials)
│   └── vault.yml                  # 🔒 AES-256 encrypted Gmail credentials
└── templates/
    ├── prometheus.yml.j2          # Prometheus config (Jinja2 template)
    ├── alert_rules.yml.j2         # PromQL alert rules (Jinja2 template)
    ├── alertmanager.yml.j2        # Alertmanager SMTP config (uses vault vars)
    └── docker-compose.yml.j2     # full stack Docker Compose (Jinja2 template)
```

---

## Alert Rules

Four production-relevant alerts configured in PromQL:

| Alert | Condition | Duration | Severity |
|---|---|---|---|
| HighCPUUsage | CPU busy > 80% | 2 min | warning |
| HighMemoryUsage | Memory used > 85% | 2 min | warning |
| DiskSpaceRunningLow | Disk free < 20% | 5 min | warning |
| ServerDown | Node Exporter unreachable | 1 min | critical |

All alerts send email via Alertmanager with:
- **30s group wait** before first notification
- **12h repeat interval** to prevent alert floods
- **Send resolved** notification when the condition clears

---

## Security — Ansible Vault

Gmail credentials are encrypted with AES-256 using Ansible Vault:

```bash
# Create encrypted secrets file
ansible-vault create vars/vault.yml

# Edit encrypted file
ansible-vault edit vars/vault.yml

# View encrypted file (shows ciphertext — safe to commit to GitHub)
cat vars/vault.yml
```

The `vars/vault.yml` file is committed to this public repository as encrypted ciphertext. Without the vault password, it is unreadable. This is a production-grade secrets management pattern.

---

## How to Deploy

### Prerequisites

- Ansible installed on the control node
- Docker and Docker Compose installed on the control node
- SSH access to target servers
- Gmail account with 2FA enabled and an App Password generated

### 1 — Clone and Configure

```bash
git clone https://github.com/Tariq-sudo/linux-homelab.git
cd linux-homelab/project-monitoring-stack
```

Edit `vars/monitoring_vars.yml` with your server IPs:
```yaml
ubuntu_target_ip: YOUR_UBUNTU_IP
centos_target_ip: YOUR_CENTOS_IP
```

### 2 — Create Vault File

```bash
ansible-vault create vars/vault.yml
```

Add your Gmail credentials:
```yaml
vault_gmail_address: your_email@gmail.com
vault_gmail_app_password: your16charapppassword
```

### 3 — Install Node Exporter on Target Servers

```bash
ansible-playbook -i inventory.ini install_node_exporter.yml
```

### 4 — Deploy the Monitoring Stack

```bash
ansible-playbook deploy_monitoring.yml --ask-vault-pass
```

### 5 — Access the Stack

| Service | URL | Credentials |
|---|---|---|
| Prometheus | http://YOUR_CONTROL_NODE_IP:9090 | None |
| Grafana | http://YOUR_CONTROL_NODE_IP:3000 | admin / devops123 |
| Alertmanager | http://YOUR_CONTROL_NODE_IP:9093 | None |

In Grafana, import dashboard ID **1860** (Node Exporter Full) for live server metrics.

---

## Key Technical Decisions

**Why Docker Compose instead of standalone containers?**
Compose manages container dependencies, shared networks, and named volumes in a single file. The `prometheus` and `node-exporter` containers communicate using Docker's internal DNS (container names as hostnames) rather than IP addresses — more robust and easier to maintain.

**Why Ansible Vault instead of environment variables?**
Vault encrypts secrets at rest and allows them to be version-controlled safely. Environment variables require manual setup on each machine and are visible in process lists. Vault integrates natively with Ansible's templating system.

**Why `--web.enable-lifecycle` on Prometheus?**
Enables the `/-/reload` API endpoint, allowing Prometheus to hot-reload its configuration via an HTTP POST without restarting the container — zero downtime config updates, triggered automatically by Ansible handlers when config files change.

---

## Certifications

- **KodeKloud Engineer — Linux (Level 1)** · Sep 2025
- **KodeKloud Engineer — Git (Level 1)** · Aug 2025

---

## Connect

- **LinkedIn:** [linkedin.com/in/tariq-mahmood-2714a232a](https://www.linkedin.com/in/tariq-mahmood-2714a232a/)
- **GitHub:** [github.com/Tariq-sudo/linux-homelab](https://github.com/Tariq-sudo/linux-homelab)
- **Docker Hub:** [hub.docker.com/u/tariqsudo](https://hub.docker.com/repositories/tariqsudo)

