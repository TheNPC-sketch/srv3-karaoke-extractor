#!/bin/bash

set -e

echo "==============================="
echo " srv3 / YTSubExtractor Installer"
echo "==============================="

# Must be run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this installer with sudo:"
    echo "  sudo ./install.sh"
    exit 1
fi

# Detect original user (for HOME paths)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

echo "Installing dependencies..."

# ----------------------------------------
# System packages
# ----------------------------------------
apt update
apt install -y \
    curl \
    wget \
    ffmpeg \
    ca-certificates \
    gnupg \
    software-properties-common

# ----------------------------------------
# yt-dlp
# ----------------------------------------
if ! command -v yt-dlp &> /dev/null; then
    echo "Installing yt-dlp..."
    wget -q https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
    chmod +x /usr/local/bin/yt-dlp
else
    echo "yt-dlp already installed"
fi

# ----------------------------------------
# .NET 8 Runtime
# ----------------------------------------
if ! command -v dotnet &> /dev/null; then
    echo "Installing .NET 8 runtime..."
    wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O /tmp/microsoft-prod.deb
    dpkg -i /tmp/microsoft-prod.deb
    apt update
    apt install -y dotnet-runtime-8.0
else
    echo ".NET already installed"
fi

# ----------------------------------------
# YTSubConverter (.deb)
# ----------------------------------------
if [ ! -f "./YTSubConverter-Linux.deb" ]; then
    echo "ERROR: YTSubConverter-Linux.deb not found!"
    echo "Put it in the same directory as install.sh"
    exit 1
fi

echo "Installing YTSubConverter..."
apt install -y ./YTSubConverter-Linux.deb

# ----------------------------------------
# Create ytsubconverter CLI wrapper
# ----------------------------------------
echo "Creating ytsubconverter CLI..."

cat << 'EOF' > /usr/local/bin/ytsubconverter
#!/bin/bash
dotnet /opt/ytsubconverter/ytsubconverter.dll "$@"
EOF

chmod +x /usr/local/bin/ytsubconverter

# ----------------------------------------
# Install srv3 script globally
# ----------------------------------------
if [ ! -f "./srv3" ]; then
    echo "ERROR: srv3 script not found!"
    echo "Put your srv3 script in the same directory as install.sh"
    exit 1
fi

echo "Installing srv3 command..."
install -m 755 ./srv3 /usr/local/bin/srv3

# ----------------------------------------
# Ensure Videos directory exists
# ----------------------------------------
mkdir -p "$REAL_HOME/Videos"
chown "$REAL_USER":"$REAL_USER" "$REAL_HOME/Videos"

# ----------------------------------------
# Final checks
# ----------------------------------------
echo
echo "Verifying installation..."

yt-dlp --version
ytsubconverter --help > /dev/null || true
srv3 --help > /dev/null || true

echo
echo "==============================="
echo " INSTALLATION COMPLETE ✅"
echo "==============================="
echo
echo "You can now run from ANY directory:"
echo "  srv3 \"https://youtube.com/...\""
echo
