#!/bin/bash

# Script name for help display
SCRIPT_NAME=$(basename "$0")

# Default values
REPO_URL="https://github.com/theaileverage/my-scripts.git"
REPO_NAME="my-scripts"
INSTALL_DIR="$HOME/bin"
BACKUP_SUFFIX=".backup.$(date +%Y%m%d_%H%M%S)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display help message
show_help() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS]

Setup development environment by installing scripts and configurations
from theaileverage/my-scripts repository.

Options:
    --install-dir DIR    Specify custom installation directory (default: ~/bin)
    --repo URL          Specify custom repository URL
    --force            Force installation even if files exist
    --no-backup        Skip backing up existing files
    -h, --help         Show this help message

Example:
    $SCRIPT_NAME                     # Standard installation
    $SCRIPT_NAME --force            # Force installation
    $SCRIPT_NAME --install-dir ~/custom-bin  # Custom installation directory
EOF
}

# Function to log messages
log() {
    local level=$1
    shift
    case "$level" in
        "error") echo -e "${RED}[ERROR]${NC} $*" ;;
        "success") echo -e "${GREEN}[SUCCESS]${NC} $*" ;;
        "warning") echo -e "${YELLOW}[WARNING]${NC} $*" ;;
        *) echo -e "$*" ;;
    esac
}

# Function to check if command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        log "error" "$1 is not installed. Please install it first."
        return 1
    fi
    return 0
}

# Function to backup file
backup_file() {
    local file=$1
    if [ -e "$file" ] && [ "$NO_BACKUP" != "true" ]; then
        cp "$file" "${file}${BACKUP_SUFFIX}"
        log "warning" "Backed up $file to ${file}${BACKUP_SUFFIX}"
    fi
}

# Function to create symbolic link
create_link() {
    local source=$1
    local target=$2
    
    # Check if target already exists
    if [ -e "$target" ]; then
        if [ "$FORCE" = "true" ]; then
            backup_file "$target"
            rm -f "$target"
        else
            log "error" "$target already exists. Use --force to override."
            return 1
        fi
    fi
    
    ln -s "$source" "$target"
    log "success" "Created symbolic link: $target -> $source"
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --install-dir) INSTALL_DIR="$2"; shift ;;
        --repo) REPO_URL="$2"; shift ;;
        --force) FORCE=true ;;
        --no-backup) NO_BACKUP=true ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Check required commands
for cmd in git curl mkdir ln; do
    check_command "$cmd" || exit 1
done

# Create installation directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Create temporary directory for cloning
TEMP_DIR=$(mktemp -d)
log "info" "Created temporary directory: $TEMP_DIR"

# Clone repository
log "info" "Cloning repository from $REPO_URL..."
if ! git clone "$REPO_URL" "$TEMP_DIR/$REPO_NAME"; then
    log "error" "Failed to clone repository"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Create symbolic links for scripts
log "info" "Installing scripts..."
for script in "$TEMP_DIR/$REPO_NAME/scripts"/*; do
    if [ -f "$script" ]; then
        # Make script executable
        chmod +x "$script"
        
        # Create symbolic link
        script_name=$(basename "$script")
        create_link "$script" "$INSTALL_DIR/$script_name"
    fi
done

# Handle configurations
log "info" "Setting up configurations..."
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

for config in "$TEMP_DIR/$REPO_NAME/config"/*; do
    if [ -e "$config" ]; then
        config_name=$(basename "$config")
        create_link "$config" "$CONFIG_DIR/$config_name"
    fi
done

# Add bin directory to PATH if not already present
SHELL_RC="$HOME/.$(basename "$SHELL")rc"
if ! grep -q "export PATH=\"\$HOME/bin:\$PATH\"" "$SHELL_RC"; then
    log "info" "Adding $INSTALL_DIR to PATH in $SHELL_RC"
    echo -e "\n# Added by setup script\nexport PATH=\"\$HOME/bin:\$PATH\"" >> "$SHELL_RC"
    log "warning" "Please run 'source $SHELL_RC' to update your PATH"
fi

# Cleanup
rm -rf "$TEMP_DIR"
log "success" "Installation completed successfully!"
log "info" "You may need to restart your shell or run 'source $SHELL_RC' to use the installed scripts."

# Display installed scripts
log "info" "Installed scripts:"
ls -l "$INSTALL_DIR"
