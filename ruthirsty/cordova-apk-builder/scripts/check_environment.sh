#!/bin/bash

# Cordova Environment Checker
# Validates all requirements for Android APK building

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Checking Cordova Build Environment..."
echo ""

ERRORS=0
WARNINGS=0

# Check Node.js
echo -n "Checking Node.js... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓${NC} Found: $NODE_VERSION"
else
    echo -e "${RED}✗${NC} Node.js not found"
    echo "  Install from: https://nodejs.org/"
    ERRORS=$((ERRORS + 1))
fi

# Check npm
echo -n "Checking npm... "
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓${NC} Found: v$NPM_VERSION"
else
    echo -e "${RED}✗${NC} npm not found"
    ERRORS=$((ERRORS + 1))
fi

# Check Cordova CLI
echo -n "Checking Cordova... "
if command -v cordova &> /dev/null; then
    CORDOVA_VERSION=$(cordova -v)
    echo -e "${GREEN}✓${NC} Found: $CORDOVA_VERSION"
else
    echo -e "${RED}✗${NC} Cordova CLI not found"
    echo "  Install: npm install -g cordova"
    ERRORS=$((ERRORS + 1))
fi

# Check Java JDK
echo -n "Checking Java JDK... "
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo -e "${GREEN}✓${NC} Found: $JAVA_VERSION"

    # Check Java version (should be 11+)
    JAVA_MAJOR=$(echo $JAVA_VERSION | cut -d'.' -f1)
    if [ "$JAVA_MAJOR" -lt 11 ]; then
        echo -e "${YELLOW}⚠${NC} Java 11+ recommended (found $JAVA_VERSION)"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo -e "${RED}✗${NC} Java JDK not found"
    echo "  Install JDK 11+: https://adoptium.net/"
    ERRORS=$((ERRORS + 1))
fi

# Check ANDROID_HOME
echo -n "Checking ANDROID_HOME... "
if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
    echo -e "${GREEN}✓${NC} Set: $ANDROID_HOME"
else
    echo -e "${RED}✗${NC} ANDROID_HOME not set or invalid"
    echo "  Set environment variable to Android SDK location"
    echo "  Example: export ANDROID_HOME=\$HOME/Android/Sdk"
    ERRORS=$((ERRORS + 1))
fi

# Check Android SDK tools
if [ -n "$ANDROID_HOME" ] && [ -d "$ANDROID_HOME" ]; then
    echo -n "Checking Android SDK tools... "
    if [ -d "$ANDROID_HOME/tools" ] || [ -d "$ANDROID_HOME/cmdline-tools" ]; then
        echo -e "${GREEN}✓${NC} Found"
    else
        echo -e "${YELLOW}⚠${NC} SDK tools not found in ANDROID_HOME"
        WARNINGS=$((WARNINGS + 1))
    fi

    echo -n "Checking Android platform-tools... "
    if [ -d "$ANDROID_HOME/platform-tools" ]; then
        echo -e "${GREEN}✓${NC} Found"
    else
        echo -e "${RED}✗${NC} platform-tools not found"
        echo "  Install Android SDK platform-tools"
        ERRORS=$((ERRORS + 1))
    fi
fi

# Check Gradle
echo -n "Checking Gradle... "
if command -v gradle &> /dev/null; then
    GRADLE_VERSION=$(gradle -v 2>&1 | grep "Gradle" | head -n 1)
    echo -e "${GREEN}✓${NC} Found: $GRADLE_VERSION"
else
    echo -e "${YELLOW}⚠${NC} Gradle not in PATH (Cordova will use its own)"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Environment ready for building!${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ $WARNINGS warning(s) - build may still work${NC}"
    fi
    exit 0
else
    echo -e "${RED}✗ Found $ERRORS error(s) - cannot build${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ Also found $WARNINGS warning(s)${NC}"
    fi
    exit 1
fi
