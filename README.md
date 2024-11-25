# Docker Installation Scripts

This repository contains a collection of scripts for automating Docker and Docker Compose installation across different operating systems. The scripts are designed to be user-friendly and include comprehensive error handling and system requirement checks.

## Available Scripts

1. `install-docker.sh` - Ubuntu installation script (Korean)
2. `install-docker-en.sh` - Ubuntu installation script (English)
3. `install-docker-universal.sh` - Universal Linux installation script
4. `install-docker-windows.ps1` - Windows installation script

## Features

- Automatic OS detection and compatibility checking
- Docker and Docker Compose installation
- User permission configuration
- Post-installation setup
- Comprehensive error handling
- Detailed progress feedback
- Common Docker commands guide

## System Requirements

### Linux (Ubuntu/Debian/CentOS/RHEL/Amazon Linux)
- Root or sudo privileges
- Internet connection
- bash shell
- Minimum 4GB RAM recommended
- 64-bit operating system

### Windows
- Windows 10/11 Pro, Enterprise, or Education (64-bit)
- Administrator privileges
- Hardware virtualization support (Intel VT-x or AMD-V)
- Minimum 4GB RAM (8GB recommended)
- WSL 2 support
- Internet connection

## Installation Instructions

### Ubuntu/Debian (Korean)
```bash
# Download the script
wget https://raw.githubusercontent.com/yourusername/docker-install/master/install-docker.sh

# Make it executable
chmod +x install-docker.sh

# Run the script
sudo ./install-docker.sh
```

### Ubuntu/Debian (English)
```bash
# Download the script
wget https://raw.githubusercontent.com/yourusername/docker-install/master/install-docker-en.sh

# Make it executable
chmod +x install-docker-en.sh

# Run the script
sudo ./install-docker-en.sh
```

### Universal Linux Script
```bash
# Download the script
wget https://raw.githubusercontent.com/yourusername/docker-install/master/install-docker-universal.sh

# Make it executable
chmod +x install-docker-universal.sh

# Run the script
sudo ./install-docker-universal.sh
```

### Windows
1. Open PowerShell as Administrator
2. Enable script execution (if needed):
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```
3. Run the script:
```powershell
.\install-docker-windows.ps1
```

## Post-Installation Verification

After installation, verify Docker is working correctly:

```bash
# Linux
docker --version
docker compose version
docker run hello-world

# Check Docker service status
sudo systemctl status docker
```

```powershell
# Windows
docker --version
docker compose version
docker run hello-world
```

## Common Docker Commands

```bash
# Container Management
docker ps                 # List running containers
docker ps -a              # List all containers
docker start <container>  # Start a container
docker stop <container>   # Stop a container
docker rm <container>     # Remove a container

# Image Management
docker images            # List downloaded images
docker pull <image>      # Download an image
docker rmi <image>       # Remove an image

# Docker Compose
docker compose up        # Start services
docker compose down      # Stop services
```

## Troubleshooting

### Linux
1. If you encounter permission errors:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

2. If Docker service fails to start:
```bash
sudo systemctl status docker
sudo journalctl -xu docker
```

### Windows
1. Ensure Hyper-V is enabled
2. Verify WSL 2 is properly installed
3. Check virtualization is enabled in BIOS
4. Run Docker Desktop as administrator

## Security Notes

- The scripts require root/administrator privileges
- Scripts download from official Docker repositories only
- User is added to docker group (Linux) or docker-users group (Windows)
- Default Docker configurations are security-focused

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## License

MIT License - feel free to use and modify for your needs.

## Acknowledgments

- Docker documentation
- Docker Community
- WSL 2 documentation
- PowerShell documentation

## Support

For support, please create an issue in the repository or contact the maintainer.

## Disclaimer

These scripts are provided as-is, without any warranty. Always review scripts before running them on your system.
