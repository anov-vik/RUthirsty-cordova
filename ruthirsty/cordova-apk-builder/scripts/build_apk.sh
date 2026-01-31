#!/bin/bash

# Cordova APK Builder
# Builds Android APK with various options

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default values
BUILD_TYPE="debug"
AUTO_INSTALL=false
CLEAN_BUILD=false
PROJECT_DIR="."

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --release)
            BUILD_TYPE="release"
            shift
            ;;
        --install)
            AUTO_INSTALL=true
            shift
            ;;
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        --project)
            PROJECT_DIR="$2"
            shift 2
            ;;
        --help)
            echo "Cordova APK Builder"
            echo ""
            echo "Usage: build_apk.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --release       Build release APK (unsigned)"
            echo "  --install       Install to connected device after build"
            echo "  --clean         Clean build directories before building"
            echo "  --project DIR   Specify Cordova project directory (default: current)"
            echo "  --help          Show this help message"
            echo ""
            echo "Examples:"
            echo "  build_apk.sh                    # Build debug APK"
            echo "  build_apk.sh --release          # Build release APK"
            echo "  build_apk.sh --install          # Build and install"
            echo "  build_apk.sh --clean --release  # Clean build release APK"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

cd "$PROJECT_DIR"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}🔨 Cordova APK Builder${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verify this is a Cordova project
if [ ! -f "config.xml" ]; then
    echo -e "${RED}✗ Error: Not a Cordova project (config.xml not found)${NC}"
    exit 1
fi

APP_NAME=$(grep -oP '(?<=<name>)[^<]+' config.xml | head -1)
APP_VERSION=$(grep -oP '(?<=version=")[^"]+' config.xml | head -1)

echo "📱 App: $APP_NAME"
echo "📦 Version: $APP_VERSION"
echo "🔧 Build Type: $BUILD_TYPE"
echo ""

# Clean if requested
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "${YELLOW}🧹 Cleaning build directories...${NC}"
    rm -rf platforms/android/app/build
    rm -rf platforms/android/build
    echo -e "${GREEN}✓ Clean complete${NC}"
    echo ""
fi

# Check for Android platform
if [ ! -d "platforms/android" ]; then
    echo -e "${YELLOW}⚠ Android platform not found, adding...${NC}"
    cordova platform add android
    echo ""
fi

# Build APK
echo -e "${BLUE}🔨 Building $BUILD_TYPE APK...${NC}"
echo ""

if [ "$BUILD_TYPE" = "release" ]; then
    cordova build android --release
else
    cordova build android
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}✓ Build successful!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Find and display APK location
if [ "$BUILD_TYPE" = "release" ]; then
    APK_PATH="platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk"
else
    APK_PATH="platforms/android/app/build/outputs/apk/debug/app-debug.apk"
fi

if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    APK_FULL_PATH=$(realpath "$APK_PATH")

    echo "📍 APK Location:"
    echo "   $APK_FULL_PATH"
    echo ""
    echo "📊 APK Size: $APK_SIZE"
    echo ""

    if [ "$BUILD_TYPE" = "release" ]; then
        echo -e "${YELLOW}⚠ Note: Release APK is unsigned and needs signing before distribution${NC}"
        echo ""
    fi

    # Install if requested
    if [ "$AUTO_INSTALL" = true ]; then
        echo -e "${BLUE}📲 Installing to device...${NC}"

        # Check for connected devices
        if command -v adb &> /dev/null; then
            DEVICES=$(adb devices | grep -v "List" | grep "device$" | wc -l)

            if [ $DEVICES -eq 0 ]; then
                echo -e "${RED}✗ No Android devices connected${NC}"
                echo "  Connect a device with USB debugging enabled"
                exit 1
            elif [ $DEVICES -eq 1 ]; then
                echo "  Found 1 device, installing..."
                adb install -r "$APK_PATH"
                echo -e "${GREEN}✓ Installation complete!${NC}"
            else
                echo "  Found $DEVICES devices"
                cordova run android
            fi
        else
            cordova run android
        fi
    else
        echo -e "${BLUE}💡 To install, run:${NC}"
        echo "   adb install -r $APK_PATH"
        echo "   or: cordova run android"
    fi
else
    echo -e "${RED}✗ APK not found at expected location${NC}"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
