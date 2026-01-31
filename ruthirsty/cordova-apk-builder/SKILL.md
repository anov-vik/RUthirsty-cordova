---
name: cordova-apk-builder
description: Build Android APK packages from Cordova projects with environment checking, dependency management, and troubleshooting. Use when building Android APKs from Cordova applications, debugging build failures, or setting up Cordova build environments. Supports debug/release builds, device installation, and comprehensive error diagnosis.
---

# Cordova APK Builder

Build Android APK packages from Cordova projects with automated environment checking and troubleshooting.

## Quick Start

### Build Debug APK
```bash
scripts/build_apk.sh
```

### Build Release APK
```bash
scripts/build_apk.sh --release
```

### Build and Install to Device
```bash
scripts/build_apk.sh --install
```

### Clean Build
```bash
scripts/build_apk.sh --clean --release
```

## Prerequisites Check

Run environment check before building:
```bash
scripts/check_environment.sh
```

This validates:
- Node.js and npm
- Cordova CLI
- Java JDK (11+)
- Android SDK (ANDROID_HOME)
- Android platform-tools
- Gradle

## Build Options

**`build_apk.sh` options:**
- `--release` - Build release APK (unsigned)
- `--install` - Install to connected device after build
- `--clean` - Clean build directories before building
- `--project DIR` - Specify project directory
- `--help` - Show help message

## Common Workflows

### First Time Build Setup

1. **Check environment:**
   ```bash
   scripts/check_environment.sh
   ```

2. **Fix any errors reported** (see troubleshooting.md)

3. **Build APK:**
   ```bash
   scripts/build_apk.sh
   ```

### Daily Development Build

```bash
# Quick debug build
scripts/build_apk.sh

# Test on device
scripts/build_apk.sh --install
```

### Release Build

```bash
# Clean release build
scripts/build_apk.sh --clean --release

# APK will be at:
# platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk
```

**Note:** Release APKs need signing before distribution. See references/troubleshooting.md section 10 for signing instructions.

## Troubleshooting

### Build Fails

1. **Run diagnostics:**
   ```bash
   scripts/check_environment.sh
   cordova requirements android
   ```

2. **Check detailed error:**
   ```bash
   cordova build android --verbose 2>&1 | tee build.log
   ```

3. **Consult troubleshooting guide:**
   See `references/troubleshooting.md` for detailed solutions to common errors:
   - ANDROID_HOME not set
   - Java JDK issues
   - Gradle build failures
   - SDK components missing
   - Memory errors
   - Network/proxy issues
   - Signing problems

### Quick Fixes

**Clear build cache:**
```bash
rm -rf platforms/android/app/build platforms/android/build
```

**Reinstall Android platform:**
```bash
cordova platform remove android
cordova platform add android
```

**Update Cordova and plugins:**
```bash
npm update
cordova platform update android
```

## Environment Setup

### Required Software

1. **Node.js** (v14+)
   - Download: https://nodejs.org/

2. **Cordova CLI**
   ```bash
   npm install -g cordova
   ```

3. **Java JDK** (11+)
   - Download: https://adoptium.net/

4. **Android Studio** (for SDK)
   - Download: https://developer.android.com/studio
   - Install Android SDK via SDK Manager
   - Accept all licenses

5. **Environment Variables**
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

See `references/troubleshooting.md` for complete setup instructions per platform.

## Output Locations

**Debug APK:**
```
platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

**Release APK (unsigned):**
```
platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk
```

## Device Installation

### Via Script
```bash
scripts/build_apk.sh --install
```

### Manually
```bash
# Using adb
adb install -r platforms/android/app/build/outputs/apk/debug/app-debug.apk

# Using Cordova
cordova run android
```

**Prerequisites:**
- Device connected via USB
- USB debugging enabled on device
- Device authorized for debugging

## Best Practices

1. **Always check environment first** when setting up on a new machine
2. **Use clean builds** when switching between debug/release
3. **Keep Cordova and plugins updated** to avoid compatibility issues
4. **Don't commit platforms/ directory** to version control
5. **Test on real devices** not just emulators

## Advanced Usage

### Custom Build Configuration

Edit `platforms/android/gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m
org.gradle.daemon=true
org.gradle.parallel=true
```

### Gradle Direct Build

```bash
cd platforms/android
./gradlew clean assembleDebug
./gradlew clean assembleRelease
```

### Check Build Info

```bash
# APK info
aapt dump badging platforms/android/app/build/outputs/apk/debug/app-debug.apk

# App version
grep version config.xml
```

## See Also

- **references/troubleshooting.md** - Comprehensive error solutions
- **Cordova docs** - https://cordova.apache.org/docs/
- **Android SDK docs** - https://developer.android.com/
