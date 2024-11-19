# My Development Scripts and Configurations

This repository contains my personal collection of development scripts and configuration files. It's designed to make setting up a new development environment quick and consistent across different machines.

## 🚀 Quick Start

```bash
# Download the setup script
curl -O https://raw.githubusercontent.com/theaileverage/my-scripts/main/setup.sh
chmod +x setup.sh

# Run setup
./setup.sh
```

## 📦 What's Included

### Scripts (`scripts/`)

1. **aider-session**
   - Creates or attaches to a tmux session with dual-pane setup for aider
   - Supports architect and coder modes
   - Includes update checking functionality
   ```bash
   # Usage
   aider-session                 # Start or attach to a session
   aider-session --check-update  # Check for updates before starting
   aider-session --help         # Show help message
   ```

### Configurations (`config/`)

-- TODO

## 🛠️ Setup Script Options

The `setup.sh` script provides several options for customizing the installation:

```bash
Usage: setup.sh [OPTIONS]

Options:
    --install-dir DIR    Specify custom installation directory (default: ~/bin)
    --repo URL          Specify custom repository URL
    --force            Force installation even if files exist
    --no-backup        Skip backing up existing files
    -h, --help         Show this help message
```

## 📁 Directory Structure

```
.
├── README.md
├── setup.sh
├── scripts/
│   ├── aider-session
│   └── ... (other scripts)
└── config/
    └── ... (configuration files)
```

## ⚙️ Installation Details

The setup script will:

1. Create necessary directories (`~/bin` by default)
2. Clone this repository
3. Create symbolic links for all scripts in `scripts/` to your bin directory
4. Set up configuration files from `config/` to `~/.config/`
5. Add the bin directory to your PATH if needed
6. Backup any existing files before overwriting (unless --no-backup is used)

## 🔄 Updating

To update your scripts and configurations:

1. Pull the latest changes from the repository:
   ```bash
   cd /path/to/my-scripts
   git pull
   ```

2. Run the setup script again:
   ```bash
   ./setup.sh
   ```

The setup script will handle updating the symbolic links and configurations automatically.

## ⚠️ Prerequisites

The following tools need to be installed on your system:
- git
- curl
- tmux (for aider-session)
- conda (for aider environment)

## 🤝 Contributing

If you'd like to contribute:

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to your branch
5. Create a Pull Request

## 📝 Adding New Scripts

When adding new scripts:

1. Place the script in the `scripts/` directory
2. Test your changes locally
3. Update this README with documentation
4. Commit and push your changes

## 🔒 Security

- All scripts are symbolically linked, maintaining connection to the source
- Backup files are created with timestamps before overwriting
- No sensitive information should be stored in this repository

## 👤 Author

Ankeeth Suvarna
- GitHub: [@theaileverage](https://github.com/theaileverage)

