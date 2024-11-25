# 🐳 Docker Installation Scripts

<div align="center">
  <img src="https://raw.githubusercontent.com/docker/docker.github.io/master/images/docker-logo.png" alt="Docker Logo" width="200"/>

  [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
  [![OS Support](https://img.shields.io/badge/OS-Linux%20%7C%20macOS%20%7C%20Windows-brightgreen.svg)](https://github.com/sioaeko/Docker-Installation-Scripts)
  [![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-M1%2FM2%20Support-orange.svg)](https://github.com/sioaeko/Docker-Installation-Scripts)
</div>

## 📋 Overview

A comprehensive collection of scripts for automating Docker and Docker Compose installation across different operating systems. These scripts are designed to be user-friendly and include comprehensive error handling and system requirement checks.

## ✨ Features

- 🔄 Automatic OS detection and compatibility checking
- 📦 Docker and Docker Compose installation
- 👤 User permission configuration
- ⚙️ Post-installation setup
- 🚨 Comprehensive error handling
- 📝 Detailed progress feedback
- 📚 Common Docker commands guide

## 💻 System Requirements

### Linux Systems
- Root or sudo privileges
- Internet connection
- bash shell
- Minimum 4GB RAM recommended
- 64-bit operating system

### macOS Systems
- macOS 11 (Big Sur) or later
- 8GB RAM (16GB recommended)
- 20GB available disk space
- Admin user account
- Rosetta 2 (M1/M2 Macs)

### Windows Systems
- Windows 10/11 Pro, Enterprise, or Education (64-bit)
- Administrator privileges
- Hardware virtualization support
- Minimum 4GB RAM (8GB recommended)
- WSL 2 support

## 🚀 Installation Instructions

### Ubuntu/Debian (Korean)
```bash
wget https://raw.githubusercontent.com/sioaeko/Docker-Installation-Scripts/main/install-docker-kr.sh
chmod +x install-docker-kr.sh
sudo ./install-docker-kr.sh
```

### Ubuntu/Debian (English)
```bash
wget https://raw.githubusercontent.com/sioaeko/Docker-Installation-Scripts/main/install-docker.sh
chmod +x install-docker.sh
sudo ./install-docker.sh
```

### Universal Linux Script
```bash
wget https://raw.githubusercontent.com/sioaeko/Docker-Installation-Scripts/main/install-docker-universal.sh
chmod +x install-docker-universal.sh
sudo ./install-docker-universal.sh
```

### macOS
```bash
curl -O https://raw.githubusercontent.com/sioaeko/Docker-Installation-Scripts/main/install-docker-mac.sh
chmod +x install-docker-mac.sh
./install-docker-mac.sh
```

### Windows
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-docker-windows.ps1
```

## ✅ Post-Installation Verification

Verify Docker is working correctly:

```bash
# Check versions
docker --version
docker compose version

# Run test container
docker run hello-world

# Check Docker service status (Linux)
sudo systemctl status docker
```

## 🛠️ Common Docker Commands

### Container Management
```bash
docker ps         # List running containers
docker ps -a      # List all containers
docker start      # Start a container
docker stop       # Stop a container
docker rm         # Remove a container
```

### Image Management
```bash
docker images    # List images
docker pull      # Download an image
docker rmi       # Remove an image
```

### Docker Compose
```bash
docker compose up    # Start services
docker compose down  # Stop services
```

## 🔧 Troubleshooting

### Linux Issues
```bash
# Fix permissions
sudo usermod -aG docker $USER
newgrp docker

# Service issues
sudo systemctl status docker
sudo journalctl -xu docker
```

### macOS Issues
```bash
# Reset Docker Desktop
killall Docker && open -a Docker

# Fix Homebrew permissions
sudo chown -R $(whoami):admin /usr/local
```

### Windows Issues
- Ensure Hyper-V is enabled
- Verify WSL 2 is properly installed
- Check virtualization is enabled in BIOS
- Run Docker Desktop as administrator

## 🔒 Security Notes

- Scripts require root/administrator privileges
- Downloads from official Docker repositories only
- User added to docker group (Linux) or docker-users group (Windows)
- Default Docker configurations are security-focused

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

## 💬 Support

For support:
1. Check the troubleshooting guide above
2. Review [Docker's official documentation](https://docs.docker.com/)
3. Create an issue in the repository
4. Contact the maintainer

## ⚠️ Disclaimer

These scripts are provided as-is, without warranty. Always review scripts before running them on your system.
