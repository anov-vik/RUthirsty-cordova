# 🚀 喝水打卡 APK 构建指南

## 📦 项目已准备就绪

此项目已完全配置，可立即构建 Android APK。

### ✅ 项目包含内容

- ✅ Cordova 项目配置 (config.xml)
- ✅ 应用源代码 (www/)
- ✅ Android 平台配置 (platforms/android/)
- ✅ 自动化构建脚本 (cordova-build.sh)
- ✅ 完整文档和指南

### 📱 应用信息

- **应用名称**: 喝水打卡
- **版本**: 1.1.0
- **包名**: com.ruthirsty.app
- **目标平台**: Android API 22+

## 🏗️ 构建 APK 的三种方法

### 方法 1: 使用自动化脚本（最简单）

```bash
# 1. 确保已安装 Android SDK 和配置环境变量
# 2. 运行构建脚本
./cordova-build.sh

# 生成的 APK 位置：
# platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### 方法 2: 使用 Cordova 命令

```bash
# 检查环境
cordova requirements android

# 构建调试版本
cordova build android

# 构建发布版本
cordova build android --release
```

### 方法 3: 使用 Android Studio

1. 打开 Android Studio
2. 选择 "Open an Existing Project"
3. 导航到 `platforms/android` 目录
4. 点击 "Build" → "Build Bundle(s) / APK(s)" → "Build APK(s)"

## 🔧 环境配置（首次构建需要）

### Windows

1. **安装 Android Studio**
   - 下载: https://developer.android.com/studio
   - 安装 Android SDK、Build Tools、Command-line Tools

2. **设置环境变量**
   ```cmd
   setx ANDROID_HOME "%LOCALAPPDATA%\Android\Sdk"
   setx PATH "%PATH%;%LOCALAPPDATA%\Android\Sdk\platform-tools"
   ```

3. **安装依赖**
   ```cmd
   npm install -g cordova
   ```

### macOS

1. **安装 Android Studio**
   ```bash
   brew install --cask android-studio
   ```

2. **设置环境变量** (添加到 ~/.zshrc 或 ~/.bash_profile)
   ```bash
   export ANDROID_HOME=$HOME/Library/Android/sdk
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/tools
   ```

3. **安装依赖**
   ```bash
   npm install -g cordova
   ```

### Linux (Ubuntu/Debian)

1. **安装 Java JDK**
   ```bash
   sudo apt update
   sudo apt install openjdk-11-jdk
   ```

2. **安装 Android SDK**
   ```bash
   # 下载并解压 Android command-line tools
   wget https://dl.google.com/android/repository/commandlinetools-linux-latest.zip
   unzip commandlinetools-linux-latest.zip
   mkdir -p $HOME/Android/Sdk/cmdline-tools/latest
   mv cmdline-tools/* $HOME/Android/Sdk/cmdline-tools/latest/
   ```

3. **设置环境变量** (添加到 ~/.bashrc)
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/platform-tools
   export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
   ```

4. **安装 SDK 组件**
   ```bash
   sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
   ```

## 📲 快速开始（已有环境）

如果你的机器上已经配置好 Android 开发环境：

```bash
# 1. 解压项目
unzip RUthirsty-cordova.zip
cd RUthirsty-cordova

# 2. 安装依赖（可选）
npm install

# 3. 一键构建
./cordova-build.sh

# 4. 查看 APK
ls -lh platforms/android/app/build/outputs/apk/debug/
```

## 🎯 构建输出

### 调试版本
- **路径**: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`
- **大小**: 约 3-5 MB
- **用途**: 开发测试
- **安装**: 可直接安装到设备

### 发布版本
- **路径**: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`
- **大小**: 约 2-4 MB（优化后）
- **用途**: 正式发布
- **注意**: 需要签名才能安装

## 🔐 签名 APK（发布版本）

```bash
# 1. 生成密钥
keytool -genkey -v -keystore my-release-key.keystore \
  -alias my-app \
  -keyalg RSA -keysize 2048 -validity 10000

# 2. 签名
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 \
  -keystore my-release-key.keystore \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  my-app

# 3. 对齐
zipalign -v 4 \
  platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk \
  RUthirsty-v1.1.0.apk
```

## 📱 安装到设备

### USB 安装
```bash
# 连接设备并开启 USB 调试
cordova run android

# 或使用 adb
adb install -r platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

### 手动安装
1. 将 APK 文件传输到手机
2. 在手机上打开文件管理器
3. 点击 APK 文件
4. 允许安装未知来源应用
5. 安装完成

## 🐛 常见问题

### Q1: 构建失败，提示找不到 SDK
**A**: 确保已设置 ANDROID_HOME 环境变量
```bash
echo $ANDROID_HOME  # Linux/Mac
echo %ANDROID_HOME%  # Windows
```

### Q2: Gradle 下载很慢
**A**: 配置 Gradle 使用国内镜像（中国用户）
```bash
# 编辑 ~/.gradle/init.gradle
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
    }
}
```

### Q3: 构建成功但无法安装
**A**: 
- 检查设备是否允许安装未知来源应用
- 确保 APK 已签名（发布版本）
- 尝试卸载旧版本后重新安装

### Q4: 应用闪退
**A**: 
- 检查 Android 版本是否 >= 5.1（API 22）
- 查看 logcat 日志：`adb logcat | grep ruthirsty`

## 📖 更多文档

- `CORDOVA_BUILD_GUIDE.md` - 详细构建指南
- `ANDROID_BUILD_GUIDE.md` - Android 环境配置
- `README_APP.md` - 应用功能说明
- `CHANGELOG.md` - 版本更新记录

## 🎨 应用特性

- 💧 喝水打卡记录
- 📊 每日统计分析
- ⏰ 定时提醒（7次/天）
- 🎨 毛玻璃界面设计
- 🌈 主题自动切换（紫色→绿色）
- 💾 本地数据持久化

## 🔗 技术栈

- **框架**: Apache Cordova 13.0.0
- **平台**: Android (cordova-android 12.0.1)
- **前端**: HTML5 + CSS3 + JavaScript
- **存储**: localStorage
- **最小支持**: Android 5.1+ (API 22)
- **目标版本**: Android 13 (API 33)

## 💡 提示

1. 首次构建可能需要下载大量依赖，请耐心等待
2. 建议使用 SSD 硬盘，构建速度更快
3. 确保网络连接良好（Gradle 需要下载依赖）
4. 推荐内存 >= 8GB
5. 磁盘空间 >= 10GB（Android SDK 占用较大）

## 🚀 一键构建脚本说明

`cordova-build.sh` 提供以下功能：

- ✅ 自动检查所有依赖
- ✅ 智能提示缺失的环境
- ✅ 彩色输出，清晰易读
- ✅ 显示构建进度和耗时
- ✅ 自动报告 APK 位置和大小
- ✅ 提供下一步操作建议

**使用方法**:
```bash
./cordova-build.sh          # 调试版本
./cordova-build.sh release  # 发布版本
./cordova-build.sh clean    # 清理重建
./cordova-build.sh run      # 构建并安装
./cordova-build.sh help     # 查看帮助
```

---

**祝构建顺利！** 🎉

如有问题，请参考详细文档或检查 Cordova 官方文档。
