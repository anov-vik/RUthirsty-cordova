# Android 构建完整指南

## 📱 在本地环境构建 Android APK

由于 Codespaces 环境没有 Android SDK，你需要在本地机器上构建 Android 应用。

### 前置要求

#### 1. 安装 Node.js 和 npm
- 下载地址: https://nodejs.org/
- 推荐版本: v14 或更高

#### 2. 安装 Java JDK
- 下载地址: https://www.oracle.com/java/technologies/downloads/
- 推荐版本: JDK 11 或 JDK 17
- 验证安装: `java -version`

#### 3. 安装 Android Studio 和 SDK

##### Windows:
1. 下载 Android Studio: https://developer.android.com/studio
2. 安装 Android Studio
3. 打开 SDK Manager 安装以下组件:
   - Android SDK Platform (API Level 33)
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android Emulator
4. 设置环境变量:
   ```cmd
   setx ANDROID_HOME "%LOCALAPPDATA%\Android\Sdk"
   setx PATH "%PATH%;%LOCALAPPDATA%\Android\Sdk\platform-tools"
   ```

##### macOS:
1. 下载 Android Studio: https://developer.android.com/studio
2. 安装 Android Studio
3. 打开 SDK Manager 安装必要组件
4. 在 `~/.bash_profile` 或 `~/.zshrc` 中添加:
   ```bash
   export ANDROID_HOME=$HOME/Library/Android/sdk
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/tools
   export PATH=$PATH:$ANDROID_HOME/tools/bin
   ```
5. 运行 `source ~/.bash_profile` 或 `source ~/.zshrc`

##### Linux:
1. 下载 Android Studio: https://developer.android.com/studio
2. 解压并安装
3. 在 `~/.bashrc` 中添加:
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/tools
   export PATH=$PATH:$ANDROID_HOME/tools/bin
   ```
4. 运行 `source ~/.bashrc`

#### 4. 安装 Gradle (通常 Android Studio 会自动安装)

### 🚀 构建步骤

#### 方法 1: 使用自动化脚本（推荐）

1. **克隆或下载项目到本地**
   ```bash
   git clone <your-repo-url>
   cd RUthirsty-cordova
   ```

2. **运行构建脚本**
   ```bash
   # Linux/macOS
   chmod +x build-android.sh
   ./build-android.sh

   # 构建发布版本
   ./build-android.sh release
   ```

   ```cmd
   # Windows (使用 Git Bash 或 WSL)
   bash build-android.sh
   ```

#### 方法 2: 手动构建

1. **克隆项目到本地**
   ```bash
   git clone <your-repo-url>
   cd RUthirsty-cordova
   ```

2. **安装 Cordova CLI**
   ```bash
   npm install -g cordova
   ```

3. **添加 Android 平台** (如果还没有)
   ```bash
   cordova platform add android
   ```

4. **检查环境要求**
   ```bash
   cordova requirements android
   ```

   确保所有检查都通过 ✅

5. **构建调试版本**
   ```bash
   cordova build android
   ```

   APK 位置: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

6. **构建发布版本**
   ```bash
   cordova build android --release
   ```

   APK 位置: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`

### 📲 安装到设备

#### 方法 1: 使用 Cordova CLI

1. **启用 USB 调试**
   - 在 Android 设备上: 设置 → 关于手机 → 连续点击"版本号" 7 次
   - 设置 → 开发者选项 → 开启 USB 调试

2. **连接设备并运行**
   ```bash
   cordova run android
   ```

#### 方法 2: 手动安装 APK

1. **将 APK 传输到手机**
   - 通过 USB 复制
   - 通过邮件发送
   - 通过云存储

2. **在手机上安装**
   - 设置 → 安全 → 允许安装未知来源的应用
   - 使用文件管理器打开 APK 并安装

### 🔐 签名发布版本

发布到 Google Play 需要签名的 APK:

1. **生成密钥库**
   ```bash
   keytool -genkey -v -keystore my-release-key.keystore -alias my-app-alias -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **签名 APK**
   ```bash
   jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk my-app-alias
   ```

3. **对齐 APK**
   ```bash
   zipalign -v 4 platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk RUthirsty-signed.apk
   ```

### 📦 使用模拟器测试

1. **启动 Android Studio 创建模拟器**
   - Tools → AVD Manager
   - Create Virtual Device
   - 选择设备型号和系统镜像

2. **运行在模拟器**
   ```bash
   cordova emulate android
   ```

### ❓ 常见问题

**Q: `ANDROID_HOME` 找不到?**
```bash
# 检查是否设置
echo $ANDROID_HOME

# 手动设置 (临时)
export ANDROID_HOME=~/Android/Sdk
```

**Q: Gradle 构建失败?**
- 检查网络连接（Gradle 需要下载依赖）
- 尝试在 `platforms/android/` 目录运行 `./gradlew clean`

**Q: 应用无法安装?**
- 确保已开启"允许安装未知来源"
- 卸载旧版本再安装
- 检查 APK 是否损坏

**Q: SDK licenses 未接受?**
```bash
cd $ANDROID_HOME/tools/bin
./sdkmanager --licenses
# 输入 'y' 接受所有许可
```

### 📚 更多资源

- Cordova 官方文档: https://cordova.apache.org/docs/
- Android 开发者文档: https://developer.android.com/
- 环境配置指南: https://cordova.apache.org/docs/en/latest/guide/platforms/android/

---

## 🌐 方案 2: 在线预览（当前可用）

应用已在 Codespaces 的端口 8080 上运行，你可以:

1. 在浏览器中测试所有功能
2. 使用手机浏览器访问（需要公开端口）
3. 进行界面和功能调试

这对于开发和测试非常有用！

---

## 📤 方案 3: 下载项目到本地

1. **从 Codespaces 下载项目**
   - 使用 git clone 到本地机器
   - 或者下载 ZIP 文件

2. **在本地构建**
   - 按照上述"在本地环境构建"的步骤操作
   - 使用提供的 `build-android.sh` 脚本

---

**推荐流程**:
1. ✅ 在 Codespaces 中开发和测试（当前）
2. ✅ 下载项目到本地
3. ✅ 在本地机器上构建 APK
4. ✅ 安装到 Android 设备
