# Project: Containerized Application Deployment with Docker and CI/CD

## Objective

To deploy a web application using modern containerization technology (Docker) and implement a basic Continuous Integration/Continuous Deployment (CI/CD) pipeline for automated updates. This project demonstrates skills beyond traditional package management, moving into modern DevOps practices.

---

## Technologies Used

*   **Containerization:** Docker Engine
*   **Container Registry:** Docker Hub
*   **CI/CD Automation:** Watchtower
*   **Operating System:** Ubuntu Server 24.04
*   **Networking:** UFW, Port Mapping

---

## Project Breakdown & Skills Demonstrated

### 1. Docker Environment Setup
*   Installed and configured the Docker Engine on a clean Ubuntu Server environment from the official Docker repository.
*   Managed user permissions by adding a non-root user to the `docker` group, following security best practices to avoid running all commands as `sudo`.
*   Successfully troubleshot and resolved complex, non-standard system-level issues (including shell function overrides and corrupted Docker data caches) to achieve a stable environment, demonstrating advanced diagnostic and problem-solving abilities.

### 2. Containerized Application Deployment
*   Pulled a pre-built web application image (`traefik/whoami`) from Docker Hub.
*   Launched the application as a container using `docker run`, configuring it to run in detached mode (`-d`) and to restart automatically (`--restart always`) for service resilience.
*   **Published the container's internal port 80 to the host's port 8000** (`-p 8000:80`), making the application accessible on the local network.
*   Configured the host system's UFW firewall to allow traffic on the newly exposed port.

### 3. Automated Deployment Pipeline (CI/CD)
*   Deployed Watchtower, a service that automates the container update process.
*   **Gave Watchtower access to the host's Docker API** by securely mounting the Docker socket (`-v /var/run/docker.sock:/var/run/docker.sock`).
*   This setup creates a CI/CD pipeline where Watchtower automatically detects if a new version of the `whoami` image is pushed to Docker Hub, pulls the new image, and gracefully redeploys the container with zero manual intervention.

---

## Key Takeaways

This project was a deep dive into the fundamentals of containerization. It highlights the efficiency and portability of deploying applications with Docker compared to a traditional LEMP stack installation. Furthermore, implementing the Watchtower automation demonstrates a forward-thinking approach to system maintenance, moving from manual updates to a self-managing infrastructure.
