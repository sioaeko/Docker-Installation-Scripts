#!/bin/bash

# Function to print colored messages
print_message() {
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
    echo -e "${GREEN}==>${NC} ${BLUE}$1${NC}"
}

# Check if script is run with root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "This script must be run as root"
    echo "Please run again with: sudo bash $0"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION_ID=$VERSION_ID
else
    echo "Cannot detect OS version"
    exit 1
fi

print_message "Detected OS: $OS $VERSION_ID"

# Function to install Docker on RHEL/CentOS
install_docker_rhel() {
    print_message "Installing Docker on RHEL/CentOS..."
    
    # Remove old versions
    yum remove -y docker docker-client docker-client-latest docker-common \
        docker-latest docker-latest-logrotate docker-logrotate docker-engine
    
    # Install required packages
    yum install -y yum-utils
    
    # Add Docker repository
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    
    # Install Docker
    yum install -y docker-ce docker-ce-cli containerd.io
    
    # Start and enable Docker service
    systemctl start docker
    systemctl enable docker
}

# Function to install Docker on Ubuntu/Debian
install_docker_debian() {
    print_message "Installing Docker on Ubuntu/Debian..."
    
    # Remove old versions
    apt-get remove -y docker docker-engine docker.io containerd runc
    
    # Update package index
    apt-get update
    
    # Install required packages
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release
    
    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/${OS}/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Set up the repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${OS} \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    apt-get update
    
    # Install Docker
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

# Function to install Docker on Amazon Linux 2
install_docker_amazon() {
    print_message "Installing Docker on Amazon Linux 2..."
    
    # Update package index
    yum update -y
    
    # Install Docker
    yum install -y docker
    
    # Start and enable Docker service
    systemctl start docker
    systemctl enable docker
}

# Function to install Docker Compose
install_docker_compose() {
    print_message "Installing Docker Compose..."
    
    mkdir -p ~/.docker/cli-plugins/
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    
    # Create symbolic link for global access
    ln -sf ~/.docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
}

# Function to set up user permissions
setup_user_permissions() {
    print_message "Setting up user permissions..."
    
    # Add docker group if it doesn't exist
    getent group docker || groupadd docker
    
    # Add user to docker group
    USER_NAME=$(logname || echo $SUDO_USER || echo $USER)
    usermod -aG docker $USER_NAME
}

# Main installation process
print_message "Starting Docker installation process..."

case $OS in
    "rhel"|"centos")
        install_docker_rhel
        ;;
    "ubuntu"|"debian")
        install_docker_debian
        ;;
    "amzn")
        install_docker_amazon
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

# Install Docker Compose
install_docker_compose

# Setup user permissions
setup_user_permissions

# Verify installations
print_message "Verifying installations..."
docker --version
docker compose version

print_message "Installation completed successfully!"
print_message "To apply changes without reboot, run: newgrp docker"
print_message "To verify installation, run: docker run hello-world"

# Print helpful commands
echo ""
print_message "Common Docker Commands:"
echo "docker ps         : List running containers"
echo "docker images    : List downloaded images"
echo "docker --help    : Show Docker help"
echo "docker-compose --help : Show Docker Compose help"
echo ""
print_message "System Commands:"
echo "systemctl status docker : Check Docker service status"
echo "systemctl start docker : Start Docker service"
echo "systemctl stop docker  : Stop Docker service"
echo "systemctl restart docker : Restart Docker service"
