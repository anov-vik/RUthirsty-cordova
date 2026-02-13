# Environment Setup Guide

## Local Build Environment

### Requirements
- Node.js 14+
- Java JDK 8 or 11
- Android Studio with SDK
- Gradle (included with Android Studio)

### Setup Steps

#### Windows
```cmd
# Install Android Studio from https://developer.android.com/studio

# Set environment variables (PowerShell as Admin)
setx ANDROID_HOME "%LOCALAPPDATA%\Android\Sdk"
setx PATH "%PATH%;%LOCALAPPDATA%\Android\Sdk\platform-tools"

# Restart terminal
```

#### macOS
```bash
# Install Android Studio
brew install --cask android-studio

# Add to ~/.zshrc or ~/.bash_profile
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools

# Reload shell
source ~/.zshrc
```

#### Linux
```bash
# Install Java
sudo apt update
sudo apt install openjdk-11-jdk

# Download Android command-line tools
wget https://dl.google.com/android/repository/commandlinetools-linux-latest.zip
unzip commandlinetools-linux-latest.zip
mkdir -p $HOME/Android/Sdk/cmdline-tools/latest
mv cmdline-tools/* $HOME/Android/Sdk/cmdline-tools/latest/

# Add to ~/.bashrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Install SDK components
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
```

### Verification
```bash
# Check Node
node -v

# Check Java
java -version

# Check Android SDK
echo $ANDROID_HOME
cordova requirements android
```

## GitHub Actions Setup

### Benefits
- No local Android SDK needed
- Automated builds on push
- 3-5 minute build time
- Free for public repositories

### Setup

Create `.github/workflows/build-apk.yml`:

```yaml
name: Build Android APK

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '11'
      - run: npm install -g cordova
      - run: cordova platform add android
      - run: cordova build android
      - uses: actions/upload-artifact@v4
        with:
          name: app-debug
          path: platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### Usage
1. Push code: `git push origin main`
2. Visit: https://github.com/USER/REPO/actions
3. Wait for green checkmark (3-5 min)
4. Download APK from Artifacts

## Cordova CLI

### Installation
```bash
npm install -g cordova
```

### Basic Commands
```bash
# Add Android platform
cordova platform add android

# Build debug APK
cordova build android

# Build release APK
cordova build android --release

# Build and install to device
cordova run android

# Check requirements
cordova requirements android
```

## APK Signing (Release)

### Generate Keystore
```bash
keytool -genkey -v -keystore my-release-key.keystore \
  -alias my-app \
  -keyalg RSA -keysize 2048 -validity 10000
```

### Sign APK
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore my-release-key.keystore \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  my-app
```

### Align APK
```bash
zipalign -v 4 \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  app-release.apk
```
