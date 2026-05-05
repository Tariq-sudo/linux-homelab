# Project: Automated Server Configuration with Ansible (IaC)

## Objective

To automate the deployment of Nginx onto Ubuntu using Ansible. This project moves beyond manual configuration and embraces the DevOps practice of **Infrastructure as Code (IaC)**.

---

## Core Concepts & Technologies

*   **Infrastructure as Code (IaC):** The practice of managing and provisioning infrastructure through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools. My server's state is defined in the `nginx_installation_playbook.yml` file.
*   **Ansible:** A leading open-source automation tool that uses SSH to connect to servers and execute tasks. It is agentless, meaning no special software needs to be installed on the managed nodes.
*   **Ansible Control Node:** The machine where Ansible is installed and playbook is executed from (in my lab, this was an Ubuntu Control_Node_Server).
*   **Managed Nodes:** The target servers being configured (Managed_Node_Server).
*   **Inventory:** A file that lists the managed nodes, grouped for easy targeting.
*   **Playbook:** A YAML file that defines a set of tasks to be executed on a managed node.
*   **Idempotence:** A core principle of Ansible. A playbook can be run multiple times, but it will only make a change if the server's state does not match the desired state defined in the playbook. This ensures predictable outcomes and prevents errors from repeated runs.

---

## Project Breakdown & Skills Demonstrated

### 1. Environment Setup
*   Configured a dedicated Ansible Control Node.
*   Established secure, **passwordless SSH key-based authentication** between the control node and managed node, a foundational requirement for secure automation.

### 2. Playbook Development
*   Authored playbook to deploy nginx installation on **Debian-family (Ubuntu)** operating system.
*   Demonstrated knowledge of appropriate Ansible module for target:
    *   `ansible.builtin.apt` (with `update_cache: yes`) for package management on Ubuntu.
*   Utilized abstracted modules like `ansible.builtin.service` that works for managing services with `systemctl`.

### 3. Troubleshooting & Security Configuration
*   Successfully diagnosed and resolved a common "Missing sudo password" failure by identifying a mismatch between the Ansible user in the inventory and the user granted `NOPASSWD` rights in the `sudoers` file on the managed node.
*   This demonstrates a deep understanding of user permissions and the interaction between Ansible's `become` mechanism and Linux's `sudo` security policies.

---

## Final Result

The result is a fully automated, idempotent script that can provision a new, untouched server into a fully functional web server in minutes. This drastically reduces manual effort, eliminates configuration errors, and makes the server setup process repeatable and reliable.
