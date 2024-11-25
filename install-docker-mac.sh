#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# Function to print colored messages
print_message() {
    echo -e "${GREEN}==>${NC} ${BLUE}$1${NC}"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

# Function to check if running as root
check_root() {
    if [ "$(id -u)" = "0" ]; then
        print_error "This script should NOT be run as root"
        exit 1
    fi
}

# Function to check system requirements
check_system() {
    print_message "Checking system requirements..."
    
    # Check macOS version
    OS_VERSION=$(sw_vers -productVersion)
    print_message "macOS version: $OS_VERSION"
    
    if [ "$(echo $OS_VERSION | cut -d. -f1)" -lt "11" ]; then
        print_error "Docker Desktop requires macOS 11 or later"
        exit 1
    fi
    
    # Check processor architecture
    ARCH=$(uname -m)
    print_message "Processor architecture: $ARCH"
    
    # Check available disk space
    AVAILABLE_SPACE=$(df -h /System/Volumes/Data | awk 'NR==2 {print $4}' | sed 's/Gi//')
    if [ "${AVAILABLE_SPACE%.*}" -lt "20" ]; then
        print_warning "Less than 20GB of free space available. Docker Desktop requires at least 20GB of free space"
    fi
    
    # Check memory
    TOTAL_MEMORY=$(system_profiler SPHardwareDataType | grep "Memory:" | awk '{print $2}')
    if [ "$TOTAL_MEMORY" -lt "8" ]; then
        print_warning "Less than 8GB of RAM detected. Docker Desktop recommends at least 8GB of RAM"
    fi
}

# Function to check and install Homebrew
install_homebrew() {
    print_message "Checking for Homebrew installation..."
    
    if ! command -v brew &> /dev/null; then
        print_message "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [ "$ARCH" = "arm64" ]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        print_message "Homebrew is already installed"
        brew update
    fi
}

# Function to install Rosetta 2 for Apple Silicon Macs
install_rosetta() {
    if [ "$ARCH" = "arm64" ]; then
        print_message "Checking Rosetta 2 installation..."
        
        # Check if Rosetta is already installed
        if ! pkgutil --pkgs | grep -q "com.apple.pkg.RosettaUpdateAuto"; then
            print_message "Installing Rosetta 2..."
            softwareupdate --install-rosetta --agree-to-license
        else
            print_message "Rosetta 2 is already installed"
        fi
    fi
}

# Function to install Docker Desktop
install_docker() {
    print_message "Installing Docker Desktop..."
    
    # Check if Docker Desktop is already installed
    if [ -d "/Applications/Docker.app" ]; then
        print_message "Docker Desktop is already installed. Updating instead..."
        brew upgrade --cask docker
    else
        brew install --cask docker
    fi
    
    # Wait for Docker.app to be available
    while [ ! -d "/Applications/Docker.app" ]; do
        sleep 1
    done
    
    print_message "Starting Docker Desktop..."
    open -a Docker
    
    # Wait for Docker to start
    print_message "Waiting for Docker to start (this might take a few minutes)..."
    while ! docker system info &>/dev/null; do
        sleep 5
    done
}

# Function to install Docker Compose
install_docker_compose() {
    print_message "Installing Docker Compose..."
    
    if ! command -v docker-compose &> /dev/null; then
        brew install docker-compose
    else
        print_message "Docker Compose is already installed"
    fi
}

# Function to configure Docker
configure_docker() {
    print_message "Configuring Docker..."
    
    # Create Docker config directory if it doesn't exist
    mkdir -p ~/.docker
    
    # Basic configuration for Docker daemon
    cat > ~/.docker/daemon.json <<EOF
{
    "debug": false,
    "experimental": false,
    "features": {
        "buildkit": true
    }
}
EOF
}

# Function to verify installation
verify_installation() {
    print_message "Verifying installation..."
    
    # Check Docker version
    docker --version
    docker compose version
    
    # Run hello-world container
    print_message "Running test container..."
    docker run hello-world
}

# Function to show post-installation instructions
show_instructions() {
    print_message "Installation completed successfully!"
    echo
    print_message "Useful Docker commands:"
    echo "docker ps         : List running containers"
    echo "docker images    : List downloaded images"
    echo "docker --help    : Show Docker help"
    echo "docker compose --help : Show Docker Compose help"
    echo
    print_message "Docker Desktop settings can be accessed through the menu bar icon"
    echo
    print_message "To get started with Docker, visit: https://docs.docker.com/get-started/"
}

# Main installation process
main() {
    echo "Docker Desktop Installation Script for macOS"
    echo "=========================================="
    echo
    
    # Check if script is run as root
    check_root
    
    # Check system requirements
    check_system
    
    # Install Homebrew
    install_homebrew
    
    # Install Rosetta 2 if needed (Apple Silicon)
    install_rosetta
    
    # Install Docker Desktop
    install_docker
    
    # Install Docker Compose
    install_docker_compose
    
    # Configure Docker
    configure_docker
    
    # Verify installation
    verify_installation
    
    # Show instructions
    show_instructions
}

# Run main installation
main
