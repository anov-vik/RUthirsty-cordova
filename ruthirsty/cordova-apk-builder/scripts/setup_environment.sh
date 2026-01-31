#!/bin/bash

# Auto-setup script for Cordova Android build environment
# Attempts to install and configure required tools

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}🔧 Cordova Android Environment Setup${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Detect OS
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
fi

echo "📍 Detected OS: $OS"
echo ""

# Check and install Cordova
echo "Checking Cordova CLI..."
if ! command -v cordova &> /dev/null; then
    echo -e "${YELLOW}Installing Cordova CLI...${NC}"
    npm install -g cordova
    echo -e "${GREEN}✓ Cordova installed${NC}"
else
    CORDOVA_VERSION=$(cordova -v)
    echo -e "${GREEN}✓ Cordova found: $CORDOVA_VERSION${NC}"
fi
echo ""

# Check Java
echo "Checking Java JDK..."
if ! command -v java &> /dev/null; then
    echo -e "${RED}✗ Java JDK not found${NC}"
    echo ""
    echo "Please install Java JDK 11 or higher:"
    echo "  - Download: https://adoptium.net/"
    echo "  - Or use package manager:"

    if [ "$OS" = "linux" ]; then
        echo "    sudo apt-get install openjdk-11-jdk"
    elif [ "$OS" = "mac" ]; then
        echo "    brew install openjdk@11"
    fi

    exit 1
else
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo -e "${GREEN}✓ Java found: $JAVA_VERSION${NC}"
fi
echo ""

# Check/Setup Android SDK
echo "Checking Android SDK..."

ANDROID_SDK_DIR=""

# Try common locations
if [ -d "$HOME/Android/Sdk" ]; then
    ANDROID_SDK_DIR="$HOME/Android/Sdk"
elif [ -d "$HOME/Library/Android/sdk" ]; then
    ANDROID_SDK_DIR="$HOME/Library/Android/sdk"
elif [ -d "/usr/local/android-sdk" ]; then
    ANDROID_SDK_DIR="/usr/local/android-sdk"
elif [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
    ANDROID_SDK_DIR="$ANDROID_HOME"
fi

if [ -n "$ANDROID_SDK_DIR" ]; then
    echo -e "${GREEN}✓ Android SDK found at: $ANDROID_SDK_DIR${NC}"

    # Set environment variable for current session
    export ANDROID_HOME="$ANDROID_SDK_DIR"
    export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"

    echo ""
    echo -e "${BLUE}📝 Environment variables set for this session${NC}"
    echo ""

    # Suggest permanent setup
    SHELL_RC=""
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    fi

    if [ -n "$SHELL_RC" ]; then
        if ! grep -q "ANDROID_HOME" "$SHELL_RC"; then
            echo -e "${YELLOW}💡 To make this permanent, add to $SHELL_RC:${NC}"
            echo ""
            echo "  export ANDROID_HOME=$ANDROID_SDK_DIR"
            echo "  export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
            echo ""

            read -p "Would you like me to add this automatically? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo "" >> "$SHELL_RC"
                echo "# Android SDK" >> "$SHELL_RC"
                echo "export ANDROID_HOME=$ANDROID_SDK_DIR" >> "$SHELL_RC"
                echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools" >> "$SHELL_RC"
                echo -e "${GREEN}✓ Added to $SHELL_RC${NC}"
                echo "  Run: source $SHELL_RC"
            fi
            echo ""
        fi
    fi
else
    echo -e "${RED}✗ Android SDK not found${NC}"
    echo ""
    echo "Android SDK is required to build APK files."
    echo ""
    echo "Installation options:"
    echo ""
    echo "1. Install Android Studio (Recommended):"
    echo "   - Download: https://developer.android.com/studio"
    echo "   - Install and run Android Studio"
    echo "   - Go to: Settings → Appearance & Behavior → System Settings → Android SDK"
    echo "   - Install SDK Platform and Build Tools"
    echo ""
    echo "2. Install SDK command-line tools only:"
    echo "   - Download: https://developer.android.com/studio#command-tools"
    echo "   - Extract to ~/Android/Sdk"
    echo ""
    echo "After installation, set ANDROID_HOME:"
    echo "  export ANDROID_HOME=\$HOME/Android/Sdk"
    echo "  export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools"
    echo ""

    exit 1
fi

# Verify Cordova requirements
echo "Verifying Cordova requirements..."
echo ""
cordova requirements android || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✓ Setup complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "You can now build your Cordova app:"
echo "  cordova build android"
echo ""
