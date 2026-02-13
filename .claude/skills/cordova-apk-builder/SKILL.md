---
name: cordova-apk-builder
description: Automate building Android APK files from Cordova projects. Use when the user wants to build, package, or compile a Cordova app into an APK for Android devices. Triggers include requests like "build APK", "package my Cordova app", "generate Android package", "create APK from my app", or any mention of converting a Cordova project to a distributable Android application. Intelligently detects available build environments (local Android SDK vs GitHub Actions cloud build) and recommends the optimal strategy.
---

# Cordova APK Builder

Automate the complete workflow for building Android APK files from Cordova projects with intelligent environment detection and strategy recommendation.

## Workflow

### 1. Detect Environment

First, use the build detection script to analyze the project and available build tools:

```bash
cd /path/to/cordova/project
python /path/to/cordova-apk-builder/scripts/build_apk.py
```

The script automatically detects:
- Whether the current directory is a valid Cordova project (checks for `config.xml`)
- Android SDK availability (`ANDROID_HOME` environment variable)
- Git repository and GitHub Actions configuration
- App metadata (name, version, package ID from config.xml)

### 2. Strategy Recommendation

Based on environment detection, the script recommends one of three strategies:

**Local Build** (recommended when Android SDK is configured)
- Fastest option (1-2 minutes)
- Requires `ANDROID_HOME` environment variable
- Runs `cordova build android` locally
- APK output: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

**GitHub Actions** (recommended when no local SDK but Git + Actions configured)
- Cloud build in 3-5 minutes
- No local Android SDK needed
- Automatically pushes code and triggers workflow
- Download APK from GitHub Actions artifacts

**Setup Required** (when neither build method is available)
- Shows setup guide for configuring build environment
- Links to detailed documentation in `references/setup.md`

### 3. Execute Build

The script provides interactive prompts to execute the recommended strategy:

**For local builds:**
- Choose between debug (can install directly) or release (requires signing)
- Script runs `cordova build android` with appropriate flags
- Displays APK location and file size on completion

**For GitHub Actions:**
- Confirms uncommitted changes and commits them
- Pushes to main/master branch to trigger workflow
- Provides GitHub Actions URL for monitoring build progress
- Instructions for downloading APK from artifacts

### 4. Troubleshooting

If builds fail, consult the troubleshooting reference:

Common issues covered in `references/troubleshooting.md`:
- `ANDROID_HOME not found` - SDK configuration
- Gradle download timeouts - Mirror setup for China users
- SDK licenses not accepted - License agreement steps
- Platform not added - `cordova platform add android`
- Java version mismatch - JDK 11 requirement
- APK installation failures - Device permissions and compatibility
- GitHub Actions failures - Workflow configuration

## Resources

### scripts/build_apk.py

Intelligent build orchestrator (208 lines) that:
- Detects Cordova projects and parses app metadata
- Checks for Android SDK, Git, and GitHub Actions
- Recommends optimal build strategy
- Executes local builds or triggers cloud builds
- Provides detailed progress feedback and error messages

Execute directly: `python scripts/build_apk.py`

### references/setup.md

Comprehensive environment setup guide covering:
- Local build requirements (Node.js, Java JDK, Android SDK)
- Platform-specific setup (Windows, macOS, Linux)
- GitHub Actions workflow configuration
- APK signing for release builds
- Cordova CLI commands reference

Read when users need to configure their build environment.

### references/troubleshooting.md

Detailed solutions for common build issues:
- Build failures (SDK, Gradle, Java, platform issues)
- Installation problems (device permissions, compatibility)
- GitHub Actions issues (workflow errors, artifacts)
- Performance optimization (build speed, memory)
- FAQs (APK location, iOS builds, signing automation)

Read when builds fail or users encounter errors.

## Quick Reference

**Check if project is ready:**
```bash
cordova requirements android
```

**Build debug APK:**
```bash
cordova build android
```

**Build release APK:**
```bash
cordova build android --release
```

**Build and install to connected device:**
```bash
cordova run android
```

**APK locations:**
- Debug: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- Release: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`
