# Cordova APK 构建故障排除指南

## 常见错误及解决方案

### 1. ANDROID_HOME 未设置

**错误信息:**
```
Failed to find 'ANDROID_HOME' environment variable
ANDROID_SDK_ROOT=undefined
```

**解决方案:**

**Linux/Mac:**
```bash
# 找到 Android SDK 位置（通常在以下位置之一）
# ~/Android/Sdk
# ~/Library/Android/sdk
# /usr/local/android-sdk

# 添加到 ~/.bashrc 或 ~/.zshrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# 重新加载配置
source ~/.bashrc  # 或 source ~/.zshrc
```

**Windows:**
```
1. 搜索"环境变量"
2. 新建系统变量:
   变量名: ANDROID_HOME
   变量值: C:\Users\你的用户名\AppData\Local\Android\Sdk
3. 编辑 Path 变量，添加:
   %ANDROID_HOME%\tools
   %ANDROID_HOME%\platform-tools
4. 重启命令行窗口
```

### 2. Java JDK 未安装或版本不兼容

**错误信息:**
```
Failed to find 'java' command in your 'PATH'
Unsupported Java version
```

**解决方案:**

需要 JDK 11 或更高版本：

**下载安装:**
- Adoptium (推荐): https://adoptium.net/
- Oracle JDK: https://www.oracle.com/java/technologies/downloads/

**验证安装:**
```bash
java -version
# 应该显示 11.0 或更高版本
```

**设置 JAVA_HOME:**
```bash
# Linux/Mac
export JAVA_HOME=/path/to/jdk
export PATH=$JAVA_HOME/bin:$PATH

# Windows: 在环境变量中设置
JAVA_HOME=C:\Program Files\Java\jdk-11
```

### 3. Gradle 构建失败

**错误信息:**
```
Could not resolve all files for configuration
Failed to install the following Android SDK packages
```

**解决方案 A: 更新 Gradle Wrapper**
```bash
cd platforms/android
./gradlew wrapper --gradle-version 8.0
cd ../..
```

**解决方案 B: 清理并重建**
```bash
# 清理构建缓存
rm -rf platforms/android/app/build
rm -rf platforms/android/build

# 重新构建
cordova build android
```

**解决方案 C: 更新 Android 平台**
```bash
cordova platform remove android
cordova platform add android@latest
```

### 4. Android SDK 组件缺失

**错误信息:**
```
Failed to find target with hash string 'android-XX'
License for package ... not accepted
```

**解决方案:**

**使用 Android Studio (推荐):**
1. 打开 Android Studio
2. Tools → SDK Manager
3. 安装所需的 SDK Platform 和 Build Tools
4. 接受所有许可协议

**使用命令行:**
```bash
# 列出可用的包
sdkmanager --list

# 安装所需的包
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# 接受许可
sdkmanager --licenses
```

### 5. Cordova 未安装或版本过旧

**错误信息:**
```
cordova: command not found
```

**解决方案:**
```bash
# 安装最新版 Cordova
npm install -g cordova

# 验证安装
cordova -v

# 如果需要更新
npm update -g cordova
```

### 6. 内存不足

**错误信息:**
```
java.lang.OutOfMemoryError: Java heap space
Expiring Daemon because JVM heap space is exhausted
```

**解决方案:**

编辑 `platforms/android/gradle.properties` 添加:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m
org.gradle.daemon=true
org.gradle.parallel=true
```

### 7. 网络问题（无法下载依赖）

**错误信息:**
```
Could not GET 'https://...'
Read timed out
```

**解决方案 A: 配置代理**
```bash
# 设置 Gradle 代理
# 在 ~/.gradle/gradle.properties 添加:
systemProp.http.proxyHost=proxy.company.com
systemProp.http.proxyPort=8080
systemProp.https.proxyHost=proxy.company.com
systemProp.https.proxyPort=8080
```

**解决方案 B: 使用国内镜像**

编辑 `platforms/android/build.gradle`:
```gradle
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
        google()
        mavenCentral()
    }
}
```

### 8. 权限问题

**错误信息:**
```
Permission denied
EACCES: permission denied
```

**解决方案:**
```bash
# Linux/Mac: 修复 npm 权限
sudo chown -R $USER:$GROUP ~/.npm
sudo chown -R $USER:$GROUP ~/.config

# 或者使用 nvm 管理 Node.js 避免权限问题
```

### 9. Android 平台损坏

**错误信息:**
```
Error: Cannot read property 'X' of undefined
Cordova project's config.xml doesn't exist
```

**解决方案:**
```bash
# 完全移除并重新添加 Android 平台
cordova platform remove android
rm -rf platforms/android
cordova platform add android
```

### 10. 签名问题（发布版）

**错误信息:**
```
apksigner: ERROR: No input file specified
```

**解决方案:**

发布版 APK 需要签名才能安装。创建签名配置：

**1. 生成密钥库:**
```bash
keytool -genkey -v -keystore my-release-key.keystore \
  -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000
```

**2. 配置签名:**

创建或编辑 `platforms/android/release-signing.properties`:
```properties
storeFile=/path/to/my-release-key.keystore
storePassword=your-password
keyAlias=my-key-alias
keyPassword=your-password
```

**3. 构建签名的 APK:**
```bash
cordova build android --release
```

## 快速诊断流程

### Step 1: 运行环境检查
```bash
./scripts/check_environment.sh
```

### Step 2: 验证 Cordova 项目
```bash
cordova requirements
```

### Step 3: 尝试清理构建
```bash
./scripts/build_apk.sh --clean
```

### Step 4: 查看详细日志
```bash
cordova build android --verbose
```

## 获取帮助

### 查看构建日志
```bash
# Gradle 构建日志
cat platforms/android/app/build/outputs/logs/manifest-merger-debug-report.txt

# Cordova 日志
cordova build android --verbose 2>&1 | tee build.log
```

### 检查 Cordova 要求
```bash
cordova requirements android
```

### 测试 Gradle 构建
```bash
cd platforms/android
./gradlew clean
./gradlew assembleDebug
cd ../..
```

## 环境配置模板

### Linux/Mac (~/.bashrc 或 ~/.zshrc)
```bash
# Java
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Gradle (可选)
export GRADLE_HOME=$HOME/gradle
export PATH=$PATH:$GRADLE_HOME/bin
```

### Windows (系统环境变量)
```
JAVA_HOME=C:\Program Files\Java\jdk-11
ANDROID_HOME=C:\Users\YourName\AppData\Local\Android\Sdk

Path 添加:
%JAVA_HOME%\bin
%ANDROID_HOME%\tools
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\cmdline-tools\latest\bin
```

## 最佳实践

1. **始终使用最新版本:**
   - Cordova CLI
   - Android SDK Platform
   - Build Tools

2. **定期清理:**
   ```bash
   cordova clean
   rm -rf platforms/android/app/build
   ```

3. **保持依赖更新:**
   ```bash
   npm update
   cordova platform update android
   ```

4. **使用版本控制忽略:**
   ```
   platforms/
   plugins/
   node_modules/
   ```

5. **在多台机器上保持环境一致**
