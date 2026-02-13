# Troubleshooting Common Issues

## Build Failures

### ANDROID_HOME not found
**Error**: `Failed to find 'ANDROID_HOME' environment variable`

**Solution**:
```bash
# Check if set
echo $ANDROID_HOME  # Linux/Mac
echo %ANDROID_HOME%  # Windows

# Set it (add to shell config for persistence)
export ANDROID_HOME=$HOME/Library/Android/sdk  # Mac
export ANDROID_HOME=$HOME/Android/Sdk  # Linux
set ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk  # Windows
```

### Gradle download timeout
**Error**: `Could not GET 'https://services.gradle.org/...'`

**Solution** (China users):
```bash
# Create ~/.gradle/init.gradle
mkdir -p ~/.gradle
cat > ~/.gradle/init.gradle << 'EOF'
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
    }
}
EOF
```

### SDK licenses not accepted
**Error**: `You have not accepted the license agreements`

**Solution**:
```bash
cd $ANDROID_HOME/cmdline-tools/latest/bin
./sdkmanager --licenses
# Type 'y' for each license
```

### Platform not added
**Error**: `Current working directory is not a Cordova-based project`

**Solution**:
```bash
cordova platform add android
```

### Java version mismatch
**Error**: `Unsupported class file major version XX`

**Solution**:
Use JDK 11:
```bash
# Check Java version
java -version

# Install JDK 11
# macOS: brew install openjdk@11
# Linux: sudo apt install openjdk-11-jdk
# Windows: Download from Oracle
```

## Installation Issues

### APK won't install on device
**Symptoms**: "App not installed" error

**Solutions**:
1. Enable "Unknown sources"
   - Settings → Security → Unknown sources → Enable

2. Uninstall old version
   - Settings → Apps → [App Name] → Uninstall

3. Check Android version compatibility
   - App requires Android 5.1+ (API 22)

4. For release builds: Ensure APK is signed

### Device not detected (adb)
**Symptoms**: `adb devices` shows no devices

**Solutions**:
1. Enable USB debugging
   - Settings → About phone → Tap "Build number" 7 times
   - Settings → Developer options → USB debugging → Enable

2. Reconnect USB cable

3. Authorize computer on device

4. Check USB drivers (Windows)
   - Install manufacturer-specific drivers

## GitHub Actions Issues

### Build failing in Actions
**Check**:
1. View workflow logs in Actions tab
2. Look for red X steps
3. Common issues:
   - Missing dependencies in workflow
   - Incorrect branch name
   - Platform not added

**Solution**: Check workflow file matches template in `setup.md`

### Cannot find workflow
**Check**:
1. File exists: `.github/workflows/build-apk.yml`
2. File pushed to GitHub: `git push origin main`
3. Workflow enabled in Settings → Actions

### Artifacts not showing
**Wait**: Build must complete (green ✓) before artifacts appear

**Check**: Scroll to bottom of completed workflow page

## Performance Issues

### Build very slow
**Causes**:
- First build downloads dependencies (10-30 min normal)
- Slow network
- Low disk space

**Solutions**:
- Use SSD
- Configure Gradle daemon:
  ```bash
  # Add to ~/.gradle/gradle.properties
  org.gradle.daemon=true
  org.gradle.parallel=true
  org.gradle.caching=true
  ```

### Out of memory
**Error**: `OutOfMemoryError: Java heap space`

**Solution**:
```bash
# Add to platforms/android/gradle.properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m
```

## Common Questions

**Q: Where is the APK file?**
A:
- Debug: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- Release: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`

**Q: Can I build without Android Studio?**
A: Yes, install command-line tools only. See `setup.md`.

**Q: How to build for iOS?**
A: This skill focuses on Android. iOS requires macOS and Xcode.

**Q: Can I automate signing?**
A: Yes, configure in `platforms/android/app/build.gradle`. See Cordova docs.

**Q: How to reduce APK size?**
A: Use ProGuard, optimize images, remove unused resources. Build release version.
