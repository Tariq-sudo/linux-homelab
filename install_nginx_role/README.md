# Ansible Nginx Installation Role

A professional, cross-platform Ansible role for installing and configuring Nginx on Ubuntu and CentOS systems.

## 🚀 Features

- ✅ **Multi-OS Support**: Works on Ubuntu (Debian) and CentOS/RHEL (RedHat)
- ✅ **Template-based Configuration**: Deploy custom `index.html` using Jinja2 templates
- ✅ **Handler System**: Smart restart only when configuration changes
- ✅ **Variable-driven**: Customize paths, package names, and server names
- ✅ **Production-ready**: Follows Ansible best practices and role structure

## 📁 Project Structure
roles/nginx_role/
├── defaults/ # Default variables (safe to override)
├── handlers/ # Service restart handlers
├── tasks/ # Main installation logic
├── templates/ # Jinja2 templates (index.html)
└── vars/ # Role-specific variables

text


## 🛠 Usage

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/ansible-nginx-role.git
cd ansible-nginx-role
2. Configure inventory
Copy and edit the inventory file:

Bash

cp inventory.example.ini inventory.ini
nano inventory.ini  # Add your server IPs and usernames
3. Run the playbook
Bash

ansible-playbook -i inventory.ini install_nginx.yml
🔧 Customization
All variables are defined in roles/nginx_role/defaults/main.yml:

YAML

nginx_package_name: nginx
nginx_service_name: nginx
nginx_index_path_debian: /var/www/html/index.html
nginx_index_path_redhat: /usr/share/nginx/html/index.html
nginx_server_name: "Tariq DevOps Lab"
Override in your playbook or group_vars if needed.

🧪 Testing
The role has been tested on:

Ubuntu 22.04/24.04
CentOS Stream 9/10
📚 Learning Resources
This role demonstrates:

Ansible role structure
Jinja2 templating
Handlers and notifications
OS detection with ansible_facts
Cross-platform package management
🤝 Contributing
Feel free to fork and improve! Suggestions:

Add firewall configuration
Add SSL/TLS support
Add Docker deployment option
Add Molecule tests
📄 License
MIT

👨‍💻 Author
Tariq Mahmood - DevOps Engineer in training
EOF

text


---

# 📋 **Step 4: Create Example Inventory**

```bash
cat > inventory.example.ini << 'EOF'
[webservers]
# Ubuntu server
192.168.18.29 ansible_user=labadmin

# CentOS server
192.168.18.30 ansible_user=centos_server

[webservers:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
🔄 Step 5: Initialize Git & Push
Bash

# Initialize git (if not already done)
git init

# Add all files
git add .

# Check what's being added
git status

# Commit
git commit -m "feat: initial commit - professional nginx role with templates and handlers"

# Create main branch (if not exists)
git branch -M main

# Add your GitHub remote (replace with YOUR repo URL)
git remote add origin https://github.com/YOUR_USERNAME/ansible-nginx-role.git

# Push to GitHub
git push -u origin main
🔐 Step 6: Create GitHub Repository
Go to github.com/new
Repository name: ansible-nginx-role (or your choice)
DO NOT check "Add a README file" (we already have one)
DO NOT add .gitignore or license (we created our own)
Click "Create repository"
🚀 Step 7: If You Get "Remote Already Exists" Error
If you already created a repo on GitHub with a README:

Bash

# Pull first (merge)
git pull origin main --allow-unrelated-histories

# If there are conflicts, resolve them in README.md
# Then:
git add README.md
git commit -m "Merge GitHub's README with mine"
git push
✅ Step 8: Verify on GitHub
Visit: https://github.com/YOUR_USERNAME/ansible-nginx-role

You should see:

✅ README.md (beautifully rendered)
✅ Role structure
✅ All files
🎯 Professional Touch (Optional but Recommended)
Add a meta/main.yml to your role:
Bash

mkdir -p roles/nginx_role/meta
cat > roles/nginx_role/meta/main.yml << 'EOF'
---
galaxy_info:
  author: Tariq Mahmood
  description: Install and configure Nginx on Ubuntu and CentOS
  company: Your Company (or Personal)
  license: MIT
  min_ansible_version: "2.9"
  platforms:
    - name: Ubuntu
      versions:
        - jammy
        - noble
    - name: CentOS
      versions:
        - "9"
        - "10"
  galaxy_tags:
    - nginx
    - web
    - webserver
    - ubuntu
    - centos
    - rhel
