# Project: 3-Node Kubernetes Cluster with K3s

A production-style Kubernetes cluster built on a home lab using K3s, with the full setup automated via Ansible. Deploys a multi-replica Nginx application with ConfigMaps, NodePort services, and zero-downtime rolling updates.

---

## Cluster Architecture

```
192.168.18.10  ubuntu01        ← K3s Control Plane (master)
                                  also runs: GitHub Actions runner + monitoring stack
192.168.18.11  tariq-vm        ← K3s Worker Node 1 (Ubuntu 24.04)
192.168.18.12  centos-worker   ← K3s Worker Node 2 (CentOS Stream 10)
```

### Application Deployment

```
kubectl apply
      ↓
Kubernetes Scheduler
      ↓  distributes 3 replicas across all nodes
┌─────────────┬─────────────┬─────────────┐
│  ubuntu01   │  tariq-vm   │centos-worker│
│  nginx pod  │  nginx pod  │  nginx pod  │
│ 10.42.0.x   │ 10.42.1.x   │ 10.42.3.x   │
└──────┬──────┴──────┬──────┴──────┬──────┘
       └─────────────┴─────────────┘
                     ↑
              NodePort Service :30080
              (accessible on ALL node IPs)

http://192.168.18.10:30080  ✅
http://192.168.18.11:30080  ✅
http://192.168.18.12:30080  ✅
```

---

## Project Structure

```
project-k3s/
├── install_k3s.yml          # Ansible: installs master + joins workers + copies kubeconfig
├── deploy_app.yml           # Ansible: deploys app + ConfigMap onto cluster
├── inventory.ini            # all 3 nodes with correct users and SSH keys
└── manifests/
    ├── configmap.yml        # Nginx HTML served via ConfigMap (not baked in image)
    └── nginx-deployment.yml # Deployment (3 replicas) + NodePort Service
```

---

## Kubernetes Concepts Demonstrated

| Concept | Implementation |
|---|---|
| Deployment | 3-replica Nginx across all nodes |
| Service (NodePort) | App accessible on port 30080 on any node |
| ConfigMap | HTML config externalised from Docker image |
| Rolling update | Zero-downtime config change via `kubectl apply` |
| Self-healing | Kubernetes restarts crashed pods automatically |
| kube-proxy | Cross-node traffic routing regardless of pod location |
| kubeconfig | Distributed to user's `~/.kube/config` by Ansible |

---

## How to Deploy

### Prerequisites

- Ansible installed on the control node
- SSH access to all three nodes
- Docker image available on Docker Hub (`tariqsudo/nginx-demo:latest`)
- Passwordless sudo configured for the Ansible user

### 1 — Clone the Repository

```bash
git clone https://github.com/Tariq-sudo/linux-homelab.git
cd linux-homelab/project-k3s
```

### 2 — Review and Update Inventory

Edit `inventory.ini` with your server IPs and usernames:

```ini
[control_node]
192.168.18.10 ansible_user=labadmin ansible_ssh_private_key_file=~/.ssh/id_rsa

[workers]
192.168.18.11 ansible_user=tariq ansible_ssh_private_key_file=~/.ssh/id_rsa
192.168.18.12 ansible_user=centos_server ansible_ssh_private_key_file=~/.ssh/id_rsa
```

### 3 — Install the K3s Cluster

```bash
ansible-playbook -i inventory.ini install_k3s.yml
```

This will:
- Install K3s master on the control node (skips if already installed)
- Retrieve the node join token automatically
- Install K3s agent on both workers and join them to the cluster
- Copy kubeconfig to `~/.kube/config` for passwordless kubectl access
- Verify all 3 nodes are Ready before completing

### 4 — Deploy the Application

```bash
ansible-playbook -i inventory.ini deploy_app.yml
```

This will:
- Apply the ConfigMap with custom HTML content
- Apply the Deployment (3 replicas) and NodePort Service
- Wait for the rolling rollout to complete
- Print pod status, service info, and app URLs

### 5 — Verify the Cluster

```bash
# All nodes should be Ready
kubectl get nodes

# All 3 pods should be Running, one per node
kubectl get pods -o wide

# Service should show NodePort :30080
kubectl get service nginx-web-service
```

### 6 — Access the Application

```
http://192.168.18.10:30080
http://192.168.18.11:30080
http://192.168.18.12:30080
```

---

## Key Technical Decisions

**Why K3s instead of full Kubernetes?**
K3s is a CNCF-certified Kubernetes distribution optimised for resource-constrained environments. It bundles everything into a single binary (including containerd, flannel, CoreDNS) and requires only 512MB RAM per node — ideal for home lab servers. The API and kubectl commands are identical to full Kubernetes.

**Why Traefik disabled?**
K3s ships with Traefik ingress which binds to ports 80 and 443. Since the worker nodes already run Nginx containers (from the CI/CD project) on port 80, Traefik was disabled during installation to avoid port conflicts. A dedicated Nginx Ingress Controller can be deployed separately when needed.

**Why ConfigMap for HTML instead of baking it into the image?**
Following the 12-Factor App principle of separating config from code. ConfigMaps allow content changes without rebuilding and pushing a new Docker image — just update the ConfigMap and Kubernetes rolls out new pods automatically. This also demonstrates how Kubernetes handles configuration injection at runtime.

**Why connection: local for control plane Ansible plays?**
The Ansible control node is the same machine as the K3s master. Using `connection: local` avoids unnecessary SSH loopback to localhost and is the correct Ansible pattern for managing the local machine.

**Why NodePort instead of LoadBalancer?**
LoadBalancer type requires a cloud provider (AWS ELB, GCP Load Balancer) to provision an external IP. In a home lab without a cloud provider, NodePort is the correct choice — it opens a port (30080) on every node's external IP, making the app accessible from any node.

---

## Zero-Downtime Rolling Update Demo

To see Kubernetes rolling updates in action:

```bash
# Edit the ConfigMap
kubectl edit configmap nginx-html

# Or re-apply updated manifests
kubectl apply -f manifests/configmap.yml
kubectl rollout restart deployment/nginx-web

# Watch pods replaced one at a time
kubectl rollout status deployment/nginx-web
```

Kubernetes ensures at least 2 pods are serving traffic throughout the update.

---

## Connect

- **LinkedIn:** [linkedin.com/in/tariq-mahmood-2714a232a](https://www.linkedin.com/in/tariq-mahmood-2714a232a/)
- **GitHub:** [github.com/Tariq-sudo/linux-homelab](https://github.com/Tariq-sudo/linux-homelab)
- **Docker Hub:** [hub.docker.com/u/tariqsudo](https://hub.docker.com/repositories/tariqsudo)

