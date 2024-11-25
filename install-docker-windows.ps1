# Docker for Windows Installation Script
# Run this script as Administrator in PowerShell

# Function to print colored messages
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Check-AdminPrivileges {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-ColorOutput Red "This script must be run as Administrator"
        Write-ColorOutput Red "Please right-click PowerShell and select 'Run as Administrator'"
        exit 1
    }
}

function Check-SystemRequirements {
    Write-ColorOutput Green "Checking system requirements..."
    
    # Check Windows version
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $osVersion = [System.Environment]::OSVersion.Version
    
    if ($osVersion.Major -lt 10) {
        Write-ColorOutput Red "Docker Desktop requires Windows 10 or higher"
        exit 1
    }
    
    # Check if Hyper-V is available
    $hyperv = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
    if ($hyperv.State -ne "Enabled") {
        Write-ColorOutput Yellow "Hyper-V is not enabled. Enabling Hyper-V..."
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
        $restartRequired = $true
    }
    
    # Check if Containers feature is enabled
    $containers = Get-WindowsOptionalFeature -Online -FeatureName Containers
    if ($containers.State -ne "Enabled") {
        Write-ColorOutput Yellow "Windows Containers feature is not enabled. Enabling..."
        Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
        $restartRequired = $true
    }
    
    # Check WSL 2
    $wslInstalled = Get-Command wsl.exe -ErrorAction SilentlyContinue
    if (-not $wslInstalled) {
        Write-ColorOutput Yellow "WSL is not installed. Installing WSL..."
        wsl --install
        $restartRequired = $true
    }
    
    return $restartRequired
}

function Install-DockerDesktop {
    Write-ColorOutput Green "Downloading Docker Desktop for Windows..."
    
    # Create temporary directory
    $tempDir = Join-Path $env:TEMP "DockerInstall"
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    # Download Docker Desktop Installer
    $installerPath = Join-Path $tempDir "Docker.Desktop.Installer.exe"
    $dockerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
    
    try {
        Invoke-WebRequest -Uri $dockerUrl -OutFile $installerPath
        Write-ColorOutput Green "Docker Desktop installer downloaded successfully"
    }
    catch {
        Write-ColorOutput Red "Failed to download Docker Desktop installer"
        Write-ColorOutput Red $_.Exception.Message
        exit 1
    }
    
    # Install Docker Desktop
    Write-ColorOutput Green "Installing Docker Desktop..."
    Start-Process -Wait $installerPath -ArgumentList "install --quiet"
    
    # Clean up
    Remove-Item -Path $tempDir -Recurse -Force
}

function Configure-PostInstall {
    Write-ColorOutput Green "Configuring post-installation settings..."
    
    # Add current user to docker-users group
    $dockerGroup = "docker-users"
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    
    try {
        Add-LocalGroupMember -Group $dockerGroup -Member $currentUser -ErrorAction SilentlyContinue
        Write-ColorOutput Green "Added current user to docker-users group"
    }
    catch {
        Write-ColorOutput Yellow "User might already be in docker-users group"
    }
}

function Show-Instructions {
    Write-ColorOutput Green "`nDocker Desktop installation completed!`n"
    Write-ColorOutput Cyan "Post-Installation Instructions:"
    Write-ColorOutput White "1. Restart your computer if prompted"
    Write-ColorOutput White "2. After restart, Docker Desktop will start automatically"
    Write-ColorOutput White "3. Wait for the Docker Desktop welcome screen"
    Write-ColorOutput White "4. Accept the Docker Subscription Service Agreement"
    
    Write-ColorOutput Cyan "`nUseful Docker Commands:"
    Write-ColorOutput White "- docker version     : Check Docker version"
    Write-ColorOutput White "- docker ps         : List running containers"
    Write-ColorOutput White "- docker images     : List downloaded images"
    Write-ColorOutput White "- docker run hello-world : Test Docker installation"
    
    Write-ColorOutput Cyan "`nTroubleshooting:"
    Write-ColorOutput White "1. Make sure Hyper-V and Containers features are enabled"
    Write-ColorOutput White "2. Check if WSL 2 is properly installed"
    Write-ColorOutput White "3. Verify that virtualization is enabled in BIOS"
    Write-ColorOutput White "4. Run Docker Desktop as administrator for the first time"
}

# Main installation process
Clear-Host
Write-ColorOutput Cyan "Docker Desktop for Windows Installation Script"
Write-ColorOutput Cyan "============================================`n"

# Check if running as Administrator
Check-AdminPrivileges

# Check and configure system requirements
$restartNeeded = Check-SystemRequirements

# Install Docker Desktop
Install-DockerDesktop

# Configure post-installation settings
Configure-PostInstall

# Show final instructions
Show-Instructions

# Prompt for restart if needed
if ($restartNeeded) {
    Write-ColorOutput Yellow "`nYour system needs to be restarted to complete the installation"
    $restart = Read-Host "Would you like to restart now? (y/n)"
    if ($restart -eq 'y') {
        Restart-Computer -Force
    }
}
